import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/login_request_model.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(LoginRequestModel params) async {
    return await _repository.login(params);
  }
}
