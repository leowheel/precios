import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import '../../core/services/connectivity_service.dart';
import '../datasources/remote/remote_datasource.dart';
import '../datasources/local/local_datasource.dart';

class BrandRepositoryImpl implements BrandRepository {
  final RemoteDatasource _remoteDatasource;
  final LocalDatasource _localDatasource;

  BrandRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Brand>> getBrands() async {
    final brands = await _localDatasource.getBrands();
    return brands
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Future<Brand?> getBrandById(String id) async {
    return await _localDatasource.getBrandById(id);
  }

  @override
  Future<void> syncBrands() async {
    if (!ConnectivityService.isOnline) return;

    try {
      final remoteBrands = await _remoteDatasource.getBrands();
      await _localDatasource.saveBrands(remoteBrands);
    } catch (e) {
      throw Exception('Failed to sync brands: $e');
    }
  }
}
