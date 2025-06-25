import 'package:equatable/equatable.dart';

class Subcategory extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Subcategory({
    required this.id,
    required this.name,
    required this.categoryId,
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
        categoryId,
        active,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}