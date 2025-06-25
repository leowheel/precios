import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/brand.dart';
import '../../../domain/entities/category.dart' as entities;
import '../../../domain/entities/subcategory.dart';
import '../../../domain/entities/supplier.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/price_list.dart';
import '../../../domain/entities/price_list_item.dart';
import '../../models/brand_model.dart';
import '../../models/category_model.dart';
import '../../models/subcategory_model.dart';
import '../../models/supplier_model.dart';
import '../../models/product_model.dart';
import '../../models/price_list_model.dart';
import '../../models/price_list_item_model.dart';

class RemoteDatasource {
  final SupabaseClient _supabase;

  RemoteDatasource(this._supabase);

  Future<List<Brand>> getBrands() async {
    try {
      debugPrint('📡 Consultando marcas desde Supabase...');
      final response = await _supabase
          .from('brands')
          .select(
            'id, name, image_url, active, created_at, updated_at, deleted_at',
          )
          .eq('active', true);

      debugPrint(
        '✅ Respuesta de marcas recibida: ${response.length} elementos',
      );

      if (response.isNotEmpty) {
        debugPrint('🔍 Ejemplo de marca recibida: ${response[0]}');
      }

      debugPrint('🔄 Deserializando marcas...');
      final brands = (response as List).map((json) {
        try {
          return BrandModel.fromJson(json).toEntity();
        } catch (e) {
          debugPrint('❌ Error deserializando marca: $json');
          debugPrint('Error: $e');
          rethrow;
        }
      }).toList();

      debugPrint('✅ Marcas deserializadas exitosamente: ${brands.length}');
      return brands;
    } catch (e) {
      debugPrint('❌ Error obteniendo marcas: $e');
      throw Exception('Failed to fetch brands: $e');
    }
  }

  Future<List<entities.Category>> getCategories() async {
    try {
      debugPrint('📡 Consultando categorías desde Supabase...');
      final response = await _supabase
          .from('categories')
          .select('id, name, active, created_at, updated_at, deleted_at')
          .eq('active', true);

      debugPrint(
        '✅ Respuesta de categorías recibida: ${response.length} elementos',
      );

      return (response as List)
          .map((json) => CategoryModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      debugPrint('❌ Error obteniendo categorías: $e');
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<List<Subcategory>> getSubcategories() async {
    try {
      debugPrint('📡 Consultando subcategorías desde Supabase...');
      final response = await _supabase
          .from('subcategories')
          .select(
            'id, name, category_id, active, created_at, updated_at, deleted_at',
          )
          .eq('active', true);

      debugPrint(
        '✅ Respuesta de subcategorías recibida: ${response.length} elementos',
      );

      debugPrint('🔄 Deserializando subcategorías...');
      final subcategories = (response as List).map((json) {
        try {
          return SubcategoryModel.fromJson(json).toEntity();
        } catch (e) {
          debugPrint('❌ Error deserializando subcategoría: $json');
          debugPrint('Error: $e');
          rethrow;
        }
      }).toList();

      debugPrint(
        '✅ Subcategorías deserializadas exitosamente: ${subcategories.length}',
      );
      return subcategories;
    } catch (e) {
      debugPrint('❌ Error obteniendo subcategorías: $e');
      throw Exception('Failed to fetch subcategories: $e');
    }
  }

  Future<List<Supplier>> getSuppliers() async {
    try {
      debugPrint('📡 Consultando proveedores desde Supabase...');
      final response = await _supabase
          .from('suppliers')
          .select()
          .eq('active', true);

      debugPrint(
        '✅ Respuesta de proveedores recibida: ${response.length} elementos',
      );

      return (response as List)
          .map((json) => SupplierModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      debugPrint('❌ Error obteniendo proveedores: $e');
      throw Exception('Failed to fetch suppliers: $e');
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      debugPrint('📡 Consultando productos desde Supabase...');
      final response = await _supabase
          .from('products')
          .select()
          .eq('active', true);

      debugPrint(
        '✅ Respuesta de productos recibida: ${response.length} elementos',
      );

      if (response.isNotEmpty) {
        debugPrint('🔍 Ejemplo de producto recibido: ${response[0]}');
      }

      debugPrint('🔄 Deserializando productos...');
      final products = (response as List).map((json) {
        try {
          return ProductModel.fromJson(json).toEntity();
        } catch (e) {
          debugPrint('❌ Error deserializando producto: $json');
          debugPrint('Error: $e');
          rethrow;
        }
      }).toList();

      debugPrint('✅ Productos deserializados exitosamente: ${products.length}');
      return products;
    } catch (e) {
      debugPrint('❌ Error obteniendo productos: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<List<Product>> getProductsByBrand(String brandId) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('brand_id', brandId)
          .eq('active', true);

      return (response as List)
          .map((json) => ProductModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by brand: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('category_id', categoryId)
          .eq('active', true);

      return (response as List)
          .map((json) => ProductModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: $e');
    }
  }

  Future<List<PriceList>> getPriceLists() async {
    try {
      final response = await _supabase
          .from('price_lists')
          .select()
          .eq('active', true);

      return (response as List)
          .map((json) => PriceListModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch price lists: $e');
    }
  }

  Future<List<PriceListItem>> getPriceListItems() async {
    try {
      final response = await _supabase.from('price_list_items').select();

      return (response as List)
          .map((json) => PriceListItemModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch price list items: $e');
    }
  }
}
