class LoginRequestModel {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequestModel({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'password': password,
    };
  }
}

class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String role;
  final String? phone;
  final String? companyName;

  const RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
    this.phone,
    this.companyName,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
    };
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone!.trim();
      map['telepon'] = phone!.trim();
    }
    if (companyName != null && companyName!.isNotEmpty) {
      map['company_name'] = companyName!.trim();
      map['nama_perusahaan'] = companyName!.trim();
    }
    return map;
  }
}
