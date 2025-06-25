import 'package:flutter_riverpod/flutter_riverpod.dart';

class CatalogFilter {
  final String? selectedBrandId;
  final String? selectedCategoryId;
  final String? selectedSubcategoryId;
  final String searchQuery;

  const CatalogFilter({
    this.selectedBrandId,
    this.selectedCategoryId,
    this.selectedSubcategoryId,
    this.searchQuery = '',
  });

  CatalogFilter copyWith({
    String? selectedBrandId,
    String? selectedCategoryId,
    String? selectedSubcategoryId,
    String? searchQuery,
  }) {
    return CatalogFilter(
      selectedBrandId: selectedBrandId ?? this.selectedBrandId,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedSubcategoryId: selectedSubcategoryId ?? this.selectedSubcategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasFilters {
    return selectedBrandId != null ||
           selectedCategoryId != null ||
           selectedSubcategoryId != null ||
           searchQuery.isNotEmpty;
  }

  CatalogFilter clearFilters() {
    return const CatalogFilter();
  }
}

class CatalogFilterNotifier extends StateNotifier<CatalogFilter> {
  CatalogFilterNotifier() : super(const CatalogFilter());

  void setBrand(String? brandId) {
    state = state.copyWith(selectedBrandId: brandId);
  }

  void setCategory(String? categoryId) {
    state = state.copyWith(
      selectedCategoryId: categoryId,
      selectedSubcategoryId: null, // Clear subcategory when category changes
    );
  }

  void setSubcategory(String? subcategoryId) {
    state = state.copyWith(selectedSubcategoryId: subcategoryId);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = state.clearFilters();
  }
}

final catalogFilterProvider = StateNotifierProvider<CatalogFilterNotifier, CatalogFilter>((ref) {
  return CatalogFilterNotifier();
});