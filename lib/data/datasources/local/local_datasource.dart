import '../../../domain/entities/brand.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/subcategory.dart';
import '../../../domain/entities/supplier.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/entities/price_list.dart';
import '../../../domain/entities/price_list_item.dart';
import 'database/app_database.dart';

class LocalDatasource {
  final AppDatabase _database;

  LocalDatasource(this._database);

  // Brand operations
  Future<List<Brand>> getBrands() async {
    final brandDbs = await _database.getAllBrands();
    return brandDbs.map((db) => _brandDbToEntity(db)).toList();
  }

  Future<Brand?> getBrandById(String id) async {
    final brandDb = await _database.getBrandById(id);
    return brandDb != null ? _brandDbToEntity(brandDb) : null;
  }

  Future<void> saveBrands(List<Brand> brands) async {
    final brandDbs = brands.map((brand) => _brandEntityToDb(brand)).toList();
    await _database.insertBrandsBatch(brandDbs);
  }

  // Category operations
  Future<List<Category>> getCategories() async {
    final categoryDbs = await _database.getAllCategories();
    return categoryDbs.map((db) => _categoryDbToEntity(db)).toList();
  }

  Future<Category?> getCategoryById(String id) async {
    final categoryDb = await _database.getCategoryById(id);
    return categoryDb != null ? _categoryDbToEntity(categoryDb) : null;
  }

  Future<void> saveCategories(List<Category> categories) async {
    final categoryDbs = categories
        .map((category) => _categoryEntityToDb(category))
        .toList();
    await _database.insertCategoriesBatch(categoryDbs);
  }

  // Subcategory operations
  Future<List<Subcategory>> getSubcategories() async {
    final subcategoryDbs = await _database.getAllSubcategories();
    return subcategoryDbs.map((db) => _subcategoryDbToEntity(db)).toList();
  }

  Future<List<Subcategory>> getSubcategoriesByCategory(
    String categoryId,
  ) async {
    final subcategoryDbs = await _database.getSubcategoriesByCategory(
      categoryId,
    );
    return subcategoryDbs.map((db) => _subcategoryDbToEntity(db)).toList();
  }

  Future<void> saveSubcategories(List<Subcategory> subcategories) async {
    final subcategoryDbs = subcategories
        .map((sub) => _subcategoryEntityToDb(sub))
        .toList();
    await _database.insertSubcategoriesBatch(subcategoryDbs);
  }

  // Supplier operations
  Future<List<Supplier>> getSuppliers() async {
    final supplierDbs = await _database.getAllSuppliers();
    return supplierDbs.map((db) => _supplierDbToEntity(db)).toList();
  }

  Future<Supplier?> getSupplierById(String id) async {
    final supplierDb = await _database.getSupplierById(id);
    return supplierDb != null ? _supplierDbToEntity(supplierDb) : null;
  }

  Future<void> saveSuppliers(List<Supplier> suppliers) async {
    final supplierDbs = suppliers
        .map((supplier) => _supplierEntityToDb(supplier))
        .toList();
    await _database.insertSuppliersBatch(supplierDbs);
  }

  // Product operations
  Future<List<Product>> getProducts() async {
    final productDbs = await _database.getAllProducts();
    return productDbs.map((db) => _productDbToEntity(db)).toList();
  }

  Future<List<Product>> getProductsByBrand(String brandId) async {
    final productDbs = await _database.getProductsByBrand(brandId);
    return productDbs.map((db) => _productDbToEntity(db)).toList();
  }

  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final productDbs = await _database.getProductsByCategory(categoryId);
    return productDbs.map((db) => _productDbToEntity(db)).toList();
  }

  Future<List<Product>> getProductsBySubcategory(String subcategoryId) async {
    final productDbs = await _database.getProductsBySubcategory(subcategoryId);
    return productDbs.map((db) => _productDbToEntity(db)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final productDbs = await _database.searchProducts(query);
    return productDbs.map((db) => _productDbToEntity(db)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final productDb = await _database.getProductById(id);
    return productDb != null ? _productDbToEntity(productDb) : null;
  }

  Future<void> saveProducts(List<Product> products) async {
    final productDbs = products
        .map((product) => _productEntityToDb(product))
        .toList();
    await _database.insertProductsBatch(productDbs);
  }

  // Price operations
  Future<List<PriceList>> getPriceLists() async {
    final priceListDbs = await _database.getAllPriceLists();
    return priceListDbs.map((db) => _priceListDbToEntity(db)).toList();
  }

  Future<PriceList?> getDefaultPriceList() async {
    final priceListDb = await _database.getDefaultPriceList();
    return priceListDb != null ? _priceListDbToEntity(priceListDb) : null;
  }

  Future<double?> getProductPrice(String priceListId, String productId) async {
    final priceItem = await _database.getProductPrice(priceListId, productId);
    return priceItem?.priceNet;
  }

  Future<void> savePriceListItems(List<PriceListItem> priceItems) async {
    final priceItemDbs = priceItems
        .map((item) => _priceListItemEntityToDb(item))
        .toList();
    await _database.insertPriceListItemsBatch(priceItemDbs);
  }

  // Utility operations
  Future<void> clearAllData() async {
    await _database.clearAllData();
  }

  // Conversion methods
  Brand _brandDbToEntity(BrandDb db) {
    return Brand(
      id: db.id,
      name: db.name,
      imageUrl: db.imageUrl,
      active: db.active,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      deletedAt: db.deletedAt,
    );
  }

  BrandDb _brandEntityToDb(Brand brand) {
    return BrandDb(
      id: brand.id,
      name: brand.name,
      imageUrl: brand.imageUrl,
      active: brand.active,
      createdAt: brand.createdAt,
      updatedAt: brand.updatedAt,
      deletedAt: brand.deletedAt,
    );
  }

  Category _categoryDbToEntity(CategoryDb db) {
    return Category(
      id: db.id,
      name: db.name,
      active: db.active,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      deletedAt: db.deletedAt,
    );
  }

  CategoryDb _categoryEntityToDb(Category category) {
    return CategoryDb(
      id: category.id,
      name: category.name,
      active: category.active,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      deletedAt: category.deletedAt,
    );
  }

  Subcategory _subcategoryDbToEntity(SubcategoryDb db) {
    return Subcategory(
      id: db.id,
      name: db.name,
      categoryId: db.categoryId,
      active: db.active,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      deletedAt: db.deletedAt,
    );
  }

  SubcategoryDb _subcategoryEntityToDb(Subcategory subcategory) {
    return SubcategoryDb(
      id: subcategory.id,
      name: subcategory.name,
      categoryId: subcategory.categoryId,
      active: subcategory.active,
      createdAt: subcategory.createdAt,
      updatedAt: subcategory.updatedAt,
      deletedAt: subcategory.deletedAt,
    );
  }

  Supplier _supplierDbToEntity(SupplierDb db) {
    return Supplier(
      id: db.id,
      name: db.name,
      contactName: db.contactName,
      email: db.email,
      phone: db.phone,
      address: db.address,
      active: db.active,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      deletedAt: db.deletedAt,
    );
  }

  SupplierDb _supplierEntityToDb(Supplier supplier) {
    return SupplierDb(
      id: supplier.id,
      name: supplier.name,
      contactName: supplier.contactName,
      email: supplier.email,
      phone: supplier.phone,
      address: supplier.address,
      active: supplier.active,
      createdAt: supplier.createdAt,
      updatedAt: supplier.updatedAt,
      deletedAt: supplier.deletedAt,
    );
  }

  Product _productDbToEntity(ProductDb db) {
    return Product(
      id: db.id,
      code: db.code,
      name: db.name,
      brandId: db.brandId,
      categoryId: db.categoryId,
      subcategoryId: db.subcategoryId,
      imageUrl: db.imageUrl,
      description: db.description,
      size: db.size,
      sizeMeasure: db.sizeMeasure,
      package: db.package,
      variableWeight: db.variableWeight,
      label: db.label,
      isOffer: db.isOffer,
      active: db.active,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      deletedAt: db.deletedAt,
      unitsPerBundle: db.unitsPerBundle,
      alternativeName: db.alternativeName,
      bundlePackage: db.bundlePackage,
      unitCost: db.unitCost,
      billingUnit: db.billingUnit,
      orderUnit: db.orderUnit,
      minQuantity: db.minQuantity,
      suggestedIncrement: db.suggestedIncrement,
      isFractionable: db.isFractionable,
      weightInGrams: db.weightInGrams,
      sku: db.sku,
      upc: db.upc,
      directLoad: db.directLoad,
      observations: db.observations,
      supplierCode: db.supplierCode,
      purchaseUnit: db.purchaseUnit,
      orderName: db.orderName,
      orderUnitConversion: db.orderUnitConversion,
      supplierId: db.supplierId,
      tax: db.tax,
      billingUnitConversion: db.billingUnitConversion,
      sectorId: db.sectorId,
    );
  }

  ProductDb _productEntityToDb(Product product) {
    return ProductDb(
      id: product.id,
      code: product.code,
      name: product.name,
      brandId: product.brandId,
      categoryId: product.categoryId,
      subcategoryId: product.subcategoryId,
      imageUrl: product.imageUrl,
      description: product.description,
      size: product.size,
      sizeMeasure: product.sizeMeasure,
      package: product.package,
      variableWeight: product.variableWeight,
      label: product.label,
      isOffer: product.isOffer,
      active: product.active,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      deletedAt: product.deletedAt,
      unitsPerBundle: product.unitsPerBundle,
      alternativeName: product.alternativeName,
      bundlePackage: product.bundlePackage,
      unitCost: product.unitCost,
      billingUnit: product.billingUnit,
      orderUnit: product.orderUnit,
      minQuantity: product.minQuantity,
      suggestedIncrement: product.suggestedIncrement,
      isFractionable: product.isFractionable,
      weightInGrams: product.weightInGrams,
      sku: product.sku,
      upc: product.upc,
      directLoad: product.directLoad,
      observations: product.observations,
      supplierCode: product.supplierCode,
      purchaseUnit: product.purchaseUnit,
      orderName: product.orderName,
      orderUnitConversion: product.orderUnitConversion,
      supplierId: product.supplierId,
      tax: product.tax,
      billingUnitConversion: product.billingUnitConversion,
      sectorId: product.sectorId,
    );
  }

  PriceList _priceListDbToEntity(PriceListDb db) {
    return PriceList(
      id: db.id,
      name: db.name,
      description: db.description,
      active: db.active,
      isDefault: db.isDefault,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
    );
  }

  PriceListItemDb _priceListItemEntityToDb(PriceListItem item) {
    return PriceListItemDb(
      priceListId: item.priceListId,
      productId: item.productId,
      priceNet: item.priceNet,
      active: item.active,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}
