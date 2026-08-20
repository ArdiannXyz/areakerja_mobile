enum UserRole {
  pelamar,
  kandidat,
  perusahaan,
  admin,
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
      case UserRole.unknown:
        return 'Pengguna';
    }
  }
}

class RoleConstants {
  RoleConstants._();

  static const String pelamar = 'pelamar';
  static const String kandidat = 'kandidat';
  static const String perusahaan = 'perusahaan';
  static const String admin = 'admin';
}
