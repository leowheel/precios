import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import 'repository_providers.dart';

const int productsPerPage = 20;

// Estado para mantener la página actual
final currentPageProvider = StateProvider<int>((ref) => 1);

// Provider para obtener todos los productos paginados
final paginatedProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final currentPage = ref.watch(currentPageProvider);
  final allProducts = await repository.getProducts();

  final startIndex = (currentPage - 1) * productsPerPage;
  final endIndex = startIndex + productsPerPage;

  return allProducts.sublist(
    startIndex,
    endIndex > allProducts.length ? allProducts.length : endIndex,
  );
});

// Provider para obtener el total de productos
final totalProductsProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final products = await repository.getProducts();
  return products.length;
});

// Provider para obtener productos por marca paginados
final paginatedProductsByBrandProvider =
    FutureProvider.family<List<Product>, String>((ref, brandId) async {
      final repository = ref.watch(productRepositoryProvider);
      final currentPage = ref.watch(currentPageProvider);
      final products = await repository.getProductsByBrand(brandId);

      final startIndex = (currentPage - 1) * productsPerPage;
      final endIndex = startIndex + productsPerPage;

      return products.sublist(
        startIndex,
        endIndex > products.length ? products.length : endIndex,
      );
    });

// Provider para obtener productos por categoría paginados
final paginatedProductsByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, categoryId) async {
      final repository = ref.watch(productRepositoryProvider);
      final currentPage = ref.watch(currentPageProvider);
      final products = await repository.getProductsByCategory(categoryId);

      final startIndex = (currentPage - 1) * productsPerPage;
      final endIndex = startIndex + productsPerPage;

      return products.sublist(
        startIndex,
        endIndex > products.length ? products.length : endIndex,
      );
    });

// Provider para obtener productos por subcategoría paginados
final paginatedProductsBySubcategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, subcategoryId) async {
      final repository = ref.watch(productRepositoryProvider);
      final currentPage = ref.watch(currentPageProvider);
      final products = await repository.getProductsBySubcategory(subcategoryId);

      final startIndex = (currentPage - 1) * productsPerPage;
      final endIndex = startIndex + productsPerPage;

      return products.sublist(
        startIndex,
        endIndex > products.length ? products.length : endIndex,
      );
    });

// Provider para búsqueda de productos paginada
final paginatedSearchProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, query) async {
      final repository = ref.watch(productRepositoryProvider);
      final currentPage = ref.watch(currentPageProvider);
      final products = await repository.searchProducts(query);

      final startIndex = (currentPage - 1) * productsPerPage;
      final endIndex = startIndex + productsPerPage;

      return products.sublist(
        startIndex,
        endIndex > products.length ? products.length : endIndex,
      );
    });

// Providers existentes sin paginación (mantener para compatibilidad)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProducts();
});

final productsByBrandProvider = FutureProvider.family<List<Product>, String>((
  ref,
  brandId,
) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProductsByBrand(brandId);
});

final productsByCategoryProvider = FutureProvider.family<List<Product>, String>(
  (ref, categoryId) async {
    final repository = ref.watch(productRepositoryProvider);
    return await repository.getProductsByCategory(categoryId);
  },
);

final productsBySubcategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, subcategoryId) async {
      final repository = ref.watch(productRepositoryProvider);
      return await repository.getProductsBySubcategory(subcategoryId);
    });

final searchProductsProvider = FutureProvider.family<List<Product>, String>((
  ref,
  query,
) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.searchProducts(query);
});

final productByIdProvider = FutureProvider.family<Product?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProductById(id);
});

final syncProductsProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.syncProducts();
});
