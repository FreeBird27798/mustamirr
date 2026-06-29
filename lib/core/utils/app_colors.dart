import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1E5AA8);
  static const glow = Color(0xFF3B8EE6);
  static const amber = Color(0xFFF5A524);
  static const dark = Color(0xFF0F172A);

  static const background = Colors.white;
  static const inputBackground = Color(0xFFF3F4F6);
  static const textGrey = Color(0xFF6B7280);
  static const borderGrey = Color(0xFFE5E7EB);

  static const gradient = LinearGradient(
    colors: [primary, glow],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
