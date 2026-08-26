import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class OtpVerifyPage extends StatefulWidget {
  final String email;

  const OtpVerifyPage({
    super.key,
    required this.email,
  });

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _resendCountdown = 90;
  Timer? _timer;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _resendCountdown = 90;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  void _onKonfirmasiPressed() {
    if (_otpCode.length != 4) {
      setState(() => _hasError = true);
      AppSnackbar.showError(context, 'Masukkan 4 digit kode verifikasi secara lengkap.');
      return;
    }
    setState(() => _hasError = false);
    context.read<AuthBloc>().add(
          AuthVerifyOtpSubmitted(email: widget.email, otp: _otpCode),
        );
  }

  void _onResendOtp() {
    if (_resendCountdown == 0) {
      context.read<AuthBloc>().add(AuthForgotPasswordSubmitted(widget.email));
      _startCountdown();
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
          if (state is AuthOtpVerifiedState) {
            // OTP valid → navigasi ke halaman buat password baru
            Navigator.of(context).pushNamed(
              '/reset-password',
              arguments: {
                'email': state.email,
                'otp': state.otp,
              },
            );
          } else if (state is AuthFailureState) {
            setState(() => _hasError = true);
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Ilustrasi
                  Center(child: _buildOtpIllustration()),
                  const SizedBox(height: 28),

                  // Judul
                  const Text(
                    'Cek emailmu',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subjudul
                  Text(
                    'Masukan 4 digit kode verifikasi yang dikirimke\n${widget.email}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // 4 Kotak OTP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: SizedBox(
                          width: 62,
                          height: 66,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: _hasError
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFFCBD5E1),
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: _hasError
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFFCBD5E1),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: _hasError
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFFFF5E14),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (_hasError) setState(() => _hasError = false);
                              if (value.isNotEmpty) {
                                if (index < 3) {
                                  _focusNodes[index + 1].requestFocus();
                                } else {
                                  _focusNodes[index].unfocus();
                                }
                              } else {
                                if (index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),

                  // Error label
                  if (_hasError) ...[  
                    const SizedBox(height: 8),
                    const Text(
                      'Kode verifikasi salah!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

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

                  const SizedBox(height: 20),

                  // Kirim ulang
                  _resendCountdown > 0
                      ? RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Belum terima email? ',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                            children: [
                              TextSpan(
                                text: 'Kirim Ulang($_resendCountdown)',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: _onResendOtp,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              text: 'Belum terima email? ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Kirim Ulang',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFFF5E14),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Ilustrasi envelope / email dengan karakter
  Widget _buildOtpIllustration() {
    return SizedBox(
      width: 260,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shadow ground
          Positioned(
            bottom: 4,
            child: Container(
              width: 200,
              height: 20,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),

          // Large envelope background
          Positioned(
            right: 10,
            top: 20,
            child: Container(
              width: 145,
              height: 125,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFFF5E14).withValues(alpha: 0.3),
                    width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Envelope top orange header
                  Container(
                    width: double.infinity,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5E14),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.mail_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _envelopeLine(80),
                  const SizedBox(height: 5),
                  _envelopeLine(60),
                  const SizedBox(height: 5),
                  _envelopeLine(70),
                  const SizedBox(height: 8),
                  Container(
                    width: 58,
                    height: 11,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5E14),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Flying envelope small (top-right)
          Positioned(
            right: 0,
            top: 6,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 28,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5E14),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                    Icons.mail_outline_rounded,
                    color: Colors.white,
                    size: 14),
              ),
            ),
          ),

          // Orange circle accent (top-left)
          Positioned(
            left: 8,
            top: 8,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5E14),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Character (girl) sitting left
          Positioned(
            left: 4,
            bottom: 16,
            child: _buildCharacter(),
          ),
        ],
      ),
    );
  }

  Widget _envelopeLine(double width) {
    return Container(
      width: width,
      height: 7,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildCharacter() {
    return SizedBox(
      width: 80,
      height: 115,
      child: Stack(
        children: [
          // Head hair
          Positioned(
            left: 22,
            top: 0,
            child: Container(
              width: 28,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          ),
          // Face
          Positioned(
            left: 24,
            top: 10,
            child: Container(
              width: 24,
              height: 18,
              color: const Color(0xFFFFD1B3),
            ),
          ),
          // Torso (orange shirt)
          Positioned(
            left: 16,
            top: 26,
            child: Container(
              width: 42,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5E14),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Arm holding phone
          Positioned(
            left: 52,
            top: 32,
            child: Container(
              width: 16,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: const Color(0xFFFF5E14), width: 1.2),
              ),
            ),
          ),
          // Legs
          Positioned(
            left: 20,
            top: 60,
            child: Container(
              width: 34,
              height: 46,
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
            left: 26,
            bottom: 0,
            child: Container(
              width: 30,
              height: 9,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5E14),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
