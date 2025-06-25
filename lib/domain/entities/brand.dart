import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Brand({
    required this.id,
    required this.name,
    this.imageUrl,
    this.active = true,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  bool get isActive => active && deletedAt == null;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        active,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}