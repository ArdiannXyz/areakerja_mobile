import 'dart:async';
import 'package:flutter/material.dart';

/// Popup dialog untuk konfirmasi pengiriman CV / lamaran kerja
class LamarConfirmationDialog extends StatefulWidget {
  final String namaPerusahaan;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const LamarConfirmationDialog({
    super.key,
    required this.namaPerusahaan,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  State<LamarConfirmationDialog> createState() =>
      _LamarConfirmationDialogState();
}

class _LamarConfirmationDialogState extends State<LamarConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      elevation: 0,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2A000000),
                    blurRadius: 30,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon header
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5E14).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Color(0xFFFF5E14),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kirim Lamaran?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF334155),
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'CV anda akan dikirimkan ke\n'),
                        TextSpan(
                          text: widget.namaPerusahaan
                                      .startsWith('(') &&
                                  widget.namaPerusahaan.endsWith(')')
                              ? '${widget.namaPerusahaan}?'
                              : '(${widget.namaPerusahaan})?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: _DialogButton(
                          label: 'Ya, Kirim',
                          backgroundColor: const Color(0xFFFF5E14),
                          textColor: Colors.white,
                          icon: Icons.check_rounded,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            widget.onConfirm();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DialogButton(
                          label: 'Batal',
                          backgroundColor: Colors.white,
                          textColor: const Color(0xFFFF5E14),
                          borderColor: const Color(0xFFFF5E14),
                          icon: Icons.close_rounded,
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            widget.onCancel?.call();
                          },
                        ),
                      ),
                    ],
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

/// Animated dialog button with press effect
class _DialogButton extends StatefulWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final IconData icon;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 250),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 1.5)
                : null,
            boxShadow: widget.borderColor == null
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF5E14).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.textColor, size: 16),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Popup dialog ketika lamaran berhasil terkirim (dengan animasi bounce icon)
class LamarSuccessDialog extends StatefulWidget {
  final String message;
  final VoidCallback? onDismiss;
  final Duration? autoDismissDuration;

  const LamarSuccessDialog({
    super.key,
    this.message = 'Lamaran anda telah dikirim',
    this.onDismiss,
    this.autoDismissDuration = const Duration(seconds: 3),
  });

  @override
  State<LamarSuccessDialog> createState() => _LamarSuccessDialogState();
}

class _LamarSuccessDialogState extends State<LamarSuccessDialog>
    with TickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _dialogController;
  late AnimationController _iconController;
  late Animation<double> _dialogScaleAnim;
  late Animation<double> _dialogFadeAnim;
  late Animation<double> _iconScaleAnim;
  late Animation<double> _checkOpacityAnim;
  late Animation<double> _rippleAnim;

  @override
  void initState() {
    super.initState();

    // Dialog entrance animation
    _dialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _dialogScaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _dialogController, curve: Curves.easeOutBack),
    );

    _dialogFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _dialogController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    // Icon bounce animation
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _iconScaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.25), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.9), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 10),
    ]).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOut),
    );

    _checkOpacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _iconController,
          curve: const Interval(0.3, 0.7, curve: Curves.easeIn)),
    );

    _rippleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _iconController,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );

    // Sequence: dialog enter first, then icon bounces
    _dialogController.forward().then((_) {
      if (mounted) _iconController.forward();
    });

    // Auto-dismiss
    if (widget.autoDismissDuration != null) {
      _timer = Timer(widget.autoDismissDuration!, () {
        if (mounted) {
          Navigator.of(context).pop();
          widget.onDismiss?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dialogController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      elevation: 0,
      child: GestureDetector(
        onTap: () {
          _timer?.cancel();
          Navigator.of(context).pop();
          widget.onDismiss?.call();
        },
        child: FadeTransition(
          opacity: _dialogFadeAnim,
          child: ScaleTransition(
            scale: _dialogScaleAnim,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2A000000),
                    blurRadius: 30,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated success icon with ripple
                  AnimatedBuilder(
                    animation: _iconController,
                    builder: (context, _) {
                      return SizedBox(
                        width: 96,
                        height: 96,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Ripple ring
                            if (_rippleAnim.value > 0)
                              Transform.scale(
                                scale: 0.7 + (_rippleAnim.value * 0.6),
                                child: Opacity(
                                  opacity: (1.0 - _rippleAnim.value).clamp(
                                      0.0, 1.0),
                                  child: Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFFF5E14),
                                        width: 2.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            // Main circle + check
                            Transform.scale(
                              scale: _iconScaleAnim.value,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFFF7A3D),
                                      Color(0xFFFF5E14),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x40FF5E14),
                                      blurRadius: 20,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Opacity(
                                  opacity: _checkOpacityAnim.value,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Berhasil! 🎉',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap di mana saja untuk menutup',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                    textAlign: TextAlign.center,
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

/// Helper functions untuk menampilkan dialog
class LamarDialogHelper {
  LamarDialogHelper._();

  /// Menampilkan popup konfirmasi lamar dengan animasi custom
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String namaPerusahaan,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) => LamarConfirmationDialog(
        namaPerusahaan: namaPerusahaan,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  /// Menampilkan popup berhasil lamar dengan animasi custom
  static Future<void> showSuccessDialog({
    required BuildContext context,
    String message = 'Lamaran anda telah dikirim',
    VoidCallback? onDismiss,
    Duration? autoDismissDuration = const Duration(seconds: 3),
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) => LamarSuccessDialog(
        message: message,
        onDismiss: onDismiss,
        autoDismissDuration: autoDismissDuration,
      ),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }
}
