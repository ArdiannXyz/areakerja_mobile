import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/login_request_model.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(LoginRequestModel request);
  
  Future<Either<Failure, UserEntity>> register(RegisterRequestModel request);
  
  Future<Either<Failure, void>> logout();
  
  Future<Either<Failure, UserEntity>> getCurrentUser();
  
  Future<Either<Failure, bool>> checkAuthStatus();
  
  Future<Either<Failure, String>> forgotPassword(String email);
  
  Future<Either<Failure, bool>> verifyOtp(String email, String otp);
  
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });
}
