import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class QuickActionGrid extends StatelessWidget {
  final VoidCallback? onBuatLowongan;
  final VoidCallback? onBeliKoin;
  final VoidCallback? onLihatPelamar;
  final VoidCallback? onLowonganSaya;

  const QuickActionGrid({
    super.key,
    this.onBuatLowongan,
    this.onBeliKoin,
    this.onLihatPelamar,
    this.onLowonganSaya,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _ActionButton(
                icon: Icons.add_circle_outline_rounded,
                label: 'Buat\nLowongan',
                color: AppColors.primary,
                bg: AppColors.primarySurface,
                onTap: onBuatLowongan,
              ),
              const SizedBox(height: 10),
              _ActionButton(
                icon: Icons.monetization_on_outlined,
                label: 'Beli\nKoin',
                color: const Color(0xFFD97706),
                bg: const Color(0xFFFEF3C7),
                onTap: onBeliKoin,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              _ActionButton(
                icon: Icons.people_outline_rounded,
                label: 'Lihat\nPelamar',
                color: AppColors.accent,
                bg: AppColors.accentLight,
                onTap: onLihatPelamar,
              ),
              const SizedBox(height: 10),
              _ActionButton(
                icon: Icons.work_outline_rounded,
                label: 'Lowongan\nSaya',
                color: AppColors.teal,
                bg: AppColors.tealLight,
                onTap: onLowonganSaya,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 250),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
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
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x060F172A),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
