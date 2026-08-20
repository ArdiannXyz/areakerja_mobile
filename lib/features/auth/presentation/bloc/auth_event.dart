import 'package:equatable/equatable.dart';
import '../../data/models/login_request_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginSubmitted extends AuthEvent {
  final LoginRequestModel request;

  const AuthLoginSubmitted(this.request);

  @override
  List<Object?> get props => [request];
}

class AuthRegisterSubmitted extends AuthEvent {
  final RegisterRequestModel request;

  const AuthRegisterSubmitted(this.request);

  @override
  List<Object?> get props => [request];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthForgotPasswordSubmitted extends AuthEvent {
  final String email;

  const AuthForgotPasswordSubmitted(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthVerifyOtpSubmitted extends AuthEvent {
  final String email;
  final String otp;

  const AuthVerifyOtpSubmitted({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class AuthResetPasswordSubmitted extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const AuthResetPasswordSubmitted({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}

class AuthClearError extends AuthEvent {
  const AuthClearError();
}
