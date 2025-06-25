import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/brand_model.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../models/supplier_model.dart';

class SupabaseDatasource {
  final SupabaseClient _client = SupabaseService.client;

  // Brand operations
  Future<List<BrandModel>> getBrands({
    int? limit,
    int? offset,
  }) async {
    var query = _client
        .from(AppConstants.brandsTable)
        .select()
        .order('name');

    if (limit != null) query = query.limit(limit);
    if (offset != null) {
      query = query.range(offset, offset + (limit ?? AppConstants.defaultPageSize) - 1);
    }

    final response = await query;
    return (response as List)
        .map((json) => BrandModel.fromJson(json))
        .toList();
  }

  Future<BrandModel?> getBrandById(String id) async {
    final response = await _client
        .from(AppConstants.brandsTable)
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? BrandModel.fromJson(response) : null;
  }

  // Category operations
  Future<List<CategoryModel>> getCategories({
    int? limit,
    int? offset,
  }) async {
    var query = _client
        .from(AppConstants.categoriesTable)
        .select()
        .order('name');

    if (limit != null) query = query.limit(limit);
    if (offset != null) {
      query = query.range(offset, offset + (limit ?? AppConstants.defaultPageSize) - 1);
    }

    final response = await query;
    return (response as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    final response = await _client
        .from(AppConstants.categoriesTable)
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? CategoryModel.fromJson(response) : null;
  }

  // Supplier operations
  Future<List<SupplierModel>> getSuppliers({
    int? limit,
    int? offset,
  }) async {
    var query = _client
        .from(AppConstants.suppliersTable)
        .select()
        .order('name');

    if (limit != null) query = query.limit(limit);
    if (offset != null) {
      query = query.range(offset, offset + (limit ?? AppConstants.defaultPageSize) - 1);
    }

    final response = await query;
    return (response as List)
        .map((json) => SupplierModel.fromJson(json))
        .toList();
  }

  Future<SupplierModel?> getSupplierById(String id) async {
    final response = await _client
        .from(AppConstants.suppliersTable)
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? SupplierModel.fromJson(response) : null;
  }

  // Product operations
  Future<List<ProductModel>> getProducts({
    int? limit,
    int? offset,
  }) async {
    var query = _client
        .from(AppConstants.productsTable)
        .select()
        .order('name');

    if (limit != null) query = query.limit(limit);
    if (offset != null) {
      query = query.range(offset, offset + (limit ?? AppConstants.defaultPageSize) - 1);
    }

    final response = await query;
    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<ProductModel?> getProductById(String id) async {
    final response = await _client
        .from(AppConstants.productsTable)
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? ProductModel.fromJson(response) : null;
  }

  // Search operations
  Future<List<ProductModel>> searchProducts(String query, {
    int? limit,
    int? offset,
  }) async {
    var searchQuery = _client
        .from(AppConstants.productsTable)
        .select()
        .textSearch('name', query)
        .order('name');

    if (limit != null) searchQuery = searchQuery.limit(limit);
    if (offset != null) {
      searchQuery = searchQuery.range(offset, offset + (limit ?? AppConstants.defaultPageSize) - 1);
    }

    final response = await searchQuery;
    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  // Connectivity test
  Future<bool> testConnection() async {
    return await SupabaseService.testConnection();
  }
}