import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL configuration for API v1
  // - Android Emulator: 10.0.2.2:8000/api/v1
  // - iOS Simulator / Web / Desktop: 127.0.0.1:8000/api/v1 / localhost:8000/api/v1
  // - Real Device: Use machine's LAN IP e.g. 192.168.1.x:8000/api/v1
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api/v1';
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000/api/v1';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        return 'http://127.0.0.1:8000/api/v1';
    }
  }

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  // 1. Auth & Session Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  // 2. Jobs Feed & Application
  static const String jobs = '/jobs';
  static String jobDetail(String id) => '/jobs/$id';
  static String applyJob(String id) => '/jobs/$id/apply';
  static const String myApplications = '/my-applications';
  static const String savedJobs = '/saved-jobs';
  static String toggleSaveJob(String id) => '/jobs/$id/save';

  // 3. Pelamar Profile & CV
  static const String updatePelamarProfile = '/pelamar/profile';
  static const String uploadPelamarCv = '/pelamar/upload-cv';

  // 4. Tips Kerja / Artikel
  static const String tipsKerja = '/tips-kerja';
  static String tipsKerjaDetail(String id) => '/tips-kerja/$id';

  // 5. Notifications
  static const String notifications = '/notifications';
  static const String notificationUnreadCount = '/notifications/unread-count';
  static String markNotificationRead(String id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/mark-all-read';

  // 6. Company Features
  static const String companyDashboard = '/company/dashboard';
  static const String companyJobs = '/company/jobs';
  static const String companyStoreJob = '/company/jobs';
  static String companyJobApplicants(String id) => '/company/jobs/$id/applicants';
  static String companyUpdateApplicantStatus(String id) => '/company/applications/$id/status';
}
