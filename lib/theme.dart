import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFFF6F1E4);
  static const bgSoft = Color(0xFFEFE7D2);
  static const ink = Color(0xFF1F2933);
  static const inkSoft = Color(0xFF5C6773);
  static const accent = Color(0xFF3F6FB5);
  static const accent2 = Color(0xFFC8553D);
  static const accent3 = Color(0xFF88A878);
  static const success = Color(0xFF5B8C5A);
  static const diacritic = Color(0xFFC8332B);
  static const cardBg = Color(0xFFFFFCF3);
  static const guideInk = Color(0x331F2933);
  static const paperLine = Color(0x2E3F6FB5);
  static const starGold = Color(0xFFFFC93C);
  static const starGoldEdge = Color(0xFFE8A21A);
  static const cheekPink = Color(0xFFFF9CA8);
  static const mascotCream = Color(0xFFFFF7E6);
}

const cardShadow = [
  BoxShadow(
    color: Color(0x141F2933),
    offset: Offset(0, 4),
    blurRadius: 0,
  ),
  BoxShadow(
    color: Color(0x121F2933),
    offset: Offset(0, 10),
    blurRadius: 22,
  ),
];

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
      surface: AppColors.bg,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.ink),
      bodyMedium: TextStyle(color: AppColors.ink),
    ),
  );
}
