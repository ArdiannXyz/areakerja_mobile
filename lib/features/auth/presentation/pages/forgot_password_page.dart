import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      context.read<AuthBloc>().add(AuthForgotPasswordSubmitted(email));
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
          if (state is AuthOtpSentState) {
            AppSnackbar.showSuccess(context, state.message);
            Navigator.of(context).pushNamed(
              '/otp-verify',
              arguments: {'email': state.email},
            );
          } else if (state is AuthFailureState) {
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Center Vector Illustration
                    Center(
                      child: _buildForgotPasswordIllustration(),
                    ),

                    const SizedBox(height: 24),

                    // 2. Title & Subtitle (Centered)
                    const Center(
                      child: Text(
                        'Lupa Kata Sandi?',
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
                          'Masukan email Anda untuk menerima kode verifikasi untuk mengatur ulang kata sandi.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Error banner if any
                    if (state is AuthFailureState) ...[
                      CustomErrorBanner(
                        message: state.message,
                        onDismiss: () {
                          context.read<AuthBloc>().add(const AuthClearError());
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 3. Email Input Form
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _onConfirm(),
                      validator: Validators.validateEmail,
                      decoration: InputDecoration(
                        hintText: 'Masukan Email',
                        hintStyle: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                            width: 1.2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF5E14),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 4. Konfirmasi Button
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
                        onPressed: isLoading ? null : _onConfirm,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

                    const SizedBox(height: 60),

                    // 5. Bottom Link "Ingat kata sandi? Masuk"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ingat kata sandi? ',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF5E14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Center Illustration Widget (Matching Screenshot) ---
  Widget _buildForgotPasswordIllustration() {
    return SizedBox(
      width: 260,
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base shadow ground
          Positioned(
            bottom: 6,
            child: Container(
              width: 220,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Smartphone Mockup in Background
          Positioned(
            right: 40,
            bottom: 16,
            child: Container(
              width: 120,
              height: 175,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Phone Top Orange Header
                  Container(
                    width: double.infinity,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5E14),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'PASSWORD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Phone Lock Illustration Graphic
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF334155).withValues(alpha: 0.15),
                        ),
                      ),
                      const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFFFF5E14),
                        size: 22,
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Dummy input bar on phone screen
                  Container(
                    width: 84,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Dummy button on phone screen
                  Container(
                    width: 60,
                    height: 11,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5E14),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User Sitting Character (Left Foreground)
          Positioned(
            left: 24,
            bottom: 12,
            child: SizedBox(
              width: 125,
              height: 165,
              child: Stack(
                children: [
                  // Chair Back & Legs
                  Positioned(
                    left: 2,
                    bottom: 20,
                    child: Container(
                      width: 14,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 2,
                    child: Container(
                      width: 3,
                      height: 40,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  Positioned(
                    left: 38,
                    bottom: 2,
                    child: Container(
                      width: 3,
                      height: 40,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),

                  // Legs & Shoes
                  Positioned(
                    left: 22,
                    bottom: 10,
                    child: Container(
                      width: 38,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFF334155),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  // Orange Shoes
                  Positioned(
                    left: 32,
                    bottom: 4,
                    child: Container(
                      width: 36,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5E14),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  // Torso / Orange Shirt
                  Positioned(
                    left: 14,
                    top: 48,
                    child: Container(
                      width: 44,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5E14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Head & Hair
                  Positioned(
                    left: 30,
                    top: 18,
                    child: Column(
                      children: [
                        // Hair
                        Container(
                          width: 22,
                          height: 10,
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
                          width: 18,
                          height: 16,
                          color: const Color(0xFFFFD1B3),
                        ),
                      ],
                    ),
                  ),

                  // Hand holding white phone
                  Positioned(
                    left: 48,
                    top: 60,
                    child: Container(
                      width: 18,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFFF5E14), width: 1.2),
                      ),
                    ),
                  ),

                  // Thinking Bubble with '¿?'
                  Positioned(
                    left: 45,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Text(
                        '¿?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5E14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
