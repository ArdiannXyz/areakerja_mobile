class AppStrings {
  AppStrings._();

  // General App
  static const String appName = 'AreaKerja';
  static const String appTagline = 'Temukan Karir Impianmu Bersama Kami';

  // Auth - Titles & Subtitles
  static const String loginTitle = 'Selamat Datang Kembali!';
  static const String loginSubtitle = 'Masuk ke akun AreaKerja untuk melanjutkan';
  static const String registerTitle = 'Buat Akun Baru';
  static const String registerSubtitle = 'Daftar sekarang dan raih peluang karir terbaikmu';
  static const String forgotPasswordTitle = 'Lupa Kata Sandi?';
  static const String forgotPasswordSubtitle = 'Masukkan email terdaftar untuk menerima instruksi reset';
  static const String otpTitle = 'Verifikasi OTP';
  static const String otpSubtitle = 'Masukkan kode 6-digit yang kami kirimkan ke email Anda';

  // Form Fields & Labels
  static const String email = 'Email';
  static const String emailPlaceholder = 'nama@email.com';
  static const String password = 'Kata Sandi';
  static const String passwordPlaceholder = 'Minimal 8 karakter';
  static const String confirmPassword = 'Konfirmasi Kata Sandi';
  static const String confirmPasswordPlaceholder = 'Ulangi kata sandi';
  static const String fullName = 'Nama Lengkap';
  static const String fullNamePlaceholder = 'Masukkan nama lengkap';
  static const String companyName = 'Nama Perusahaan';
  static const String companyNamePlaceholder = 'Contoh: PT Teknologi Maju';
  static const String phoneNumber = 'Nomor Telepon';
  static const String phoneNumberPlaceholder = '081234567890';
  static const String rememberMe = 'Ingat Saya';
  static const String forgotPassword = 'Lupa Kata Sandi?';

  // Roles
  static const String rolePelamar = 'Pencari Kerja';
  static const String rolePerusahaan = 'Perusahaan / Recruiter';
  static const String roleKandidat = 'Kandidat';
  static const String roleAdmin = 'Administrator';
  static const String selectRole = 'Pilih Jenis Akun';

  // Buttons & Actions
  static const String login = 'Masuk';
  static const String register = 'Daftar Sekarang';
  static const String logout = 'Keluar';
  static const String sendResetCode = 'Kirim Kode Verifikasi';
  static const String verifyCode = 'Verifikasi';
  static const String resendCode = 'Kirim Ulang Kode';
  static const String haveAccount = 'Sudah punya akun?';
  static const String dontHaveAccount = 'Belum punya akun?';
  static const String orContinueWith = 'atau masuk dengan';

  // Terms & Conditions
  static const String agreeTerms = 'Saya menyetujui Syarat & Ketentuan dan Kebijakan Privasi AreaKerja';

  // Validation Messages
  static const String fieldRequired = 'Bidang ini wajib diisi';
  static const String invalidEmail = 'Format email tidak valid';
  static const String passwordTooShort = 'Kata sandi minimal 8 karakter';
  static const String passwordNotMatch = 'Konfirmasi kata sandi tidak cocok';
  static const String invalidPhone = 'Nomor telepon tidak valid (minimal 10 digit)';
  static const String selectRoleRequired = 'Silakan pilih jenis akun';
  static const String termsMustBeAccepted = 'Anda harus menyetujui syarat & ketentuan';

  // Feedback Messages
  static const String loginSuccess = 'Berhasil masuk';
  static const String registerSuccess = 'Pendaftaran berhasil! Silakan masuk';
  static const String logoutSuccess = 'Berhasil keluar';
  static const String otpSentSuccess = 'Kode verifikasi telah dikirim ke email Anda';
  static const String passwordResetSuccess = 'Kata sandi berhasil diperbarui';
  static const String generalError = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String networkError = 'Koneksi internet bermasalah. Periksa jaringan Anda.';
  static const String sessionExpired = 'Sesi telah berakhir. Silakan login kembali.';
}
