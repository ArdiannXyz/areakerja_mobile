import '../constants/role_constants.dart';
import '../storage/secure_storage.dart';

class RouteGuard {
  final SecureStorageService _secureStorage;

  RouteGuard({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage;

  Future<bool> isAuthenticated() async {
    return await _secureStorage.hasToken();
  }

  Future<String> getInitialRoute() async {
    final hasToken = await _secureStorage.hasToken();
    if (!hasToken) {
      return '/login';
    }

    final roleStr = await _secureStorage.getUserRole();
    final role = UserRole.fromString(roleStr);

    switch (role) {
      case UserRole.perusahaan:
        return '/dashboard-perusahaan';
      case UserRole.kandidat:
        return '/dashboard-kandidat';
      case UserRole.admin:
        return '/dashboard-admin';
      case UserRole.pelamar:
      default:
        return '/dashboard-pelamar';
    }
  }
}
