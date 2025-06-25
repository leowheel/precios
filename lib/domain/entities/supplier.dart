import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final String id;
  final String name;
  final String? contactName;
  final String? email;
  final String? phone;
  final String? address;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Supplier({
    required this.id,
    required this.name,
    this.contactName,
    this.email,
    this.phone,
    this.address,
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
        contactName,
        email,
        phone,
        address,
        active,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}