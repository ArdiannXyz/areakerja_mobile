import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/lowongan/data/models/lowongan_model.dart';

class JobCard extends StatelessWidget {
  final LowonganModel lowongan;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  const JobCard({
    super.key,
    required this.lowongan,
    this.onTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppDimensions.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppDimensions.borderRadiusL,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDimensions.borderRadiusL,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Company logo, name, bookmark
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Center(
                        child: Text(
                          lowongan.namaPerusahaan.isNotEmpty
                              ? lowongan.namaPerusahaan[0].toUpperCase()
                              : 'A',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lowongan.judul,
                            style: AppTextStyles.heading3.copyWith(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lowongan.namaPerusahaan,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onBookmarkTap != null)
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          lowongan.isFavorit ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                          color: lowongan.isFavorit ? AppColors.primary : AppColors.textMuted,
                          size: 24,
                        ),
                        onPressed: onBookmarkTap,
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceM),

                // Tags: Tipe Pekerjaan & Lokasi
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _BadgeChip(
                      icon: Icons.work_outline_rounded,
                      text: lowongan.tipePekerjaan,
                      bgColor: AppColors.infoLight,
                      textColor: AppColors.accent,
                    ),
                    _BadgeChip(
                      icon: Icons.location_on_outlined,
                      text: lowongan.lokasi,
                      bgColor: AppColors.inputBackground,
                      textColor: AppColors.textSecondary,
                    ),
                    _BadgeChip(
                      icon: Icons.category_outlined,
                      text: lowongan.kategori,
                      bgColor: AppColors.primarySurface,
                      textColor: AppColors.primaryDark,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceM),
                const Divider(height: 1),
                const SizedBox(height: AppDimensions.spaceM),

                // Bottom Row: Salary & Posted date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lowongan.rentangGaji,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      DateFormatter.timeAgo(lowongan.createdAt),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color bgColor;
  final Color textColor;

  const _BadgeChip({
    required this.icon,
    required this.text,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
