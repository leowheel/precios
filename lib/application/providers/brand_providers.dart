import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/brand.dart';
import 'repository_providers.dart';

final brandsProvider = FutureProvider<List<Brand>>((ref) async {
  final repository = ref.watch(brandRepositoryProvider);
  return await repository.getBrands();
});

final brandByIdProvider = FutureProvider.family<Brand?, String>((ref, id) async {
  final repository = ref.watch(brandRepositoryProvider);
  return await repository.getBrandById(id);
});

final syncBrandsProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(brandRepositoryProvider);
  return await repository.syncBrands();
});