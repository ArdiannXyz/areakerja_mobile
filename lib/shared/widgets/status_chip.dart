import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/role_constants.dart';

class RoleChip extends StatelessWidget {
  final UserRole role;

  const RoleChip({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (role) {
      case UserRole.perusahaan:
        bg = AppColors.primarySurface;
        text = AppColors.primaryDark;
        break;
      case UserRole.kandidat:
        bg = const Color(0xFFF3E8FF);
        text = AppColors.roleKandidat;
        break;
      case UserRole.admin:
        bg = AppColors.dangerLight;
        text = AppColors.danger;
        break;
      case UserRole.pelamar:
      default:
        bg = AppColors.infoLight;
        text = AppColors.accent;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role.displayName,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
