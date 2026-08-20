import 'package:equatable/equatable.dart';
import '../../../../core/constants/role_constants.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? phone;
  final String? avatar;
  final String? companyName;
  final bool isEmailVerified;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.avatar,
    this.companyName,
    this.isEmailVerified = false,
    this.createdAt,
  });

  bool get isPelamar => role == UserRole.pelamar;
  bool get isKandidat => role == UserRole.kandidat;
  bool get isPerusahaan => role == UserRole.perusahaan;
  bool get isAdmin => role == UserRole.admin;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        phone,
        avatar,
        companyName,
        isEmailVerified,
        createdAt,
      ];
}
