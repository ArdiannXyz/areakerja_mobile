import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  final dynamic errors;

  const ServerFailure({
    required super.message,
    super.statusCode,
    this.errors,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Koneksi internet bermasalah. Pastikan perangkat Anda terhubung ke internet.',
  });
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Gagal memuat data dari penyimpanan lokal.',
  });
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? validationErrors;

  const ValidationFailure({
    required super.message,
    this.validationErrors,
  });

  @override
  List<Object?> get props => [message, validationErrors];
}
