import '../entities/brand.dart';

abstract class BrandRepository {
  Future<List<Brand>> getBrands();
  Future<Brand?> getBrandById(String id);
  Future<void> syncBrands();
}