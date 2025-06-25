import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../application/providers/local_data_status_provider.dart';
import '../../application/providers/connectivity_provider.dart';
import '../../application/providers/sync_provider.dart';
import '../widgets/sync_button.dart';
import 'brands_page.dart';
import 'categories_page.dart';
import 'sync_page.dart';
import 'login_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataStatusAsync = ref.watch(localDataStatusProvider);
    final connectivityAsync = ref.watch(connectivityProvider);

    return dataStatusAsync.when(
      data: (dataStatus) {
        if (!dataStatus.hasData) {
          Future.microtask(() {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SyncPage()),
            );
          });
          return const _LoadingView();
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Catálogo'),
            actions: [
              // Botón de búsqueda
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // TODO: Implementar búsqueda
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(),
                  );
                },
                tooltip: 'Buscar productos',
              ),
              // Botón de sincronización (solo si hay conexión)
              connectivityAsync.when(
                data: (isOnline) => isOnline
                    ? SyncButton(syncProvider: syncAllDataProvider)
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              // Botón de cerrar sesión
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                },
                tooltip: 'Cerrar Sesión',
              ),
            ],
          ),
          body: const _HomeBody(),
        );
      },
      loading: () => const Scaffold(body: _LoadingView()),
      error: (error, _) {
        debugPrint('Error en dataStatus: $error');
        Future.microtask(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SyncPage()),
          );
        });
        return const Scaffold(body: _LoadingView());
      },
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (context.isMobile) {
          return const _MobileLayout();
        } else {
          return const _TabletLayout();
        }
      },
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: _CategoryGrid(),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: _CategoryGrid(),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Marcas', 'icon': Icons.local_offer, 'color': Colors.blue},
      {'name': 'Categorías', 'icon': Icons.category, 'color': Colors.green},
      {
        'name': 'Ofertas',
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isMobile ? 2 : 3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryCard(
          name: category['name'] as String,
          icon: category['icon'] as IconData,
          color: category['color'] as Color,
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (name == 'Marcas') {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const BrandsPage()));
          } else if (name == 'Categorías') {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CategoriesPage()),
            );
          }
          // TODO: Implement Ofertas
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: AppSpacing.sm),
              Text(
                name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Cargando datos locales...'),
        ],
      ),
    );
  }
}

// Delegate para la búsqueda de productos
class ProductSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Center(
        child: Text(
          'Ingresa al menos 3 caracteres para buscar',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    // TODO: Implementar la búsqueda de productos
    return Center(child: Text('Resultados para: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Ingresa el nombre o código del producto',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    // TODO: Implementar sugerencias de búsqueda
    return const SizedBox.shrink();
  }
}
