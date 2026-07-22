import 'package:flutter/material.dart';
import 'app_colors.dart';

class FileTypeStyle {
  static Color colorFor(String fileType) {
    switch (fileType) {
      case 'pdf':
        return const Color(0xFF3B82F6);
      case 'video':
        return const Color(0xFF8B5CF6);
      case 'word':
        return const Color(0xFF10B981);
      case 'doc':
        return const Color(0xFFF97316);
      default:
        return AppColors.primary;
    }
  }

  static String labelFor(String fileType) {
    switch (fileType) {
      case 'pdf':
        return 'PDF';
      case 'video':
        return 'Vid';
      case 'word':
        return 'Wor';
      case 'doc':
        return 'Doc';
      default:
        return fileType;
    }
  }
}
