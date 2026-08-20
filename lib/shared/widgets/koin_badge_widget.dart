import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class KoinBadgeWidget extends StatelessWidget {
  final int jumlahKoin;
  final VoidCallback? onTap;
  final bool showAddButton;

  const KoinBadgeWidget({
    super.key,
    this.jumlahKoin = 100,
    this.onTap,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.monetization_on_rounded,
              color: Color(0xFFD97706),
              size: 18,
            ),
            const SizedBox(width: 5),
            Text(
              '$jumlahKoin',
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: 13,
                color: const Color(0xFFB45309),
                fontWeight: FontWeight.w700,
              ),
            ),
            if (showAddButton) ...[
              const SizedBox(width: 4),
              Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
