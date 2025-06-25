import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/subcategory.dart';
import 'repository_providers.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getCategories();
});

final categoryByIdProvider = FutureProvider.family<Category?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.getCategoryById(id);
});

final syncCategoriesProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.syncCategories();
});

// Provider para obtener todas las subcategorías
final subcategoriesProvider = FutureProvider<List<Subcategory>>((ref) async {
  final repository = ref.watch(subcategoryRepositoryProvider);
  return await repository.getSubcategories();
});

// Provider para obtener las subcategorías de una categoría específica
final subcategoriesByCategoryProvider =
    FutureProvider.family<List<Subcategory>, String>((ref, categoryId) async {
      final repository = ref.watch(subcategoryRepositoryProvider);
      final subcategories = await repository.getSubcategories();
      return subcategories
          .where((sub) => sub.categoryId == categoryId && sub.isActive)
          .toList();
    });

// Provider para controlar qué categoría está expandida
final expandedCategoryProvider = StateProvider<String?>((ref) => null);
