import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xff17418a);

  // Create a MaterialColor from primaryColor
  static const MaterialColor primarySwatch = MaterialColor(
    0xff17418a, // 0xFF + your hex color
    <int, Color>{
      50: Color(0xffe6e9f2),
      100: Color(0xffc0cbe1),
      200: Color(0xff97aad0),
      300: Color(0xff6e88bf),
      400: Color(0xff4e6eb3),
      500: Color(0xff17418a), // same as primaryColor
      600: Color(0xff153978),
      700: Color(0xff123064),
      800: Color(0xff0f2650),
      900: Color(0xff0a1836),
    },
  );
}
