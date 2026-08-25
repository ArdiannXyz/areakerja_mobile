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

  // =========================================================================
  // 1. PUBLIC ROUTES (Tanpa Autentikasi)
  // =========================================================================

  // --- Autentikasi & Reset Password ---
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  // --- Jobs Feed & Pencarian Lowongan ---
  static const String jobs = '/jobs';
  static String jobDetail(String id) => '/jobs/$id';
  static const String metaFilters = '/meta/filters';

  // --- Publik Profil Perusahaan ---
  static String companyDetail(String id) => '/companies/$id';
  static String companyPublicJobs(String id) => '/companies/$id/jobs';

  // --- Banners & Master Data Dinamis ---
  static const String banners = '/banners';
  static const String metaLocations = '/meta/locations';
  static const String metaProvinces = '/meta/provinces';
  static const String metaCities = '/meta/cities';
  static const String metaFaqs = '/meta/faqs';
  static const String metaLegal = '/meta/legal';
  static const String metaAppVersion = '/meta/app-version';

  // --- Tips Kerja / Artikel ---
  static const String tipsKerja = '/tips-kerja';
  static String tipsKerjaDetail(String id) => '/tips-kerja/$id';

  // --- Paket & Payment Channels ---
  static const String koinPackages = '/packages/koin';
  static const String subscriptionPackages = '/packages/subscription';
  static const String paymentChannels = '/payments/channels';

  // =========================================================================
  // 2. AUTHENTICATED ROUTES (Wajib Bearer Token: Laravel Sanctum)
  // =========================================================================

  // --- Auth & Account Management ---
  static const String profile = '/auth/profile';
  static const String updatePassword = '/auth/password';
  static const String deleteAccount = '/auth/account';
  static const String logout = '/auth/logout';

  // --- Pelamar Profile, Skills, Avatar & CV ---
  static const String updatePelamarProfile = '/pelamar/profile';
  static const String uploadPelamarAvatar = '/pelamar/upload-avatar';
  static const String uploadPelamarCv = '/pelamar/upload-cv';
  static const String upgradeKandidat = '/pelamar/upgrade-kandidat';
  static const String pelamarSkills = '/pelamar/skills';

  // --- Pelamar Experience (Pengalaman Kerja) ---
  static const String pelamarExperiences = '/pelamar/experiences';
  static String pelamarExperienceDetail(String id) => '/pelamar/experiences/$id';

  // --- Pelamar Education (Riwayat Pendidikan) ---
  static const String pelamarEducations = '/pelamar/educations';
  static String pelamarEducationDetail(String id) => '/pelamar/educations/$id';

  // --- Candidate Job Applications & Saved Jobs ---
  static String applyJob(String id) => '/jobs/$id/apply';
  static const String myApplications = '/my-applications';
  static const String savedJobs = '/saved-jobs';
  static String toggleSaveJob(String id) => '/jobs/$id/save';

  // --- Direct Job Offers (Tawaran Kerja untuk Kandidat) ---
  static const String jobOffers = '/pelamar/job-offers';
  static String respondJobOffer(String id) => '/pelamar/job-offers/$id/respond';

  // --- Notifications & FCM Token ---
  static const String notifications = '/notifications';
  static const String notificationUnreadCount = '/notifications/unread-count';
  static String markNotificationRead(String id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/mark-all-read';
  static String deleteNotification(String id) => '/notifications/$id';
  static const String deleteAllNotifications = '/notifications';
  static const String deviceToken = '/notifications/device-token';

  // --- Company Module ---
  static const String companyDashboard = '/company/dashboard';
  static const String companyProfile = '/company/profile';
  static const String companyUploadLogo = '/company/upload-logo';

  // CRUD Company Jobs
  static const String companyJobs = '/company/jobs';
  static const String companyStoreJob = '/company/jobs';
  static String companyJobDetail(String id) => '/company/jobs/$id';
  static String companyToggleJobStatus(String id) => '/company/jobs/$id/toggle-status';

  // Applicants & Status
  static String companyJobApplicants(String id) => '/company/jobs/$id/applicants';
  static String companyUpdateApplicantStatus(String id) => '/company/applications/$id/status';

  // Talent Hunter
  static const String companyTalents = '/company/talents';
  static String companyTalentDetail(String id) => '/company/talents/$id';
  static String companySendOffer(String id) => '/company/talents/$id/offer';

  // --- Payment & Transactions ---
  static const String paymentsCheckout = '/payments/checkout';
  static const String paymentsHistory = '/payments/history';
  static String paymentDetail(String id) => '/payments/$id';
}
