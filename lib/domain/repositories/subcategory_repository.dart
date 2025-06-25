import '../entities/subcategory.dart';

abstract class SubcategoryRepository {
  Future<List<Subcategory>> getSubcategories();
  Future<List<Subcategory>> getSubcategoriesByCategory(String categoryId);
  Future<void> syncSubcategories();
}
