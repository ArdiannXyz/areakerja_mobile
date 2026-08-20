import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/api_client.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/role_constants.dart';
import 'core/router/app_router.dart';
import 'core/storage/local_storage.dart';
import 'core/storage/secure_storage.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/kandidat/presentation/pages/dashboard_kandidat_page.dart';
import 'features/pelamar/presentation/pages/dashboard_pelamar_page.dart';
import 'features/perusahaan/presentation/pages/dashboard_perusahaan_page.dart';

import 'features/lowongan/data/repositories/lowongan_repository_impl.dart';
import 'features/lowongan/presentation/bloc/lowongan_bloc.dart';
import 'features/notifikasi/data/repositories/notifikasi_repository_impl.dart';
import 'features/notifikasi/presentation/bloc/notifikasi_bloc.dart';
import 'features/pelamar/data/repositories/pelamar_repository_impl.dart';

class AreaKerjaApp extends StatelessWidget {
  final LocalStorageService localStorageService;
  final SecureStorageService secureStorageService;
  final ApiClient apiClient;

  const AreaKerjaApp({
    super.key,
    required this.localStorageService,
    required this.secureStorageService,
    required this.apiClient,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LocalStorageService>.value(value: localStorageService),
        RepositoryProvider<SecureStorageService>.value(value: secureStorageService),
        RepositoryProvider<ApiClient>.value(value: apiClient),
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(
            apiClient: apiClient,
            secureStorage: secureStorageService,
            localStorage: localStorageService,
          ),
        ),
        RepositoryProvider<LowonganRepository>(
          create: (_) => LowonganRepositoryImpl(apiClient: apiClient),
        ),
        RepositoryProvider<NotifikasiRepository>(
          create: (_) => NotifikasiRepositoryImpl(apiClient: apiClient),
        ),
        RepositoryProvider<PelamarRepository>(
          create: (_) => PelamarRepositoryImpl(apiClient: apiClient),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (ctx) {
              final authRepo = ctx.read<AuthRepository>();
              return AuthBloc(
                authRepository: authRepo,
                loginUseCase: LoginUseCase(authRepo),
                registerUseCase: RegisterUseCase(authRepo),
                logoutUseCase: LogoutUseCase(authRepo),
              )..add(const AuthCheckRequested());
            },
          ),
          BlocProvider<LowonganBloc>(
            create: (ctx) => LowonganBloc(
              repository: ctx.read<LowonganRepository>(),
            )..add(const FetchLowonganListEvent()),
          ),
          BlocProvider<NotifikasiBloc>(
            create: (ctx) => NotifikasiBloc(
              repository: ctx.read<NotifikasiRepository>(),
            )..add(const FetchNotifikasiEvent()),
          ),
        ],
        child: MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: const _SplashAuthDecider(),
        ),
      ),
    );
  }
}

class _SplashAuthDecider extends StatelessWidget {
  const _SplashAuthDecider();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          switch (state.user.role) {
            case UserRole.perusahaan:
              return const DashboardPerusahaanPage();
            case UserRole.kandidat:
              return const DashboardKandidatPage();
            case UserRole.admin:
            case UserRole.pelamar:
            default:
              return const DashboardPelamarPage();
          }
        }

        if (state is Unauthenticated || state is AuthFailureState) {
          return const LoginPage();
        }

        // Splash / Loading Screen
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.work_rounded,
                    color: AppColors.primary,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
