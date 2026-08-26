import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Painter presisi HD untuk ikon pita 3D "AK" AreaKerja (sebagai vector / fallback)
class AreaKerjaMarkPainter extends CustomPainter {
  final double shadowOpacity;

  AreaKerjaMarkPainter({this.shadowOpacity = 0.25});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 120.0;
    canvas.save();
    canvas.scale(scale, scale);

    final shadowPaint = Paint()
      ..color = const Color(0xFFBF360C).withValues(alpha: shadowOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    // --- 1. A - Bagian Bawah / Lengkungan Belakang Penghubung ---
    final pathABottom = Path()
      ..moveTo(24, 66)
      ..cubicTo(20, 82, 38, 98, 62, 86)
      ..cubicTo(74, 80, 80, 84, 82, 90)
      ..cubicTo(84, 98, 76, 106, 58, 106)
      ..cubicTo(32, 106, 10, 86, 22, 58)
      ..close();

    final gradABottom = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Color(0xFFD84315), Color(0xFFFF5722), Color(0xFFFF9800)],
    ).createShader(const Rect.fromLTWH(10, 55, 75, 55));

    canvas.drawPath(pathABottom.shift(const Offset(0, 3)), shadowPaint);
    canvas.drawPath(pathABottom, Paint()..shader = gradABottom);

    // --- 2. A - Lengkungan Utama Depan ---
    final pathAMain = Path()
      ..moveTo(22, 66)
      ..cubicTo(14, 48, 28, 20, 50, 20)
      ..cubicTo(68, 20, 78, 42, 64, 70)
      ..cubicTo(52, 94, 30, 86, 22, 66)
      ..close();

    final gradAMain = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFB74D), Color(0xFFFF6D00), Color(0xFFE64A19)],
    ).createShader(const Rect.fromLTWH(10, 18, 70, 78));

    canvas.drawPath(pathAMain.shift(const Offset(0, 3)), shadowPaint);
    canvas.drawPath(pathAMain, Paint()..shader = gradAMain);

    // Lubang Dalam Huruf A (Putih Bersih)
    final pathACutout = Path()
      ..moveTo(37, 58)
      ..cubicTo(32, 48, 38, 34, 48, 34)
      ..cubicTo(56, 34, 60, 46, 52, 60)
      ..cubicTo(45, 70, 41, 66, 37, 58)
      ..close();

    canvas.drawPath(pathACutout, Paint()..color = Colors.white);

    // --- 3. K - Sayap Pita Atas ---
    final pathKTop = Path()
      ..moveTo(64, 56)
      ..cubicTo(74, 44, 90, 24, 108, 24)
      ..cubicTo(122, 24, 128, 36, 120, 48)
      ..cubicTo(108, 62, 86, 66, 72, 64)
      ..close();

    final gradKTop = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Color(0xFFE64A19), Color(0xFFFF6D00), Color(0xFFFFB74D)],
    ).createShader(const Rect.fromLTWH(60, 22, 70, 44));

    canvas.drawPath(pathKTop.shift(const Offset(0, 3)), shadowPaint);
    canvas.drawPath(pathKTop, Paint()..shader = gradKTop);

    // --- 4. K - Sayap Pita Bawah ---
    final pathKBottom = Path()
      ..moveTo(70, 64)
      ..cubicTo(84, 66, 112, 66, 124, 82)
      ..cubicTo(132, 92, 124, 106, 110, 106)
      ..cubicTo(92, 106, 76, 86, 68, 72)
      ..close();

    final gradKBottom = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE64A19), Color(0xFFFF5722), Color(0xFFBF360C)],
    ).createShader(const Rect.fromLTWH(65, 62, 70, 46));

    canvas.drawPath(pathKBottom.shift(const Offset(0, 3)), shadowPaint);
    canvas.drawPath(pathKBottom, Paint()..shader = gradKBottom);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget Ikon Logo AK (Mendukung file gambar asset & vector fallback)
class AreaKerjaIconWidget extends StatelessWidget {
  final double size;

  const AreaKerjaIconWidget({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/AK_logo.png',
      width: size,
      height: size * (100 / 120),
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (ctx, err, stack) {
        // Coba nama file alternatif
        return Image.asset(
          'assets/images/AK.png',
          width: size,
          height: size * (100 / 120),
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            // Fallback ke vector canvas jika file asset tidak ditemukan
            return SizedBox(
              width: size,
              height: size * (100 / 120),
              child: CustomPaint(
                painter: AreaKerjaMarkPainter(),
              ),
            );
          },
        );
      },
    );
  }
}

/// Teks Brand Resmi (AREAKERJA .com)
class AreaKerjaBrandTextWidget extends StatelessWidget {
  final double fontSize;

  const AreaKerjaBrandTextWidget({
    super.key,
    this.fontSize = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'AREAKERJA',
          style: GoogleFonts.fredoka(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFFF5722),
            letterSpacing: 0.8,
            height: 1.0,
          ),
        ),
        const SizedBox(width: 2),
        Padding(
          padding: EdgeInsets.only(bottom: fontSize * 0.08),
          child: Text(
            '.com',
            style: GoogleFonts.fredoka(
              fontSize: fontSize * 0.44,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFF5722),
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}

/// Logo Lengkap (Ikon AK + Teks AREAKERJA.com)
class AreaKerjaLogoFullWidget extends StatelessWidget {
  final double markSize;
  final double fontSize;
  final double spacing;

  const AreaKerjaLogoFullWidget({
    super.key,
    this.markSize = 62,
    this.fontSize = 26,
    this.spacing = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AreaKerjaIconWidget(size: markSize),
        SizedBox(width: spacing),
        AreaKerjaBrandTextWidget(fontSize: fontSize),
      ],
    );
  }
}
