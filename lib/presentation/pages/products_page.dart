import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/subcategory.dart';
import '../../domain/entities/product.dart';
import '../../application/providers/product_providers.dart';
import '../../application/providers/connectivity_provider.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/sync_button.dart';
import '../widgets/modern_product_card.dart';

class ProductsPage extends ConsumerWidget {
  final String? categoryId;
  final String? subcategoryId;
  final String? brandId;
  final String? searchQuery;

  const ProductsPage({
    super.key,
    this.categoryId,
    this.subcategoryId,
    this.brandId,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = _getProducts(ref);
    final totalProductsAsync = ref.watch(totalProductsProvider);
    final currentPage = ref.watch(currentPageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_getTitle())),
      body: Column(
        children: [
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay productos disponibles',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ModernProductCard(product: products[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
            ),
          ),
          // Controles de paginación
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: currentPage > 1
                      ? () => ref.read(currentPageProvider.notifier).state--
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                totalProductsAsync.when(
                  data: (total) {
                    final totalPages = (total / productsPerPage).ceil();
                    return Text(
                      'Página $currentPage de $totalPages',
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error'),
                ),
                IconButton(
                  onPressed: totalProductsAsync.whenOrNull(
                    data: (total) {
                      final totalPages = (total / productsPerPage).ceil();
                      return currentPage < totalPages
                          ? () => ref.read(currentPageProvider.notifier).state++
                          : null;
                    },
                  ),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AsyncValue<List<Product>> _getProducts(WidgetRef ref) {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      return ref.watch(paginatedSearchProductsProvider(searchQuery!));
    } else if (subcategoryId != null) {
      return ref.watch(paginatedProductsBySubcategoryProvider(subcategoryId!));
    } else if (categoryId != null) {
      return ref.watch(paginatedProductsByCategoryProvider(categoryId!));
    } else if (brandId != null) {
      return ref.watch(paginatedProductsByBrandProvider(brandId!));
    } else {
      return ref.watch(paginatedProductsProvider);
    }
  }

  String _getTitle() {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      return 'Resultados para: $searchQuery';
    } else if (subcategoryId != null) {
      return 'Productos por Subcategoría';
    } else if (categoryId != null) {
      return 'Productos por Categoría';
    } else if (brandId != null) {
      return 'Productos por Marca';
    } else {
      return 'Todos los Productos';
    }
  }
}

class _EmptyProductsView extends StatelessWidget {
  const _EmptyProductsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 64),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No hay productos disponibles',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No se encontraron productos para este filtro',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
