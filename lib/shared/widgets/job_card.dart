import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/date_formatter.dart';
import '../../features/lowongan/data/models/lowongan_model.dart';

class JobCard extends StatefulWidget {
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
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 250),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
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
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap?.call();
              },
              borderRadius: AppDimensions.borderRadiusL,
              splashColor: AppColors.primary.withValues(alpha: 0.05),
              highlightColor: AppColors.primarySurface.withValues(alpha: 0.5),
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
                              widget.lowongan.namaPerusahaan.isNotEmpty
                                  ? widget.lowongan.namaPerusahaan[0]
                                      .toUpperCase()
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
                                widget.lowongan.judul,
                                style: AppTextStyles.heading3
                                    .copyWith(fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.lowongan.namaPerusahaan,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.onBookmarkTap != null)
                          _AnimatedBookmarkButton(
                            isFavorit: widget.lowongan.isFavorit,
                            onPressed: widget.onBookmarkTap!,
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
                          text: widget.lowongan.tipePekerjaan,
                          bgColor: AppColors.infoLight,
                          textColor: AppColors.accent,
                        ),
                        _BadgeChip(
                          icon: Icons.location_on_outlined,
                          text: widget.lowongan.lokasi,
                          bgColor: AppColors.inputBackground,
                          textColor: AppColors.textSecondary,
                        ),
                        _BadgeChip(
                          icon: Icons.category_outlined,
                          text: widget.lowongan.kategori,
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
                          widget.lowongan.rentangGaji,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          DateFormatter.timeAgo(widget.lowongan.createdAt),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated bookmark button with scale bounce
class _AnimatedBookmarkButton extends StatefulWidget {
  final bool isFavorit;
  final VoidCallback onPressed;

  const _AnimatedBookmarkButton({
    required this.isFavorit,
    required this.onPressed,
  });

  @override
  State<_AnimatedBookmarkButton> createState() =>
      _AnimatedBookmarkButtonState();
}

class _AnimatedBookmarkButtonState extends State<_AnimatedBookmarkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.88), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _controller.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: Icon(
            widget.isFavorit
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            key: ValueKey(widget.isFavorit),
            color: widget.isFavorit ? AppColors.primary : AppColors.textMuted,
            size: 24,
          ),
        ),
        onPressed: _handleTap,
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
