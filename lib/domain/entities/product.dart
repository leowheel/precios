import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String code;
  final String name;
  final String brandId;
  final String categoryId;
  final String subcategoryId;
  final String? imageUrl;
  final String? description;
  final double? size;
  final String? sizeMeasure;
  final String? package;
  final bool? variableWeight;
  final String? label;
  final bool? isOffer;
  final bool? active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int? unitsPerBundle;
  final String? alternativeName;
  final String? bundlePackage;
  final double? unitCost;
  final String? billingUnit;
  final String? orderUnit;
  final double? minQuantity;
  final double? suggestedIncrement;
  final bool? isFractionable;
  final int? weightInGrams;
  final String? sku;
  final String? upc;
  final bool? directLoad;
  final String? observations;
  final String? supplierCode;
  final String? purchaseUnit;
  final String? orderName;
  final double? orderUnitConversion;
  final String? supplierId;
  final double? tax;
  final double? billingUnitConversion;
  final String? sectorId;

  const Product({
    required this.id,
    required this.code,
    required this.name,
    required this.brandId,
    required this.categoryId,
    required this.subcategoryId,
    this.imageUrl,
    this.description,
    this.size,
    this.sizeMeasure,
    this.package,
    this.variableWeight,
    this.label,
    this.isOffer,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.unitsPerBundle,
    this.alternativeName,
    this.bundlePackage,
    this.unitCost,
    this.billingUnit,
    this.orderUnit,
    this.minQuantity,
    this.suggestedIncrement,
    this.isFractionable,
    this.weightInGrams,
    this.sku,
    this.upc,
    this.directLoad,
    this.observations,
    this.supplierCode,
    this.purchaseUnit,
    this.orderName,
    this.orderUnitConversion,
    this.supplierId,
    this.tax,
    this.billingUnitConversion,
    this.sectorId,
  });

  bool get isActive => (active ?? true) && deletedAt == null;
  
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  
  String get displayName => alternativeName ?? name;
  
  String get displaySize {
    if (size != null && sizeMeasure != null) {
      return '$size $sizeMeasure';
    }
    return package ?? '';
  }

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        brandId,
        categoryId,
        subcategoryId,
        imageUrl,
        description,
        size,
        sizeMeasure,
        package,
        variableWeight,
        label,
        isOffer,
        active,
        createdAt,
        updatedAt,
        deletedAt,
        unitsPerBundle,
        alternativeName,
        bundlePackage,
        unitCost,
        billingUnit,
        orderUnit,
        minQuantity,
        suggestedIncrement,
        isFractionable,
        weightInGrams,
        sku,
        upc,
        directLoad,
        observations,
        supplierCode,
        purchaseUnit,
        orderName,
        orderUnitConversion,
        supplierId,
        tax,
        billingUnitConversion,
        sectorId,
      ];
}