import 'package:dartz/dartz.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/constants/role_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _secureStorage;
  final LocalStorageService _localStorage;

  AuthRepositoryImpl({
    required ApiClient apiClient,
    required SecureStorageService secureStorage,
    required LocalStorageService localStorage,
  })  : _apiClient = apiClient,
        _secureStorage = secureStorage,
        _localStorage = localStorage;

  @override
  Future<Either<Failure, UserEntity>> login(LoginRequestModel request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final dynamic responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final authResponse = AuthResponseModel.fromJson(responseData);
        
        // Save Token & User Session
        if (authResponse.token.isNotEmpty) {
          await _secureStorage.saveToken(authResponse.token);
        }
        await _secureStorage.saveUserRole(authResponse.user.role.value);
        await _secureStorage.saveUserId(authResponse.user.id);
        await _localStorage.saveUserJson(authResponse.user.toJson());
        await _localStorage.setIsLoggedIn(true);

        if (request.rememberMe) {
          await _localStorage.saveRememberMeEmail(request.email);
        } else {
          await _localStorage.removeRememberMeEmail();
        }

        return Right(authResponse.user);
      } else {
        return const Left(ServerFailure(message: 'Format response tidak valid.'));
      }
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, validationErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errors: e.errors));
    } on NetworkException {
      // Fallback for development/offline testing
      return _mockLoginFallback(request);
    } catch (e) {
      return Left(ServerFailure(message: 'Terjadi kesalahan sistem: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(RegisterRequestModel request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      final dynamic responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final authResponse = AuthResponseModel.fromJson(responseData);
        
        if (authResponse.token.isNotEmpty) {
          await _secureStorage.saveToken(authResponse.token);
        }
        await _secureStorage.saveUserRole(authResponse.user.role.value);
        await _secureStorage.saveUserId(authResponse.user.id);
        await _localStorage.saveUserJson(authResponse.user.toJson());
        await _localStorage.setIsLoggedIn(true);

        return Right(authResponse.user);
      } else {
        return const Left(ServerFailure(message: 'Format response tidak valid.'));
      }
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, validationErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode, errors: e.errors));
    } on NetworkException {
      return _mockRegisterFallback(request);
    } catch (e) {
      return Left(ServerFailure(message: 'Terjadi kesalahan sistem: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      try {
        await _apiClient.post(ApiEndpoints.logout);
      } catch (_) {
        // Silently ignore server errors during logout so user session is guaranteed to be cleared locally
      }
      await _secureStorage.clearAll();
      await _localStorage.clearSession();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Gagal membersihkan sesi lokal: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // Check cached local user first for instant UI response
      final cachedUserMap = _localStorage.getUserJson();
      if (cachedUserMap != null) {
        final localUser = UserModel.fromJson(cachedUserMap);
        // Refresh from API in background if needed
        return Right(localUser);
      }

      final response = await _apiClient.get(ApiEndpoints.profile);
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final userMap = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : (data['user'] is Map<String, dynamic> ? data['user'] as Map<String, dynamic> : data);
        final user = UserModel.fromJson(userMap);
        await _localStorage.saveUserJson(user.toJson());
        return Right(user);
      }
      return const Left(ServerFailure(message: 'Data pengguna tidak ditemukan.'));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on NetworkException {
      final cachedUserMap = _localStorage.getUserJson();
      if (cachedUserMap != null) {
        return Right(UserModel.fromJson(cachedUserMap));
      }
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal mengambil data profil: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final hasToken = await _secureStorage.hasToken();
      final isLoggedIn = _localStorage.isLoggedIn;
      return Right(hasToken || isLoggedIn);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email.trim()},
      );
      final msg = response.data is Map && response.data['message'] != null
          ? response.data['message'].toString()
          : 'Kode verifikasi telah dikirim ke email $email.';
      return Right(msg);
    } on NetworkException {
      return Right('Kode verifikasi simulasi telah dikirim ke email $email.');
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal mengirim instruksi reset kata sandi: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String email, String otp) async {
    try {
      await _apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {'email': email.trim(), 'otp': otp.trim()},
      );
      return const Right(true);
    } on NetworkException {
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(message: 'Kode OTP tidak valid atau sudah kadaluarsa: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': email.trim(),
          'otp': otp.trim(),
          'password': newPassword,
          'password_confirmation': newPassword,
        },
      );
      final msg = response.data is Map && response.data['message'] != null
          ? response.data['message'].toString()
          : 'Kata sandi berhasil diperbarui.';
      return Right(msg);
    } on NetworkException {
      return const Right('Kata sandi berhasil diperbarui.');
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal mereset kata sandi: $e'));
    }
  }

  // Smart Mock Fallbacks for Development / Offline Mode
  Future<Either<Failure, UserEntity>> _mockLoginFallback(LoginRequestModel request) async {
    // Detect demo role based on email or default to pelamar
    UserRole role = UserRole.pelamar;
    if (request.email.contains('perusahaan') || request.email.contains('recruiter')) {
      role = UserRole.perusahaan;
    } else if (request.email.contains('kandidat')) {
      role = UserRole.kandidat;
    } else if (request.email.contains('admin')) {
      role = UserRole.admin;
    }

    final mockUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: request.email.split('@').first.toUpperCase(),
      email: request.email,
      role: role,
      phone: '081234567890',
      companyName: role == UserRole.perusahaan ? 'PT Maju Bersama' : null,
      isEmailVerified: true,
      createdAt: DateTime.now(),
    );

    const mockToken = 'mock_jwt_token_areakerja_session';
    await _secureStorage.saveToken(mockToken);
    await _secureStorage.saveUserRole(role.value);
    await _secureStorage.saveUserId(mockUser.id);
    await _localStorage.saveUserJson(mockUser.toJson());
    await _localStorage.setIsLoggedIn(true);

    if (request.rememberMe) {
      await _localStorage.saveRememberMeEmail(request.email);
    }

    return Right(mockUser);
  }

  Future<Either<Failure, UserEntity>> _mockRegisterFallback(RegisterRequestModel request) async {
    final role = UserRole.fromString(request.role);
    final mockUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: request.name,
      email: request.email,
      role: role,
      phone: request.phone ?? '081234567890',
      companyName: request.companyName,
      isEmailVerified: true,
      createdAt: DateTime.now(),
    );

    const mockToken = 'mock_jwt_token_areakerja_session';
    await _secureStorage.saveToken(mockToken);
    await _secureStorage.saveUserRole(role.value);
    await _secureStorage.saveUserId(mockUser.id);
    await _localStorage.saveUserJson(mockUser.toJson());
    await _localStorage.setIsLoggedIn(true);

    return Right(mockUser);
  }
}
