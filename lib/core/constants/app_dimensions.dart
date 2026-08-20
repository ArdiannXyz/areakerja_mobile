import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Spacing & Padding
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 12.0;
  static const double spaceL = 16.0;
  static const double spaceXL = 20.0;
  static const double space2XL = 24.0;
  static const double space3XL = 32.0;
  static const double space4XL = 40.0;
  static const double space5XL = 48.0;

  // Screen Padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 24.0,
  );

  static const EdgeInsets horizontalScreenPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );

  // Border Radius
  static const double radiusS = 6.0;
  static const double radiusM = 10.0;
  static const double radiusL = 14.0;
  static const double radiusXL = 20.0;
  static const double radiusFull = 999.0;

  static final BorderRadius borderRadiusS = BorderRadius.circular(radiusS);
  static final BorderRadius borderRadiusM = BorderRadius.circular(radiusM);
  static final BorderRadius borderRadiusL = BorderRadius.circular(radiusL);
  static final BorderRadius borderRadiusXL = BorderRadius.circular(radiusXL);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // Button Heights
  static const double buttonHeight = 52.0;
  static const double buttonHeightSmall = 40.0;

  // Input Field
  static const double inputHeight = 52.0;

  // Icons
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Elevation / Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x050F172A),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> primaryButtonShadow = [
    BoxShadow(
      color: Color(0x33FF6B00),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}
