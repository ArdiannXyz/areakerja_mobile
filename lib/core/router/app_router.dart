import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verify_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/kandidat/presentation/pages/dashboard_kandidat_page.dart';
import '../../features/lowongan/data/models/lowongan_model.dart';
import '../../features/lowongan/presentation/pages/daftar_lowongan_page.dart';
import '../../features/lowongan/presentation/pages/detail_lowongan_page.dart';
import '../../features/lowongan/presentation/pages/form_lamaran_page.dart';
import '../../features/notifikasi/presentation/pages/notifikasi_page.dart';
import '../../features/pelamar/presentation/pages/dashboard_pelamar_page.dart';
import '../../features/pelamar/presentation/pages/profil_pelamar_page.dart';
import '../../features/perusahaan/presentation/pages/dashboard_perusahaan_page.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerify = '/otp-verify';
  static const String dashboardPelamar = '/dashboard-pelamar';
  static const String dashboardPerusahaan = '/dashboard-perusahaan';
  static const String dashboardKandidat = '/dashboard-kandidat';
  static const String dashboardAdmin = '/dashboard-admin';
  static const String notifikasi = '/notifikasi';
  static const String daftarLowongan = '/lowongan/daftar';
  static const String detailLowongan = '/lowongan/detail';
  static const String formLamaran = '/lowongan/lamar';
  static const String profilPelamar = '/pelamar/profil';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );

      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordPage(),
          settings: settings,
        );

      case otpVerify:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email']?.toString() ?? '';
        return MaterialPageRoute(
          builder: (_) => OtpVerifyPage(email: email),
          settings: settings,
        );

      case dashboardPelamar:
        return MaterialPageRoute(
          builder: (_) => const DashboardPelamarPage(),
          settings: settings,
        );

      case dashboardPerusahaan:
        return MaterialPageRoute(
          builder: (_) => const DashboardPerusahaanPage(),
          settings: settings,
        );

      case dashboardKandidat:
        return MaterialPageRoute(
          builder: (_) => const DashboardKandidatPage(),
          settings: settings,
        );

      case dashboardAdmin:
        return MaterialPageRoute(
          builder: (_) => const DashboardPelamarPage(),
          settings: settings,
        );

      case notifikasi:
        return MaterialPageRoute(
          builder: (_) => const NotifikasiPage(),
          settings: settings,
        );

      case daftarLowongan:
        final args = settings.arguments as Map<String, dynamic>?;
        final initialCategory = args?['category']?.toString();
        return MaterialPageRoute(
          builder: (_) => DaftarLowonganPage(initialCategory: initialCategory),
          settings: settings,
        );

      case detailLowongan:
        final args = settings.arguments as Map<String, dynamic>?;
        final lowongan = args?['lowongan'] as LowonganModel?;
        if (lowongan != null) {
          return MaterialPageRoute(
            builder: (_) => DetailLowonganPage(lowongan: lowongan),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const DaftarLowonganPage(),
          settings: settings,
        );

      case formLamaran:
        final args = settings.arguments as Map<String, dynamic>?;
        final lowongan = args?['lowongan'] as LowonganModel;
        return MaterialPageRoute(
          builder: (_) => FormLamaranPage(lowongan: lowongan),
          settings: settings,
        );

      case profilPelamar:
        return MaterialPageRoute(
          builder: (_) => const ProfilPelamarPage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
    }
  }
}
