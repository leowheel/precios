import 'package:equatable/equatable.dart';

class PriceList extends Equatable {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PriceList({
    required this.id,
    required this.name,
    this.description,
    this.active = true,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        active,
        isDefault,
        createdAt,
        updatedAt,
      ];
}