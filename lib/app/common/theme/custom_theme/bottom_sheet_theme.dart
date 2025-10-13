import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TBottomSheetTheme {
  TBottomSheetTheme._();

  //light theme
  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: Colors.white,
    modalBarrierColor: Colors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
  );

// dark theme
  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: Colors.black,
    modalBarrierColor: Colors.black,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
  );

      // Getter for current theme
      static BottomSheetThemeData get current =>
      Get.isDarkMode ? darkBottomSheetTheme : lightBottomSheetTheme;
}
