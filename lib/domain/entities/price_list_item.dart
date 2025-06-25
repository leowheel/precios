import 'package:equatable/equatable.dart';

class PriceListItem extends Equatable {
  final String priceListId;
  final String productId;
  final double priceNet;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PriceListItem({
    required this.priceListId,
    required this.productId,
    required this.priceNet,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedPrice => '\$${priceNet.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [
        priceListId,
        productId,
        priceNet,
        active,
        createdAt,
        updatedAt,
      ];
}