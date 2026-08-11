import 'package:flutter/material.dart';

class AppColor {
  static const Color primary = Color(0xFF4A154B);
  static const Color secondary = Color(0xFFE01E5A);
  static const Color first = Color(0xFF7A2B9F);
  static const Color second = Color(0xFF5A1F7C);
  static const Color tertiary = Color(0xFFF3E5F5);
  static const Color background = Color(0xFFF7F4FB);
  static const Color neutral = Color(0xFF1A1A1A);
  static const Color text = Color(0xFF111111);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color grey = Color(0xFFA1A1AA);
}

class AppGradient {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColor.primary, AppColor.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
