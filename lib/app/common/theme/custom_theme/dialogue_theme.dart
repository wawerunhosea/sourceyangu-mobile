import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/theme/custom_theme/text_theme.dart';

class TPopupTheme {
  TPopupTheme._();

  static DialogTheme _baseTheme(Color backgroundColor) {
    return DialogTheme(
      backgroundColor: backgroundColor,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      titleTextStyle: TTextTheme.titleLarge,
      contentTextStyle: TTextTheme.bodyMedium,
    );
  }

  // Light Theme
  static final DialogTheme lightPopupTheme = _baseTheme(Colors.white);

  // Dark Theme
  static final DialogTheme darkPopupTheme = _baseTheme(Colors.grey[900]!);

  // Dynamic Theme Getter
  static DialogTheme get current =>
      Get.isDarkMode ? darkPopupTheme : lightPopupTheme;
}
