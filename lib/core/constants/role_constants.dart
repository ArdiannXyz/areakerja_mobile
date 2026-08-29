enum UserRole {
  pelamar,
  kandidat,
  perusahaan,
  admin,
  superAdmin,
  finance,
  unknown;

  static UserRole fromString(String? role) {
    switch (role?.toLowerCase().trim()) {
      case 'pelamar':
      case 'user':
      case 'seeker':
        return UserRole.pelamar;
      case 'kandidat':
      case 'candidate':
        return UserRole.kandidat;
      case 'perusahaan':
      case 'company':
      case 'recruiter':
        return UserRole.perusahaan;
      case 'admin':
      case 'administrator':
        return UserRole.admin;
      case 'super_admin':
      case 'superadmin':
      case 'super admin':
        return UserRole.superAdmin;
      case 'finance':
      case 'keuangan':
        return UserRole.finance;
      default:
        return UserRole.unknown;
    }
  }

  String get value {
    switch (this) {
      case UserRole.pelamar:
        return 'pelamar';
      case UserRole.kandidat:
        return 'kandidat';
      case UserRole.perusahaan:
        return 'perusahaan';
      case UserRole.admin:
        return 'admin';
      case UserRole.superAdmin:
        return 'super_admin';
      case UserRole.finance:
        return 'finance';
      case UserRole.unknown:
        return 'pelamar';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.pelamar:
        return 'Pencari Kerja';
      case UserRole.kandidat:
        return 'Kandidat Premium';
      case UserRole.perusahaan:
        return 'Perusahaan';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.finance:
        return 'Finance';
      case UserRole.unknown:
        return 'Pengguna';
    }
  }

  /// Role yang hanya dapat menggunakan AreaKerja Web (bukan Mobile)
  bool get isWebOnlyRole {
    return this == UserRole.superAdmin || this == UserRole.finance;
  }

  /// Role yang dapat menggunakan AreaKerja Mobile
  bool get isMobileRole {
    return this == UserRole.pelamar ||
        this == UserRole.kandidat ||
        this == UserRole.perusahaan;
  }
}

class RoleConstants {
  RoleConstants._();

  static const String pelamar = 'pelamar';
  static const String kandidat = 'kandidat';
  static const String perusahaan = 'perusahaan';
  static const String admin = 'admin';
  static const String superAdmin = 'super_admin';
  static const String finance = 'finance';
}
