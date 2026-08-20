import '../../core/constants/role_constants.dart';
import '../../features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.phone,
    super.avatar,
    super.companyName,
    super.isEmailVerified,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both flat structure and nested profile/company structure
    final id = json['id']?.toString() ?? json['user_id']?.toString() ?? '';
    final name = json['name']?.toString() ?? json['nama']?.toString() ?? json['username']?.toString() ?? '';
    final email = json['email']?.toString() ?? '';
    final roleStr = json['role']?.toString() ?? json['role_name']?.toString() ?? 'pelamar';
    final role = UserRole.fromString(roleStr);
    final phone = json['phone']?.toString() ?? json['telepon']?.toString() ?? json['no_hp']?.toString();
    final avatar = json['avatar']?.toString() ?? json['foto']?.toString() ?? json['profile_photo_url']?.toString();
    final companyName = json['company_name']?.toString() ?? json['nama_perusahaan']?.toString();
    final isEmailVerified = json['email_verified_at'] != null || json['is_verified'] == true;

    DateTime? createdAt;
    if (json['created_at'] != null) {
      try {
        createdAt = DateTime.parse(json['created_at'].toString());
      } catch (_) {}
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
      role: role,
      phone: phone,
      avatar: avatar,
      companyName: companyName,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.value,
      'phone': phone,
      'avatar': avatar,
      'company_name': companyName,
      'is_verified': isEmailVerified,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      phone: entity.phone,
      avatar: entity.avatar,
      companyName: entity.companyName,
      isEmailVerified: entity.isEmailVerified,
      createdAt: entity.createdAt,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? phone,
    String? avatar,
    String? companyName,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      companyName: companyName ?? this.companyName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
