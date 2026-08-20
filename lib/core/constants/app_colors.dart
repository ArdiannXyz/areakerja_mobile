import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors (AreaKerja Orange)
  static const Color primary = Color(0xFFFF6B00);
  static const Color primaryDark = Color(0xFFE05300);
  static const Color primaryLight = Color(0xFFFF8B3D);
  static const Color primarySurface = Color(0xFFFFF3EB);

  // Secondary Brand Colors (Deep Navy / Slate)
  static const Color secondary = Color(0xFF1E293B);
  static const Color secondaryDark = Color(0xFF0F172A);
  static const Color secondaryLight = Color(0xFF334155);
  static const Color secondarySurface = Color(0xFFF1F5F9);

  // Accent Colors
  static const Color accent = Color(0xFF2563EB);
  static const Color accentLight = Color(0xFFDBEAFE);
  static const Color teal = Color(0xFF0D9488);
  static const Color tealLight = Color(0xFFCCFBF1);

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color scaffoldBackground = Color(0xFFF8FAFC);

  // Neutral & Slate Grays
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocused = Color(0xFFFF6B00);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color inputBackground = Color(0xFFF8FAFC);

  // Status & Feedback Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Role Badges
  static const Color rolePelamar = Color(0xFF2563EB);
  static const Color roleKandidat = Color(0xFF8B5CF6);
  static const Color rolePerusahaan = Color(0xFFFF6B00);
  static const Color roleAdmin = Color(0xFFDC2626);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B00), Color(0xFFFF8B3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
