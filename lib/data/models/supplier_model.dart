import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/supplier.dart';

part 'supplier_model.g.dart';

@JsonSerializable()
class SupplierModel extends Supplier {
  const SupplierModel({
    required super.id,
    required super.name,
    @JsonKey(name: 'contact_name') super.contactName,
    super.email,
    super.phone,
    super.address,
    super.active = true,
    @JsonKey(name: 'created_at') required super.createdAt,
    @JsonKey(name: 'updated_at') required super.updatedAt,
    @JsonKey(name: 'deleted_at') super.deletedAt,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierModelToJson(this);

  factory SupplierModel.fromEntity(Supplier supplier) {
    return SupplierModel(
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

  Supplier toEntity() {
    return Supplier(
      id: id,
      name: name,
      contactName: contactName,
      email: email,
      phone: phone,
      address: address,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
