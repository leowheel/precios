import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> getProductsByBrand(String brandId);
  Future<List<Product>> getProductsByCategory(String categoryId);
  Future<List<Product>> getProductsBySubcategory(String subcategoryId);
  Future<List<Product>> searchProducts(String query);
  Future<Product?> getProductById(String id);
  Future<void> syncProducts();
}