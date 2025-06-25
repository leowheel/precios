import '../../domain/entities/subcategory.dart';
import '../../domain/repositories/subcategory_repository.dart';
import '../../core/services/connectivity_service.dart';
import '../datasources/remote/remote_datasource.dart';
import '../datasources/local/local_datasource.dart';

class SubcategoryRepositoryImpl implements SubcategoryRepository {
  final RemoteDatasource _remoteDatasource;
  final LocalDatasource _localDatasource;

  SubcategoryRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Subcategory>> getSubcategories() async {
    return await _localDatasource.getSubcategories();
  }

  @override
  Future<List<Subcategory>> getSubcategoriesByCategory(
    String categoryId,
  ) async {
    return await _localDatasource.getSubcategoriesByCategory(categoryId);
  }

  @override
  Future<void> syncSubcategories() async {
    if (!ConnectivityService.isOnline) return;

    try {
      final remoteSubcategories = await _remoteDatasource.getSubcategories();
      await _localDatasource.saveSubcategories(remoteSubcategories);
    } catch (e) {
      throw Exception('Failed to sync subcategories: $e');
    }
  }
}
