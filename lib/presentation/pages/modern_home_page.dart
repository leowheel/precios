import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../application/providers/local_data_status_provider.dart';
import '../../application/providers/brand_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/product_providers.dart';
import '../../application/providers/connectivity_provider.dart';
import '../../application/providers/sync_provider.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/subcategory.dart';
import '../../domain/entities/product.dart';
import '../widgets/modern_brand_card.dart';
import '../widgets/modern_product_card.dart';
import '../widgets/sync_button.dart';
import 'sync_page.dart';
import '../widgets/horizontal_category_menu.dart';

class ModernHomePage extends ConsumerStatefulWidget {
  const ModernHomePage({super.key});

  @override
  ConsumerState<ModernHomePage> createState() => _ModernHomePageState();
}

class _ModernHomePageState extends ConsumerState<ModernHomePage> {
  String? selectedBrandId;
  String? selectedCategoryId;
  String? selectedSubcategoryId;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final dataStatusAsync = ref.watch(localDataStatusProvider);
    final theme = Theme.of(context);
    final brandsAsync = ref.watch(brandsProvider);
    final productsAsync = _getFilteredProducts();

    return dataStatusAsync.when(
      data: (dataStatus) {
        if (!dataStatus.hasData) {
          return _buildSyncRequiredView();
        }
        return _buildMainView();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => _buildSyncRequiredView(),
    );
  }

  Widget _buildSyncRequiredView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_sync,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Sincronización Requerida',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Para comenzar necesitas sincronizar los datos',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SyncPage()),
                );
              },
              icon: const Icon(Icons.sync),
              label: const Text('Sincronizar Ahora'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainView() {
    final connectivityAsync = ref.watch(connectivityProvider);
    final theme = Theme.of(context);
    final brandsAsync = ref.watch(brandsProvider);
    final productsAsync = _getFilteredProducts();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              expandedHeight: 160,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Catálogo de Productos',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Explora nuestra selección',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              // Sync button
                              connectivityAsync.when(
                                data: (isOnline) => isOnline
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: SyncButton(
                                          syncProvider: syncAllDataProvider,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                loading: () => const SizedBox.shrink(),
                                error: (_, __) => const SizedBox.shrink(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildSearchBar(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBrandsSection(),
              const SizedBox(height: 24),
              _buildCategoriesSection(),
              const SizedBox(height: 24),
              _buildProductsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandsSection() {
    final brandsAsync = ref.watch(brandsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.local_offer,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Marcas',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: brandsAsync.when(
            data: (brands) {
              if (brands.isEmpty) {
                return const Center(child: Text('No hay marcas disponibles'));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  final isSelected = selectedBrandId == brand.id;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ModernBrandCard(
                      brand: brand,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          selectedBrandId = isSelected ? null : brand.id;
                          selectedCategoryId = null;
                          selectedSubcategoryId = null;
                        });
                      },
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) =>
                const Center(child: Text('Error cargando marcas')),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        HorizontalCategoryMenu(
          selectedCategoryId: selectedCategoryId,
          selectedSubcategoryId: selectedSubcategoryId,
          onCategorySelected: (categoryId) {
            setState(() {
              selectedCategoryId = categoryId;
              selectedSubcategoryId = null;
            });
          },
          onSubcategorySelected: (subcategoryId) {
            setState(() {
              selectedSubcategoryId = subcategoryId;
            });
          },
          onClearFilters: () {
            setState(() {
              selectedCategoryId = null;
              selectedSubcategoryId = null;
            });
            ref.read(expandedCategoryProvider.notifier).state = null;
          },
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    AsyncValue<List<Product>> productsAsync;

    if (searchQuery.isNotEmpty && searchQuery.length >= 3) {
      productsAsync = ref.watch(searchProductsProvider(searchQuery));
    } else if (selectedBrandId != null) {
      productsAsync = ref.watch(productsByBrandProvider(selectedBrandId!));
    } else if (selectedSubcategoryId != null) {
      productsAsync = ref.watch(
        productsBySubcategoryProvider(selectedSubcategoryId!),
      );
    } else if (selectedCategoryId != null) {
      productsAsync = ref.watch(
        productsByCategoryProvider(selectedCategoryId!),
      );
    } else {
      productsAsync = ref.watch(productsProvider);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.inventory_2,
                color: Theme.of(context).colorScheme.tertiary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _getProductsSectionTitle(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return _buildEmptyProductsView();
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.isMobile
                        ? 2
                        : context.isTablet
                        ? 4
                        : 5,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ModernProductCard(product: products[index]);
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Error al cargar los productos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () {
                    if (selectedBrandId != null) {
                      ref.refresh(productsByBrandProvider(selectedBrandId!));
                    } else if (selectedSubcategoryId != null) {
                      ref.refresh(
                        productsBySubcategoryProvider(selectedSubcategoryId!),
                      );
                    } else if (selectedCategoryId != null) {
                      ref.refresh(
                        productsByCategoryProvider(selectedCategoryId!),
                      );
                    } else if (searchQuery.isNotEmpty) {
                      ref.refresh(searchProductsProvider(searchQuery));
                    } else {
                      ref.refresh(productsProvider);
                    }
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyProductsView() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay productos disponibles',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'No se encontraron productos para los filtros seleccionados',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getProductsSectionTitle() {
    if (searchQuery.isNotEmpty && searchQuery.length >= 3) {
      return 'Resultados de búsqueda';
    } else if (selectedBrandId != null) {
      return 'Productos por marca';
    } else if (selectedSubcategoryId != null) {
      return 'Productos por subcategoría';
    } else if (selectedCategoryId != null) {
      return 'Productos por categoría';
    } else {
      return 'Todos los productos';
    }
  }

  AsyncValue<List<Product>> _getFilteredProducts() {
    if (selectedSubcategoryId != null) {
      return ref.watch(productsBySubcategoryProvider(selectedSubcategoryId!));
    } else if (selectedCategoryId != null) {
      return ref.watch(productsByCategoryProvider(selectedCategoryId!));
    } else {
      return ref.watch(productsProvider);
    }
  }
}
