import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/price_list_item.dart';

part 'price_list_item_model.g.dart';

@JsonSerializable()
class PriceListItemModel {
  @JsonKey(name: 'price_list_id')
  final String priceListId;
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(name: 'price_net')
  final double priceNet;
  final bool active;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const PriceListItemModel({
    required this.priceListId,
    required this.productId,
    required this.priceNet,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PriceListItemModel.fromJson(Map<String, dynamic> json) =>
      _$PriceListItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceListItemModelToJson(this);

  PriceListItem toEntity() {
    return PriceListItem(
      priceListId: priceListId,
      productId: productId,
      priceNet: priceNet,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}