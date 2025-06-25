// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceListItemModel _$PriceListItemModelFromJson(Map<String, dynamic> json) =>
    PriceListItemModel(
      priceListId: json['price_list_id'] as String,
      productId: json['product_id'] as String,
      priceNet: (json['price_net'] as num).toDouble(),
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PriceListItemModelToJson(PriceListItemModel instance) =>
    <String, dynamic>{
      'price_list_id': instance.priceListId,
      'product_id': instance.productId,
      'price_net': instance.priceNet,
      'active': instance.active,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
