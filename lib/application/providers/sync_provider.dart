import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'repository_providers.dart';
import 'connectivity_provider.dart';

final syncAllDataProvider = FutureProvider<void>((ref) async {
  debugPrint('🚀 Iniciando sincronización de datos...');

  final isOnline = ref.watch(isOnlineProvider);

  if (!isOnline) {
    debugPrint('❌ No hay conexión a internet disponible para sincronizar');
    throw Exception('No internet connection available for sync');
  }

  debugPrint('✅ Conexión a internet disponible');

  final brandRepository = ref.watch(brandRepositoryProvider);
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  final subcategoryRepository = ref.watch(subcategoryRepositoryProvider);
  final productRepository = ref.watch(productRepositoryProvider);
  final priceRepository = ref.watch(priceRepositoryProvider);

  debugPrint('🔧 Repositorios obtenidos, iniciando sincronización...');

  try {
    await Future.wait([
      () async {
        debugPrint('📦 Sincronizando marcas...');
        await brandRepository.syncBrands();
        debugPrint('✅ Marcas sincronizadas');
      }(),
      () async {
        debugPrint('📂 Sincronizando categorías...');
        await categoryRepository.syncCategories();
        debugPrint('✅ Categorías sincronizadas');
      }(),
      () async {
        debugPrint('📋 Sincronizando subcategorías...');
        await subcategoryRepository.syncSubcategories();
        debugPrint('✅ Subcategorías sincronizadas');
      }(),
      () async {
        debugPrint('🛍️ Sincronizando productos...');
        await productRepository.syncProducts();
        debugPrint('✅ Productos sincronizados');
      }(),
      () async {
        debugPrint('💰 Sincronizando precios...');
        await priceRepository.syncPrices();
        debugPrint('✅ Precios sincronizados');
      }(),
    ]);

    debugPrint('🎉 Sincronización completada exitosamente');
  } catch (e, stackTrace) {
    debugPrint('❌ Error durante la sincronización: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
});
