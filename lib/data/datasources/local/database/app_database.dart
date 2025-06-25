import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../../core/constants/app_constants.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Brands,
    Categories,
    Subcategories,
    Suppliers,
    Products,
    PriceLists,
    PriceListItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
        if (from < 2) {
          // Example migration for version 2
          // await m.addColumn(products, products.newColumn);
        }
      },
    );
  }

  // Brand operations
  Future<List<BrandDb>> getAllBrands() => select(brands).get();

  Future<BrandDb?> getBrandById(String id) =>
      (select(brands)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> insertBrand(BrandDb brand) => into(brands).insert(brand);

  Future<bool> updateBrand(BrandDb brand) => update(brands).replace(brand);

  Future<int> deleteBrand(String id) =>
      (delete(brands)..where((b) => b.id.equals(id))).go();

  // Category operations
  Future<List<CategoryDb>> getAllCategories() => select(categories).get();

  Future<CategoryDb?> getCategoryById(String id) =>
      (select(categories)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> insertCategory(CategoryDb category) =>
      into(categories).insert(category);

  Future<bool> updateCategory(CategoryDb category) =>
      update(categories).replace(category);

  // Subcategory operations
  Future<List<SubcategoryDb>> getAllSubcategories() =>
      select(subcategories).get();

  Future<List<SubcategoryDb>> getSubcategoriesByCategory(String categoryId) =>
      (select(
        subcategories,
      )..where((s) => s.categoryId.equals(categoryId))).get();

  Future<int> insertSubcategory(SubcategoryDb subcategory) =>
      into(subcategories).insert(subcategory);

  // Supplier operations
  Future<List<SupplierDb>> getAllSuppliers() => select(suppliers).get();

  Future<SupplierDb?> getSupplierById(String id) =>
      (select(suppliers)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<int> insertSupplier(SupplierDb supplier) =>
      into(suppliers).insert(supplier);

  // Product operations
  Future<List<ProductDb>> getAllProducts() => select(products).get();

  Future<List<ProductDb>> getProductsByBrand(String brandId) =>
      (select(products)..where((p) => p.brandId.equals(brandId))).get();

  Future<List<ProductDb>> getProductsByCategory(String categoryId) =>
      (select(products)..where((p) => p.categoryId.equals(categoryId))).get();

  Future<List<ProductDb>> getProductsBySubcategory(String subcategoryId) =>
      (select(
        products,
      )..where((p) => p.subcategoryId.equals(subcategoryId))).get();

  Future<List<ProductDb>> searchProducts(String query) {
    final searchQuery = query.toLowerCase();
    return (select(products)..where(
          (p) =>
              p.name.lower().contains(searchQuery) |
              p.alternativeName.lower().contains(searchQuery) |
              p.description.lower().contains(searchQuery),
        ))
        .get();
  }

  Future<ProductDb?> getProductById(String id) =>
      (select(products)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<int> insertProduct(ProductDb product) =>
      into(products).insert(product);

  Future<bool> updateProduct(ProductDb product) =>
      update(products).replace(product);

  // Price List operations
  Future<List<PriceListDb>> getAllPriceLists() => select(priceLists).get();

  Future<PriceListDb?> getDefaultPriceList() => (select(
    priceLists,
  )..where((pl) => pl.isDefault.equals(true))).getSingleOrNull();

  Future<List<PriceListItemDb>> getPriceListItems(String priceListId) =>
      (select(
        priceListItems,
      )..where((pli) => pli.priceListId.equals(priceListId))).get();

  Future<PriceListItemDb?> getProductPrice(
    String priceListId,
    String productId,
  ) =>
      (select(priceListItems)..where(
            (pli) =>
                pli.priceListId.equals(priceListId) &
                pli.productId.equals(productId),
          ))
          .getSingleOrNull();

  // Batch operations for sync
  Future<void> insertBrandsBatch(List<BrandDb> brandList) async {
    await batch((batch) {
      batch.insertAll(brands, brandList, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> insertCategoriesBatch(List<CategoryDb> categoryList) async {
    await batch((batch) {
      batch.insertAll(
        categories,
        categoryList,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> insertSubcategoriesBatch(
    List<SubcategoryDb> subcategoryList,
  ) async {
    await batch((batch) {
      batch.insertAll(
        subcategories,
        subcategoryList,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> insertSuppliersBatch(List<SupplierDb> supplierList) async {
    await batch((batch) {
      batch.insertAll(
        suppliers,
        supplierList,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> insertProductsBatch(List<ProductDb> productList) async {
    await batch((batch) {
      batch.insertAll(products, productList, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> insertPriceListItemsBatch(
    List<PriceListItemDb> priceItems,
  ) async {
    await batch((batch) {
      batch.insertAll(
        priceListItems,
        priceItems,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  // Clear all data (useful for full sync)
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(priceListItems).go();
      await delete(products).go();
      await delete(subcategories).go();
      await delete(suppliers).go();
      await delete(categories).go();
      await delete(brands).go();
      await delete(priceLists).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, AppConstants.localDatabaseName));
    return NativeDatabase(file);
  });
}
