import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Category({
    required this.id,
    required this.name,
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
        active,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}