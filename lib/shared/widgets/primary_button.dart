import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? AppDimensions.buttonHeight;
    final effectiveRadius = borderRadius ?? AppDimensions.borderRadiusM;

    final button = Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        gradient: onPressed == null || isLoading
            ? null
            : (backgroundColor == null ? AppColors.primaryGradient : null),
        color: onPressed == null || isLoading
            ? AppColors.border
            : (backgroundColor ?? AppColors.primary),
        borderRadius: effectiveRadius,
        boxShadow: onPressed != null && !isLoading && backgroundColor == null
            ? AppDimensions.primaryButtonShadow
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: effectiveRadius,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                          color: textColor ?? Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
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
