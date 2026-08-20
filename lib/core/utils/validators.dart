class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Format email tidak valid (contoh: nama@domain.com)';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi tidak boleh kosong';
    }
    if (value != password) {
      return 'Konfirmasi kata sandi tidak sesuai';
    }
    return null;
  }

  static String? validateRequired(String? value, {String fieldName = 'Bidang ini'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final cleanPhone = value.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanPhone.length < 10 || cleanPhone.length > 15) {
      return 'Nomor telepon harus terdiri dari 10 - 15 digit';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kode OTP tidak boleh kosong';
    }
    if (value.trim().length != 6) {
      return 'Kode OTP harus 6 digit';
    }
    return null;
  }
}
