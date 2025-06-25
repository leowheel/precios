import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' hide Category;
import '../../domain/entities/brand.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../providers/brand_providers.dart';
import '../providers/category_providers.dart';
import '../providers/product_providers.dart';

final dataStatusProvider = FutureProvider<DataStatus>((ref) async {
  debugPrint('🔍 Verificando estado de datos locales...');

  try {
    // Usar timeout para evitar bloqueos
    final brands = await ref
        .read(brandsProvider.future)
        .timeout(const Duration(seconds: 5), onTimeout: () => <Brand>[]);

    final categories = await ref
        .read(categoriesProvider.future)
        .timeout(const Duration(seconds: 5), onTimeout: () => <Category>[]);

    final products = await ref
        .read(productsProvider.future)
        .timeout(const Duration(seconds: 5), onTimeout: () => <Product>[]);

    final hasData =
        brands.isNotEmpty || categories.isNotEmpty || products.isNotEmpty;

    debugPrint(
      '📊 Estado de datos: Marcas: ${brands.length}, Categorías: ${categories.length}, Productos: ${products.length}',
    );

    return DataStatus(
      hasData: hasData,
      brandsCount: brands.length,
      categoriesCount: categories.length,
      productsCount: products.length,
    );
  } catch (e) {
    debugPrint('❌ Error verificando estado de datos: $e');
    // Retornar estado sin datos para mostrar la pantalla de bienvenida
    return const DataStatus(
      hasData: false,
      brandsCount: 0,
      categoriesCount: 0,
      productsCount: 0,
    );
  }
});

class DataStatus {
  final bool hasData;
  final int brandsCount;
  final int categoriesCount;
  final int productsCount;

  const DataStatus({
    required this.hasData,
    required this.brandsCount,
    required this.categoriesCount,
    required this.productsCount,
  });
}
