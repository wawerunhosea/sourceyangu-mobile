import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/colors.dart';
import 'package:sourceyangu/app/common/constants/sizes.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: headlineLargeSize,
      fontWeight: FontWeight.bold,
      color: blackMain,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: headlineMediumSize,
      fontWeight: FontWeight.w600,
      color: blackMain,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: headlineSmallSize,
      fontWeight: FontWeight.w600,
      color: blackMain,
    ),

    titleLarge: const TextStyle().copyWith(
      fontSize: titleLargeSize,
      fontWeight: FontWeight.w800,
      color: blackMain,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: titleMediumSize,
      fontWeight: FontWeight.w500,
      color: darkThemeGreydark,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: titleSmallSize,
      fontWeight: FontWeight.w400,
      color: blackMain,
    ),

    bodyLarge: const TextStyle().copyWith(
      fontSize: bodyLargeSize,
      fontWeight: FontWeight.w500,
      color: blackMain,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: bodyMediumSize,
      fontWeight: FontWeight.normal,
      color: blackMain,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: bodySmallSize,
      fontWeight: FontWeight.w500,
      color: blackMain.withAlpha(127),
    ),

    labelLarge: const TextStyle().copyWith(
      fontSize: labelLargeSize,
      fontWeight: FontWeight.normal,
      color: blackMain,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: labelMediumSize,
      fontWeight: FontWeight.normal,
      color: blackMain.withAlpha(127),
    ),
  );

  // Dark mode
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: headlineLargeSize,
      fontWeight: FontWeight.bold,
      color: whiteMain,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: headlineMediumSize,
      fontWeight: FontWeight.w600,
      color: whiteMain,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: headlineSmallSize,
      fontWeight: FontWeight.w600,
      color: whiteMain,
    ),

    titleLarge: const TextStyle().copyWith(
      fontSize: titleLargeSize,
      fontWeight: FontWeight.w600,
      color: whiteMain,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: titleMediumSize,
      fontWeight: FontWeight.w500,
      color: whiteMain,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: titleSmallSize,
      fontWeight: FontWeight.w400,
      color: whiteMain,
    ),

    bodyLarge: const TextStyle().copyWith(
      fontSize: bodyLargeSize,
      fontWeight: FontWeight.w500,
      color: whiteMain,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: bodyMediumSize,
      fontWeight: FontWeight.normal,
      color: whiteMain,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: bodySmallSize,
      fontWeight: FontWeight.w500,
      color: whiteMain.withAlpha(150),
    ),

    labelLarge: const TextStyle().copyWith(
      fontSize: labelLargeSize,
      fontWeight: FontWeight.normal,
      color: whiteMain,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: labelMediumSize,
      fontWeight: FontWeight.normal,
      color: whiteMain.withAlpha(157),
    ),
  );

  /// ✅ **Getter functions that dynamically return the latest theme styles**
  static TextStyle? get headlineLarge => Get.theme.textTheme.headlineLarge;
  static TextStyle? get headlineMedium => Get.theme.textTheme.headlineMedium;
  static TextStyle? get headlineSmall => Get.theme.textTheme.headlineSmall;

  static TextStyle? get titleLarge => Get.theme.textTheme.titleLarge;
  static TextStyle? get titleMedium => Get.theme.textTheme.titleMedium;
  static TextStyle? get titleSmall => Get.theme.textTheme.titleSmall;

  static TextStyle? get bodyLarge => Get.theme.textTheme.bodyLarge;
  static TextStyle? get bodyMedium => Get.theme.textTheme.bodyMedium;
  static TextStyle? get bodySmall => Get.theme.textTheme.bodySmall;

  static TextStyle? get labelLarge => Get.theme.textTheme.labelLarge;
  static TextStyle? get labelMedium => Get.theme.textTheme.labelMedium;
}
