import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/brand_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/subcategory_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/price_repository.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/subcategory_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/price_repository_impl.dart';
import 'datasource_providers.dart';

final brandRepositoryProvider = Provider<BrandRepository>((ref) {
  final remoteDatasource = ref.watch(remoteDatasourceProvider);
  final localDatasource = ref.watch(localDatasourceProvider);
  return BrandRepositoryImpl(remoteDatasource, localDatasource);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final remoteDatasource = ref.watch(remoteDatasourceProvider);
  final localDatasource = ref.watch(localDatasourceProvider);
  return CategoryRepositoryImpl(remoteDatasource, localDatasource);
});

final subcategoryRepositoryProvider = Provider<SubcategoryRepository>((ref) {
  final remoteDatasource = ref.watch(remoteDatasourceProvider);
  final localDatasource = ref.watch(localDatasourceProvider);
  return SubcategoryRepositoryImpl(remoteDatasource, localDatasource);
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDatasource = ref.watch(remoteDatasourceProvider);
  final localDatasource = ref.watch(localDatasourceProvider);
  return ProductRepositoryImpl(remoteDatasource, localDatasource);
});

final priceRepositoryProvider = Provider<PriceRepository>((ref) {
  final remoteDatasource = ref.watch(remoteDatasourceProvider);
  final localDatasource = ref.watch(localDatasourceProvider);
  return PriceRepositoryImpl(remoteDatasource, localDatasource);
});