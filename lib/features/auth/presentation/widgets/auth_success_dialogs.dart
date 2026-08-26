import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

// REGISTER SUCCESS DIALOG

class RegisterSuccessDialog extends StatefulWidget {
  final String userName;
  final String userRole;
  final VoidCallback? onContinue;

  const RegisterSuccessDialog({
    super.key,
    required this.userName,
    this.userRole = 'pelamar',
    this.onContinue,
  });

  @override
  State<RegisterSuccessDialog> createState() => _RegisterSuccessDialogState();
}

class _RegisterSuccessDialogState extends State<RegisterSuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _dialogCtrl;
  late AnimationController _iconCtrl;
  late AnimationController _confettiCtrl;
  late AnimationController _textCtrl;

  late Animation<double> _dialogScale;
  late Animation<double> _dialogFade;
  late Animation<double> _iconScale;
  late Animation<double> _checkOpacity;
  late Animation<double> _ripple1;
  late Animation<double> _ripple2;
  late Animation<double> _textSlide;
  late Animation<double> _textFade;
  late Animation<double> _buttonSlide;

  final List<_ConfettiParticle> _particles = [];
  final math.Random _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _generateParticles();

    _dialogCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _dialogScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _dialogCtrl, curve: Curves.easeOutBack),
    );
    _dialogFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dialogCtrl, curve: const Interval(0.0, 0.55, curve: Curves.easeOut)),
    );

    _iconCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _iconScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.88), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.06), weight: 18),
      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 12),
    ]).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut));

    _checkOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: const Interval(0.35, 0.75, curve: Curves.easeIn)),
    );
    _ripple1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: const Interval(0.45, 1.0, curve: Curves.easeOut)),
    );
    _ripple2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: const Interval(0.6, 1.0, curve: Curves.easeOut)),
    );

    _confettiCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _textSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: const Interval(0.0, 0.7, curve: Curves.easeOut)),
    );
    _buttonSlide = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)),
    );

    _dialogCtrl.forward().then((_) {
      if (!mounted) return;
      _iconCtrl.forward().then((_) {
        if (!mounted) return;
        _confettiCtrl.forward();
      });
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) _textCtrl.forward();
      });
    });
  }

  void _generateParticles() {
    const colors = [
      Color(0xFFFF6B00), Color(0xFFFF8B3D), Color(0xFF10B981),
      Color(0xFF3B82F6), Color(0xFFF59E0B), Color(0xFF8B5CF6), Color(0xFFEC4899),
    ];
    for (int i = 0; i < 22; i++) {
      _particles.add(_ConfettiParticle(
        color: colors[_rng.nextInt(colors.length)],
        x: _rng.nextDouble(),
        startY: _rng.nextDouble() * 0.3,
        size: 5.0 + _rng.nextDouble() * 6.0,
        speed: 0.5 + _rng.nextDouble() * 0.7,
        angle: _rng.nextDouble() * math.pi * 2,
        rotSpeed: (_rng.nextDouble() - 0.5) * 8.0,
        isCircle: _rng.nextBool(),
      ));
    }
  }

  @override
  void dispose() {
    _dialogCtrl.dispose();
    _iconCtrl.dispose();
    _confettiCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  String get _roleLabel {
    switch (widget.userRole) {
      case 'perusahaan': return 'Perusahaan';
      case 'kandidat': return 'Kandidat';
      default: return 'Pencari Kerja';
    }
  }

  IconData get _roleIcon {
    switch (widget.userRole) {
      case 'perusahaan': return Icons.business_rounded;
      case 'kandidat': return Icons.star_rounded;
      default: return Icons.work_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 0,
      child: FadeTransition(
        opacity: _dialogFade,
        child: ScaleTransition(
          scale: _dialogScale,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(color: const Color(0xFFFF6B00).withValues(alpha: 0.12), blurRadius: 40, offset: const Offset(0, 16)),
                const BoxShadow(color: Color(0x18000000), blurRadius: 24, offset: Offset(0, 8)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Gradient header
                  Positioned(
                    top: 0, left: 0, right: 0, height: 155,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFF6B00), Color(0xFFFF8B3D), Color(0xFFFFAA6E)],
                        ),
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(top: -30, right: -30,
                    child: Container(width: 110, height: 110,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.1)))),
                  Positioned(top: 30, left: -20,
                    child: Container(width: 70, height: 70,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.08)))),
                  // Confetti
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _confettiCtrl,
                      builder: (_, _) => CustomPaint(
                        painter: _ConfettiPainter(particles: _particles, progress: _confettiCtrl.value),
                      ),
                    ),
                  ),
                  // Main content
                  Padding(
                    padding: const EdgeInsets.only(left: 28, right: 28, top: 36, bottom: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated icon
                        AnimatedBuilder(
                          animation: _iconCtrl,
                          builder: (_, _) => SizedBox(
                            width: 100, height: 100,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_ripple2.value > 0)
                                  Opacity(
                                    opacity: (1.0 - _ripple2.value).clamp(0, 1),
                                    child: Transform.scale(
                                      scale: 0.65 + _ripple2.value * 0.7,
                                      child: Container(width: 100, height: 100,
                                        decoration: BoxDecoration(shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2))),
                                    ),
                                  ),
                                if (_ripple1.value > 0)
                                  Opacity(
                                    opacity: (1.0 - _ripple1.value).clamp(0, 1),
                                    child: Transform.scale(
                                      scale: 0.72 + _ripple1.value * 0.45,
                                      child: Container(width: 100, height: 100,
                                        decoration: BoxDecoration(shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2))),
                                    ),
                                  ),
                                Transform.scale(
                                  scale: _iconScale.value,
                                  child: Container(
                                    width: 72, height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 6))],
                                    ),
                                    child: Opacity(
                                      opacity: _checkOpacity.value,
                                      child: const Icon(Icons.check_circle_rounded, color: Color(0xFFFF6B00), size: 46),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Text content
                        AnimatedBuilder(
                          animation: _textCtrl,
                          builder: (_, _) => Transform.translate(
                            offset: Offset(0, _textSlide.value),
                            child: Opacity(
                              opacity: _textFade.value,
                              child: Column(
                                children: [
                                  const Text(
                                    'Selamat Bergabung! 🎉',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: -0.3),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(fontSize: 14.5, color: Color(0xFF64748B), height: 1.55),
                                      children: [
                                        const TextSpan(text: 'Hei, '),
                                        TextSpan(text: widget.userName, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                        const TextSpan(text: '!\nAkun Anda telah berhasil dibuat.'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  // Role badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3EB),
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: const Color(0xFFFF6B00).withValues(alpha: 0.25)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(_roleIcon, size: 15, color: const Color(0xFFFF6B00)),
                                        const SizedBox(width: 6),
                                        Text(_roleLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFFF6B00))),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  // CTA Button
                                  Transform.translate(
                                    offset: Offset(0, _buttonSlide.value),
                                    child: _AuthSuccessButton(
                                      label: 'Mulai Jelajahi AreaKerja',
                                      icon: Icons.arrow_forward_rounded,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        widget.onContinue?.call();
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  GestureDetector(
                                    onTap: () { Navigator.of(context).pop(); widget.onContinue?.call(); },
                                    child: const Text('Atau tap di sini untuk melanjutkan',
                                      style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// RESET PASSWORD SUCCESS DIALOG

class ResetPasswordSuccessDialog extends StatefulWidget {
  final VoidCallback? onBackToLogin;

  const ResetPasswordSuccessDialog({super.key, this.onBackToLogin});

  @override
  State<ResetPasswordSuccessDialog> createState() => _ResetPasswordSuccessDialogState();
}

class _ResetPasswordSuccessDialogState extends State<ResetPasswordSuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _dialogCtrl;
  late AnimationController _iconCtrl;
  late AnimationController _shieldCtrl;
  late AnimationController _textCtrl;
  late AnimationController _sparkleCtrl;

  late Animation<double> _dialogScale;
  late Animation<double> _dialogFade;
  late Animation<double> _iconBounce;
  late Animation<double> _shieldRotate;
  late Animation<double> _shieldScale;
  late Animation<double> _unlockOpacity;
  late Animation<double> _glowPulse;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late Animation<double> _sparkle;

  @override
  void initState() {
    super.initState();

    _dialogCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _dialogScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(parent: _dialogCtrl, curve: Curves.easeOutBack));
    _dialogFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dialogCtrl, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));

    _iconCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 850));
    _iconBounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.85), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.08), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOut));
    _unlockOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: const Interval(0.4, 0.8, curve: Curves.easeIn)));

    _shieldCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _shieldRotate = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.08), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -0.08, end: 0.08), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: -0.04), weight: 25),
      TweenSequenceItem(tween: Tween(begin: -0.04, end: 0.0), weight: 15),
    ]).animate(CurvedAnimation(parent: _shieldCtrl, curve: Curves.easeInOut));
    _shieldScale = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _shieldCtrl, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)));

    _sparkleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _glowPulse = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleCtrl, curve: Curves.easeInOut));
    _sparkle = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleCtrl, curve: Curves.easeInOut));

    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 480));
    _textSlide = Tween<double>(begin: 22.0, end: 0.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: const Interval(0.0, 0.65, curve: Curves.easeOut)));

    _dialogCtrl.forward().then((_) {
      if (!mounted) return;
      _iconCtrl.forward().then((_) {
        if (!mounted) return;
        _shieldCtrl.forward();
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _textCtrl.forward();
      });
    });
  }

  @override
  void dispose() {
    _dialogCtrl.dispose();
    _iconCtrl.dispose();
    _shieldCtrl.dispose();
    _textCtrl.dispose();
    _sparkleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 0,
      child: FadeTransition(
        opacity: _dialogFade,
        child: ScaleTransition(
          scale: _dialogScale,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.14), blurRadius: 40, offset: const Offset(0, 16)),
                const BoxShadow(color: Color(0x16000000), blurRadius: 20, offset: Offset(0, 8)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Gradient header - teal/green
                  Positioned(
                    top: 0, left: 0, right: 0, height: 160,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF0D9488), Color(0xFF10B981), Color(0xFF34D399)],
                        ),
                      ),
                    ),
                  ),
                  Positioned(top: -25, right: -25,
                    child: Container(width: 100, height: 100,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.1)))),
                  Positioned(top: 60, left: -35,
                    child: Container(width: 80, height: 80,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.07)))),
                  // Content
                  Padding(
                    padding: const EdgeInsets.only(left: 28, right: 28, top: 36, bottom: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBuilder(
                          animation: Listenable.merge([_iconCtrl, _shieldCtrl, _sparkleCtrl]),
                          builder: (_, _) => SizedBox(
                            width: 110, height: 110,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Glow pulse ring
                                Opacity(
                                  opacity: _glowPulse.value * 0.45,
                                  child: Container(
                                    width: 102 + _glowPulse.value * 6,
                                    height: 102 + _glowPulse.value * 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: const Color(0xFF10B981), width: 2.5),
                                    ),
                                  ),
                                ),
                                // Lock icon with wiggle
                                Transform.scale(
                                  scale: _iconBounce.value * (_shieldCtrl.isAnimating ? _shieldScale.value : 1.0),
                                  child: Transform.rotate(
                                    angle: _shieldRotate.value,
                                    child: Container(
                                      width: 76, height: 76,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 18, offset: const Offset(0, 6))],
                                      ),
                                      child: Opacity(
                                        opacity: _unlockOpacity.value,
                                        child: const Icon(Icons.lock_open_rounded, color: Color(0xFF10B981), size: 42),
                                      ),
                                    ),
                                  ),
                                ),
                                ..._buildSparkles(_sparkle.value),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        AnimatedBuilder(
                          animation: _textCtrl,
                          builder: (_, _) => Transform.translate(
                            offset: Offset(0, _textSlide.value),
                            child: Opacity(
                              opacity: _textFade.value,
                              child: Column(
                                children: [
                                  const Text(
                                    'Password Berhasil Diubah! 🔐',
                                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: -0.3),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Kata sandi Anda telah berhasil diperbarui.\nSekarang Anda bisa masuk dengan kata sandi baru.',
                                    style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.55),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  // Security tip chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF0FDF4),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.shield_rounded, size: 16, color: Color(0xFF10B981)),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text('Jaga kerahasiaan kata sandi Anda',
                                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF065F46))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  _AuthSuccessButton(
                                    label: 'Kembali ke Halaman Masuk',
                                    icon: Icons.login_rounded,
                                    gradientColors: const [Color(0xFF0D9488), Color(0xFF10B981)],
                                    shadowColor: const Color(0xFF10B981),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      widget.onBackToLogin?.call();
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  GestureDetector(
                                    onTap: () { Navigator.of(context).pop(); widget.onBackToLogin?.call(); },
                                    child: const Text('Atau tap di sini untuk melanjutkan',
                                      style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSparkles(double t) {
    const sparkleAngles = [0.0, math.pi / 2, math.pi, 3 * math.pi / 2];
    const sparkleColor = Color(0xFF10B981);
    return sparkleAngles.map((angle) {
      final dx = math.cos(angle) * 52.0;
      final dy = math.sin(angle) * 52.0;
      return Positioned(
        left: 55 + dx - 5, top: 55 + dy - 5,
        child: Opacity(
          opacity: t * 0.7,
          child: const Icon(Icons.star_rounded, size: 10, color: sparkleColor),
        ),
      );
    }).toList();
  }
}

// SHARED ANIMATED BUTTON

class _AuthSuccessButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final Color shadowColor;
  final VoidCallback onPressed;

  const _AuthSuccessButton({
    required this.label,
    required this.icon,
    this.gradientColors = const [Color(0xFFFF6B00), Color(0xFFFF8B3D)],
    this.shadowColor = const Color(0xFFFF6B00),
    required this.onPressed,
  });

  @override
  State<_AuthSuccessButton> createState() => _AuthSuccessButtonState();
}

class _AuthSuccessButtonState extends State<_AuthSuccessButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 260),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onPressed(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor.withValues(alpha: 0.38),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// CONFETTI PAINTER

class _ConfettiParticle {
  final Color color;
  final double x;
  final double startY;
  final double size;
  final double speed;
  final double angle;
  final double rotSpeed;
  final bool isCircle;

  const _ConfettiParticle({
    required this.color, required this.x, required this.startY,
    required this.size, required this.speed, required this.angle,
    required this.rotSpeed, required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  const _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    final paint = Paint();
    for (final p in particles) {
      final t = (progress * p.speed).clamp(0.0, 1.0);
      if (t == 0) continue;
      final opacity = (1.0 - t * 0.85).clamp(0.0, 1.0);
      final px = p.x * size.width + math.sin(p.angle + t * 4) * 18;
      final py = p.startY * size.height * 0.6 + t * size.height * 0.7;
      paint.color = p.color.withValues(alpha: opacity);
      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotSpeed * t * math.pi);
      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.55),
            const Radius.circular(1.5),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

// HELPER CLASS

/// Helper untuk menampilkan popup auth success dengan mudah
class AuthSuccessDialogHelper {
  AuthSuccessDialogHelper._();

  /// Tampilkan popup registrasi berhasil
  static Future<void> showRegisterSuccess({
    required BuildContext context,
    required String userName,
    String userRole = 'pelamar',
    VoidCallback? onContinue,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Registrasi Berhasil',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, _, _) => RegisterSuccessDialog(
        userName: userName,
        userRole: userRole,
        onContinue: onContinue,
      ),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(opacity: anim, child: child),
    );
  }

  /// Tampilkan popup reset password berhasil
  static Future<void> showResetPasswordSuccess({
    required BuildContext context,
    VoidCallback? onBackToLogin,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Reset Password Berhasil',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, _, _) => ResetPasswordSuccessDialog(onBackToLogin: onBackToLogin),
      transitionBuilder: (ctx, anim, _, child) => FadeTransition(opacity: anim, child: child),
    );
  }
}
