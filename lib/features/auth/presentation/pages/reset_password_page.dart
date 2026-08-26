import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_success_dialogs.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onKonfirmasiPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthResetPasswordSubmitted(
              email: widget.email,
              otp: widget.otp,
              newPassword: _newPasswordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF0F172A),
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordResetSuccessState) {
            // Tampilkan popup berhasil ganti password
            AuthSuccessDialogHelper.showResetPasswordSuccess(
              context: context,
              onBackToLogin: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
            );
          } else if (state is AuthFailureState) {
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ilustrasi
                    Center(child: _buildResetPasswordIllustration()),
                    const SizedBox(height: 28),

                    // Judul
                    const Center(
                      child: Text(
                        'Atur Ulang Kata Sandi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Silahkan buat kata sandi baru untuk akun Anda',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Kata Sandi Baru
                    const Text(
                      'Kata Sandi Baru',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_showNewPassword,
                      textInputAction: TextInputAction.next,
                      validator: Validators.validatePassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                              () => _showNewPassword = !_showNewPassword),
                          child: Icon(
                            _showNewPassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: const Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1), width: 1.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1), width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFFF5E14), width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFEF4444), width: 1.2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFEF4444), width: 1.5),
                        ),
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Konfirmasi Kata Sandi Baru
                    const Text(
                      'Konfirmasi Kata Sandi Baru',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _onKonfirmasiPressed(),
                      validator: (val) => Validators.validateConfirmPassword(
                          val, _newPasswordController.text),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() =>
                              _showConfirmPassword = !_showConfirmPassword),
                          child: Icon(
                            _showConfirmPassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: const Color(0xFF94A3B8),
                            size: 20,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1), width: 1.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1), width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFFF5E14), width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFEF4444), width: 1.2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Color(0xFFEF4444), width: 1.5),
                        ),
                        errorStyle: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Tombol Konfirmasi
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5E14),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isLoading ? null : _onKonfirmasiPressed,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Konfirmasi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Ilustrasi "Atur Ulang Kata Sandi" — wanita di depan laptop dengan password reset
  Widget _buildResetPasswordIllustration() {
    return SizedBox(
      width: 260,
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shadow ground
          Positioned(
            bottom: 4,
            child: Container(
              width: 220,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Laptop screen (background)
          Positioned(
            right: 20,
            bottom: 30,
            child: Container(
              width: 140,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Laptop top bar
                  Container(
                    width: double.infinity,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5E14),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'RESET PASSWORD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Lock icon in circle
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF5E14).withValues(alpha: 0.12),
                        ),
                      ),
                      const Icon(
                        Icons.lock_reset_rounded,
                        color: Color(0xFFFF5E14),
                        size: 18,
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Password field lines
                  _laptopLine(80, const Color(0xFFF1F5F9)),
                  const SizedBox(height: 4),
                  _laptopLine(80, const Color(0xFFF1F5F9)),
                  const SizedBox(height: 6),

                  // Orange button
                  Container(
                    width: 54,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5E14),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Laptop base
          Positioned(
            right: 14,
            bottom: 22,
            child: Container(
              width: 152,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
            ),
          ),

          // Character (woman at laptop)
          Positioned(
            left: 4,
            bottom: 18,
            child: _buildCharacterWithLaptop(),
          ),

          // Small decorative star top-right
          Positioned(
            right: 8,
            top: 16,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5E14),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Triangle accent top-left
          Positioned(
            left: 16,
            top: 20,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF5E14),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _laptopLine(double width, Color color) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildCharacterWithLaptop() {
    return SizedBox(
      width: 90,
      height: 130,
      child: Stack(
        children: [
          // Chair back
          Positioned(
            left: 2,
            bottom: 18,
            child: Container(
              width: 12,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Chair legs
          Positioned(
            left: 8,
            bottom: 0,
            child: Container(
                width: 3, height: 36, color: const Color(0xFF94A3B8)),
          ),
          Positioned(
            left: 36,
            bottom: 0,
            child: Container(
                width: 3, height: 36, color: const Color(0xFF94A3B8)),
          ),

          // Legs (dark pants)
          Positioned(
            left: 18,
            bottom: 8,
            child: Container(
              width: 36,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF334155),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
          ),
          // Shoes
          Positioned(
            left: 28,
            bottom: 2,
            child: Container(
              width: 34,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5E14),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),

          // Torso (orange shirt)
          Positioned(
            left: 12,
            top: 46,
            child: Container(
              width: 44,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5E14),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Head & hair
          Positioned(
            left: 28,
            top: 16,
            child: Column(
              children: [
                // Hair
                Container(
                  width: 24,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                ),
                // Face
                Container(
                  width: 20,
                  height: 16,
                  color: const Color(0xFFFFD1B3),
                ),
              ],
            ),
          ),

          // Arm / hands on laptop
          Positioned(
            left: 50,
            top: 58,
            child: Container(
              width: 36,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD1B3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
