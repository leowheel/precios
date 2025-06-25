import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../core/services/connectivity_service.dart';
import '../datasources/remote/remote_datasource.dart';
import '../datasources/local/local_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final RemoteDatasource _remoteDatasource;
  final LocalDatasource _localDatasource;
  
  CategoryRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
  );

  @override
  Future<List<Category>> getCategories() async {
    return await _localDatasource.getCategories();
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    return await _localDatasource.getCategoryById(id);
  }

  @override
  Future<void> syncCategories() async {
    if (!ConnectivityService.isOnline) return;
    
    try {
      final remoteCategories = await _remoteDatasource.getCategories();
      await _localDatasource.saveCategories(remoteCategories);
    } catch (e) {
      throw Exception('Failed to sync categories: $e');
    }
  }
}