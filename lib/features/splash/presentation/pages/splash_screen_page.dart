import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/areakerja_logo.dart';

class SplashScreenPage extends StatefulWidget {
  final VoidCallback? onAnimationComplete;

  const SplashScreenPage({super.key, this.onAnimationComplete});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  late AnimationController _stage1Controller; // Entrance of AK mark (Splash 1)
  late AnimationController _stage2Controller; // Expand to full logo with text (Splash 2)

  late Animation<double> _markScale;
  late Animation<double> _markOpacity;

  late Animation<double> _textWidthFactor;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    // 1. Stage 1: Entrance of AK Mark (Splash Screen 1)
    _stage1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _markScale = Tween<double>(begin: 0.65, end: 1.0).animate(
      CurvedAnimation(
        parent: _stage1Controller,
        curve: Curves.easeOutBack,
      ),
    );

    _markOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _stage1Controller,
        curve: Curves.easeOut,
      ),
    );

    // 2. Stage 2: Reveal Brand Text (Transition to Splash Screen 2)
    _stage2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _textWidthFactor = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _stage2Controller,
        curve: Curves.easeInOutCubic,
      ),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _stage2Controller,
        curve: const Interval(0.15, 0.95, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<double>(begin: -16.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _stage2Controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // 1. Tampilkan Splash Screen 1 (AK Mark)
    await _stage1Controller.forward();

    // Tahan Splash Screen 1
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    // 2. Animasikan pemunculan teks AREAKERJA.com (Splash Screen 2)
    await _stage2Controller.forward();

    // Tahan Splash Screen 2
    await Future.delayed(const Duration(milliseconds: 1300));

    if (!mounted) return;

    // 3. Selesai dan lanjut
    if (widget.onAnimationComplete != null) {
      widget.onAnimationComplete!();
    }
  }

  @override
  void dispose() {
    _stage1Controller.dispose();
    _stage2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double markSize = 68.0;
    const double fontSize = 26.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_stage1Controller, _stage2Controller]),
          builder: (context, child) {
            return Opacity(
              opacity: _markOpacity.value,
              child: Transform.scale(
                scale: _markScale.value,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Ikon AK (Splash Screen 1) ---
                    const AreaKerjaIconWidget(size: markSize),

                    // --- Teks AREAKERJA.com yang melebar mulus (Splash Screen 2) ---
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _textWidthFactor.value,
                        child: Transform.translate(
                          offset: Offset(_textSlide.value, 0),
                          child: Opacity(
                            opacity: _textOpacity.value,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: AreaKerjaBrandTextWidget(
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
