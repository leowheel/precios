import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/subcategory.dart';

part 'subcategory_model.g.dart';

@JsonSerializable()
class SubcategoryModel {
  final String id;
  final String name;
  @JsonKey(name: 'category_id')
  final String categoryId;
  final bool active;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  const SubcategoryModel({
    required this.id,
    required this.name,
    required this.categoryId,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubcategoryModelToJson(this);

  factory SubcategoryModel.fromEntity(Subcategory subcategory) {
    return SubcategoryModel(
      id: subcategory.id,
      name: subcategory.name,
      categoryId: subcategory.categoryId,
      active: subcategory.active,
      createdAt: subcategory.createdAt,
      updatedAt: subcategory.updatedAt,
      deletedAt: subcategory.deletedAt,
    );
  }

  Subcategory toEntity() {
    return Subcategory(
      id: id,
      name: name,
      categoryId: categoryId,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
