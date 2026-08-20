import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  final String? message;
  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  final String? message;

  const Unauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthFailureState extends AuthState {
  final String message;
  final Map<String, dynamic>? validationErrors;

  const AuthFailureState({
    required this.message,
    this.validationErrors,
  });

  @override
  List<Object?> get props => [message, validationErrors];
}

class AuthOtpSentState extends AuthState {
  final String email;
  final String message;

  const AuthOtpSentState({
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [email, message];
}

class AuthOtpVerifiedState extends AuthState {
  final String email;
  final String otp;

  const AuthOtpVerifiedState({
    required this.email,
    required this.otp,
  });

  @override
  List<Object?> get props => [email, otp];
}

class AuthPasswordResetSuccessState extends AuthState {
  final String message;

  const AuthPasswordResetSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
