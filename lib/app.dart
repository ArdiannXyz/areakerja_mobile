import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/api_client.dart';
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
import 'features/pelamar/presentation/pages/dashboard_pelamar_page.dart';
import 'features/perusahaan/data/repositories/perusahaan_repository_impl.dart';
import 'features/perusahaan/presentation/bloc/koin_bloc.dart';
import 'features/perusahaan/presentation/bloc/perusahaan_bloc.dart';
import 'features/perusahaan/presentation/pages/dashboard_perusahaan_page.dart';

import 'features/lowongan/data/repositories/lowongan_repository_impl.dart';
import 'features/lowongan/presentation/bloc/lowongan_bloc.dart';
import 'features/notifikasi/data/repositories/notifikasi_repository_impl.dart';
import 'features/notifikasi/presentation/bloc/notifikasi_bloc.dart';
import 'features/pelamar/data/repositories/pelamar_repository_impl.dart';
import 'features/splash/presentation/pages/splash_screen_page.dart';

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
        // Repository perusahaan — digunakan oleh PerusahaanBloc & KoinBloc
        RepositoryProvider<PerusahaanRepository>(
          create: (_) => PerusahaanRepositoryImpl(apiClient: apiClient),
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
          // BLoC untuk fitur Perusahaan
          BlocProvider<PerusahaanBloc>(
            create: (ctx) => PerusahaanBloc(
              repository: ctx.read<PerusahaanRepository>(),
            ),
          ),
          // BLoC untuk manajemen Koin Perusahaan
          BlocProvider<KoinBloc>(
            create: (ctx) => KoinBloc(
              repository: ctx.read<PerusahaanRepository>(),
            ),
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

class _SplashAuthDecider extends StatefulWidget {
  const _SplashAuthDecider();

  @override
  State<_SplashAuthDecider> createState() => _SplashAuthDeciderState();
}

class _SplashAuthDeciderState extends State<_SplashAuthDecider> {
  bool _animationCompleted = false;

  void _onSplashComplete() {
    if (mounted) {
      setState(() {
        _animationCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_animationCompleted) {
      return SplashScreenPage(
        onAnimationComplete: _onSplashComplete,
      );
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          switch (state.user.role) {
            case UserRole.perusahaan:
              return const DashboardPerusahaanPage();
            case UserRole.superAdmin:
            case UserRole.finance:
              // Role ini hanya menggunakan AreaKerja Web
              return const _WebOnlyRolePage();
            case UserRole.kandidat:
            case UserRole.admin:
            case UserRole.pelamar:
            default:
              return const DashboardPelamarPage();
          }
        }

        return const LoginPage();
      },
    );
  }
}

// ─── Halaman info untuk role yang hanya dapat menggunakan AreaKerja Web ──────

class _WebOnlyRolePage extends StatelessWidget {
  const _WebOnlyRolePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3EB),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.desktop_windows_rounded,
                    size: 48,
                    color: Color(0xFFFF6B00),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Gunakan AreaKerja Web',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Role Anda hanya dapat mengakses AreaKerja melalui aplikasi Web.\n\nSilakan buka areakerja.com di browser untuk melanjutkan.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthLogoutRequested());
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text(
                      'Keluar dari Akun',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
