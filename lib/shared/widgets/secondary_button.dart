import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height,
    this.borderColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? AppDimensions.buttonHeight;
    final effectiveRadius = borderRadius ?? AppDimensions.borderRadiusM;
    final effectiveColor = textColor ?? AppColors.primary;
    final effectiveBorder = borderColor ?? AppColors.primary;

    final button = SizedBox(
      height: effectiveHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveColor,
          side: BorderSide(color: effectiveBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: effectiveRadius,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: AppDimensions.spaceS),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.buttonText.copyWith(
                      color: effectiveColor,
                    ),
                  ),
                ],
              ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
