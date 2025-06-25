import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/brand.dart';

part 'brand_model.g.dart';

@JsonSerializable()
class BrandModel {
  final String id;
  final String name;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  final bool active;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  const BrandModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  factory BrandModel.fromEntity(Brand brand) {
    return BrandModel(
      id: brand.id,
      name: brand.name,
      imageUrl: brand.imageUrl,
      active: brand.active,
      createdAt: brand.createdAt,
      updatedAt: brand.updatedAt,
      deletedAt: brand.deletedAt,
    );
  }

  Brand toEntity() {
    return Brand(
      id: id,
      name: name,
      imageUrl: imageUrl,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
