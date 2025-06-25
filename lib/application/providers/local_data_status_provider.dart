import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/database_service.dart';

final localDataStatusProvider = FutureProvider<LocalDataStatus>((ref) async {
  debugPrint('🔍 Verificando datos locales directamente...');
  
  try {
    final localDatasource = DatabaseService.localDatasource;
    
    // Consultar directamente la base de datos local
    final brands = await localDatasource.getBrands();
    final categories = await localDatasource.getCategories();
    final products = await localDatasource.getProducts();
    
    final hasData = brands.isNotEmpty || categories.isNotEmpty || products.isNotEmpty;
    
    debugPrint('📊 Datos locales encontrados: ${brands.length} marcas, ${categories.length} categorías, ${products.length} productos');
    
    return LocalDataStatus(
      hasData: hasData,
      brandsCount: brands.length,
      categoriesCount: categories.length,
      productsCount: products.length,
    );
  } catch (e) {
    debugPrint('❌ Error verificando datos locales: $e');
    return const LocalDataStatus(
      hasData: false,
      brandsCount: 0,
      categoriesCount: 0,
      productsCount: 0,
    );
  }
});

class LocalDataStatus {
  final bool hasData;
  final int brandsCount;
  final int categoriesCount;
  final int productsCount;

  const LocalDataStatus({
    required this.hasData,
    required this.brandsCount,
    required this.categoriesCount,
    required this.productsCount,
  });
}