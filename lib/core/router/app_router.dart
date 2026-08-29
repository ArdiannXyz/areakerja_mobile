import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_verify_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/kandidat/presentation/pages/dashboard_kandidat_page.dart';
import '../../features/lowongan/data/models/lowongan_model.dart';
import '../../features/lowongan/presentation/pages/daftar_lowongan_page.dart';
import '../../features/lowongan/presentation/pages/detail_lowongan_page.dart';
import '../../features/lowongan/presentation/pages/form_lamaran_page.dart';
import '../../features/notifikasi/presentation/pages/notifikasi_page.dart';
import '../../features/pelamar/presentation/pages/alamat_page.dart';
import '../../features/pelamar/presentation/pages/dashboard_pelamar_page.dart';
import '../../features/pelamar/presentation/pages/data_diri_page.dart';
import '../../features/pelamar/presentation/pages/faq_page.dart';
import '../../features/pelamar/presentation/pages/profil_pelamar_page.dart';
import '../../features/pelamar/presentation/pages/ubah_kata_sandi_page.dart';
import '../../features/pembayaran/presentation/pages/detail_transaksi_page.dart';
import '../../features/perusahaan/presentation/pages/dashboard_perusahaan_page.dart';
import '../../features/perusahaan/presentation/pages/kelola_lowongan_page.dart';
import '../../features/perusahaan/presentation/pages/lamaran_masuk_page.dart';
import '../../features/perusahaan/presentation/pages/koin_page.dart';
import '../../features/perusahaan/presentation/pages/profil_perusahaan_page.dart';

import '../../features/splash/presentation/pages/splash_screen_page.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/splash';
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
  static const String dataDiri = '/pelamar/data-diri';
  static const String alamatPelamar = '/pelamar/alamat';
  static const String faq = '/faq';
  static const String ubahKataSandi = '/pelamar/ubah-kata-sandi';
  static const String detailTransaksi = '/transaksi/detail';

  // Perusahaan routes
  static const String perusahaanKelolaLowongan = '/perusahaan/lowongan';
  static const String perusahaanLamaranMasuk = '/perusahaan/pelamar';
  static const String perusahaanKoin = '/perusahaan/koin';
  static const String perusahaanProfil = '/perusahaan/profil';
  static const String resetPassword = '/reset-password';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreenPage(),
          settings: settings,
        );

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

      case resetPassword:
        final args = settings.arguments as Map<String, dynamic>?;
        final rpEmail = args?['email']?.toString() ?? '';
        final rpOtp = args?['otp']?.toString() ?? '';
        return MaterialPageRoute(
          builder: (_) => ResetPasswordPage(email: rpEmail, otp: rpOtp),
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

      case dataDiri:
        return MaterialPageRoute(
          builder: (_) => const DataDiriPage(),
          settings: settings,
        );

      case alamatPelamar:
        return MaterialPageRoute(
          builder: (_) => const AlamatPage(),
          settings: settings,
        );

      case faq:
        return MaterialPageRoute(
          builder: (_) => const FaqPage(),
          settings: settings,
        );

      case ubahKataSandi:
        return MaterialPageRoute(
          builder: (_) => const UbahKataSandiPage(),
          settings: settings,
        );

      case detailTransaksi:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DetailTransaksiPage(
            noTransaksi: args?['noTransaksi']?.toString(),
            namaKandidat: args?['namaKandidat']?.toString(),
            divisi: args?['divisi']?.toString(),
            bankName: args?['bankName']?.toString(),
            totalPayment: args?['totalPayment']?.toString(),
          ),
          settings: settings,
        );

      case perusahaanKelolaLowongan:
        return MaterialPageRoute(
          builder: (_) => const KelolaLowonganPage(),
          settings: settings,
        );

      case perusahaanLamaranMasuk:
        return MaterialPageRoute(
          builder: (_) => const LamaranMasukPage(),
          settings: settings,
        );

      case perusahaanKoin:
        return MaterialPageRoute(
          builder: (_) => const KoinPage(),
          settings: settings,
        );

      case perusahaanProfil:
        return MaterialPageRoute(
          builder: (_) => const ProfilPerusahaanPage(),
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
