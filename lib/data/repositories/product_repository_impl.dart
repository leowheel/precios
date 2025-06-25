import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../core/services/connectivity_service.dart';
import '../datasources/remote/remote_datasource.dart';
import '../datasources/local/local_datasource.dart';
import 'package:flutter/foundation.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDatasource _remoteDatasource;
  final LocalDatasource _localDatasource;

  ProductRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<Product>> getProducts() async {
    return await _localDatasource.getProducts();
  }

  @override
  Future<List<Product>> getProductsByBrand(String brandId) async {
    return await _localDatasource.getProductsByBrand(brandId);
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    return await _localDatasource.getProductsByCategory(categoryId);
  }

  @override
  Future<List<Product>> getProductsBySubcategory(String subcategoryId) async {
    return await _localDatasource.getProductsBySubcategory(subcategoryId);
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    return await _localDatasource.searchProducts(query);
  }

  @override
  Future<Product?> getProductById(String id) async {
    return await _localDatasource.getProductById(id);
  }

  @override
  Future<void> syncProducts() async {
    if (!ConnectivityService.isOnline) {
      debugPrint('❌ No hay conexión a internet para sincronizar productos');
      return;
    }

    debugPrint('🔄 Iniciando sincronización de productos...');

    try {
      debugPrint('📡 Obteniendo productos desde el servidor...');
      final remoteProducts = await _remoteDatasource.getProducts();
      debugPrint('✅ Obtenidos ${remoteProducts.length} productos del servidor');

      debugPrint('💾 Guardando productos en base de datos local...');
      await _localDatasource.saveProducts(remoteProducts);
      debugPrint('✅ Productos guardados en base de datos local');
    } catch (e, stackTrace) {
      debugPrint('❌ Error sincronizando productos: $e');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to sync products: $e');
    }
  }
}
