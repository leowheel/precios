import 'package:drift/drift.dart';

@DataClassName('BrandDb')
class Brands extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoryDb')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SubcategoryDb')
class Subcategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SupplierDb')
class Suppliers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get contactName => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProductDb')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get brandId => text().references(Brands, #id)();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get subcategoryId => text().references(Subcategories, #id)();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get size => real().nullable()();
  TextColumn get sizeMeasure => text().nullable()();
  TextColumn get package => text().nullable()();
  BoolColumn get variableWeight => boolean().nullable()();
  TextColumn get label => text().nullable()();
  BoolColumn get isOffer => boolean().nullable()();
  BoolColumn get active => boolean().nullable().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get unitsPerBundle => integer().nullable()();
  TextColumn get alternativeName => text().nullable()();
  TextColumn get bundlePackage => text().nullable()();
  RealColumn get unitCost => real().nullable()();
  TextColumn get billingUnit => text().nullable()();
  TextColumn get orderUnit => text().nullable()();
  RealColumn get minQuantity => real().nullable()();
  RealColumn get suggestedIncrement => real().nullable()();
  BoolColumn get isFractionable => boolean().nullable()();
  IntColumn get weightInGrams => integer().nullable()();
  TextColumn get sku => text().nullable()();
  TextColumn get upc => text().nullable()();
  BoolColumn get directLoad => boolean().nullable()();
  TextColumn get observations => text().nullable()();
  TextColumn get supplierCode => text().nullable()();
  TextColumn get purchaseUnit => text().nullable()();
  TextColumn get orderName => text().nullable()();
  RealColumn get orderUnitConversion => real().nullable()();
  TextColumn get supplierId => text().nullable().references(Suppliers, #id)();
  RealColumn get tax => real().nullable()();
  RealColumn get billingUnitConversion => real().nullable()();
  TextColumn get sectorId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PriceListDb')
class PriceLists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PriceListItemDb')
class PriceListItems extends Table {
  TextColumn get priceListId => text().references(PriceLists, #id)();
  TextColumn get productId => text().references(Products, #id)();
  RealColumn get priceNet => real()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {priceListId, productId};
}