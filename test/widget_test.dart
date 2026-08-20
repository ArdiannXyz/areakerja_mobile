import 'package:flutter_test/flutter_test.dart';
import 'package:areakerja_mobile/core/constants/role_constants.dart';
import 'package:areakerja_mobile/core/utils/validators.dart';
import 'package:areakerja_mobile/shared/models/user_model.dart';

void main() {
  group('Auth Unit Tests', () {
    test('Validators - Email validation works correctly', () {
      expect(Validators.validateEmail('test@gmail.com'), isNull);
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('invalid-email'), isNotNull);
    });

    test('Validators - Password validation works correctly', () {
      expect(Validators.validatePassword('12345678'), isNull);
      expect(Validators.validatePassword('123'), isNotNull);
      expect(Validators.validatePassword(''), isNotNull);
    });

    test('Validators - Confirm password check', () {
      expect(Validators.validateConfirmPassword('secret123', 'secret123'), isNull);
      expect(Validators.validateConfirmPassword('different', 'secret123'), isNotNull);
    });

    test('UserModel - Serialization and Deserialization', () {
      final json = {
        'id': 'usr_101',
        'name': 'Budi Santoso',
        'email': 'budi@example.com',
        'role': 'pelamar',
        'phone': '081234567890',
        'is_verified': true,
      };

      final user = UserModel.fromJson(json);
      expect(user.id, 'usr_101');
      expect(user.name, 'Budi Santoso');
      expect(user.email, 'budi@example.com');
      expect(user.role, UserRole.pelamar);
      expect(user.isEmailVerified, true);
    });

    test('UserRole - fromString parser', () {
      expect(UserRole.fromString('pelamar'), UserRole.pelamar);
      expect(UserRole.fromString('perusahaan'), UserRole.perusahaan);
      expect(UserRole.fromString('kandidat'), UserRole.kandidat);
      expect(UserRole.fromString('admin'), UserRole.admin);
    });
  });
}
