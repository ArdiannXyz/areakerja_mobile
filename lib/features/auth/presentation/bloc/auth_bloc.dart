import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required AuthRepository authRepository,
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _authRepository = authRepository,
        _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginSubmitted>(_onAuthLoginSubmitted);
    on<AuthRegisterSubmitted>(_onAuthRegisterSubmitted);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthForgotPasswordSubmitted>(_onAuthForgotPasswordSubmitted);
    on<AuthVerifyOtpSubmitted>(_onAuthVerifyOtpSubmitted);
    on<AuthResetPasswordSubmitted>(_onAuthResetPasswordSubmitted);
    on<AuthClearError>(_onAuthClearError);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Memeriksa sesi...'));
    final statusResult = await _authRepository.checkAuthStatus();

    await statusResult.fold(
      (failure) async {
        emit(const Unauthenticated());
      },
      (isAuthenticated) async {
        if (!isAuthenticated) {
          emit(const Unauthenticated());
          return;
        }

        final userResult = await _authRepository.getCurrentUser();
        userResult.fold(
          (failure) => emit(const Unauthenticated()),
          (user) => emit(Authenticated(user)),
        );
      },
    );
  }

  Future<void> _onAuthLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Sedang masuk...'));
    final result = await _loginUseCase(event.request);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onAuthRegisterSubmitted(
    AuthRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Mendaftarkan akun...'));
    final result = await _registerUseCase(event.request);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Sedang keluar...'));
    await _logoutUseCase();
    emit(const Unauthenticated());
  }

  Future<void> _onAuthForgotPasswordSubmitted(
    AuthForgotPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Mengirim instruksi reset...'));
    final result = await _authRepository.forgotPassword(event.email);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (msg) => emit(AuthOtpSentState(email: event.email, message: msg)),
    );
  }

  Future<void> _onAuthVerifyOtpSubmitted(
    AuthVerifyOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Memverifikasi kode...'));
    final result = await _authRepository.verifyOtp(event.email, event.otp);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (isValid) => emit(AuthOtpVerifiedState(email: event.email, otp: event.otp)),
    );
  }

  Future<void> _onAuthResetPasswordSubmitted(
    AuthResetPasswordSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Memperbarui kata sandi...'));
    final result = await _authRepository.resetPassword(
      email: event.email,
      otp: event.otp,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (msg) => emit(AuthPasswordResetSuccessState(msg)),
    );
  }

  void _onAuthClearError(
    AuthClearError event,
    Emitter<AuthState> emit,
  ) {
    if (state is AuthFailureState) {
      emit(const Unauthenticated());
    }
  }

  AuthState _mapFailureToState(Failure failure) {
    if (failure is ValidationFailure) {
      return AuthFailureState(
        message: failure.message,
        validationErrors: failure.validationErrors,
      );
    }
    return AuthFailureState(message: failure.message);
  }
}
