// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceListModel _$PriceListModelFromJson(Map<String, dynamic> json) =>
    PriceListModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      active: json['active'] as bool,
      isDefault: json['is_default'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PriceListModelToJson(PriceListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'active': instance.active,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
