import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/price_list.dart';

part 'price_list_model.g.dart';

@JsonSerializable()
class PriceListModel {
  final String id;
  final String name;
  final String? description;
  final bool active;
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const PriceListModel({
    required this.id,
    required this.name,
    this.description,
    required this.active,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PriceListModel.fromJson(Map<String, dynamic> json) =>
      _$PriceListModelFromJson(json);

  Map<String, dynamic> toJson() => _$PriceListModelToJson(this);

  PriceList toEntity() {
    return PriceList(
      id: id,
      name: name,
      description: description,
      active: active,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}