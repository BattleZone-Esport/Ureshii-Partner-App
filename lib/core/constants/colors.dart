import 'package:flutter/material.dart';

/// URESHII Partner Color Palette
/// Design System Colors for Dark Theme
class AppColors {
  // Primary Colors
  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color secondaryPink = Color(0xFFFF6584);
  
  // Background Colors
  static const Color backgroundColor = Color(0xFF0F0F1E);
  static const Color surfaceColor = Color(0xFF1A1A2E);
  static const Color cardColor = Color(0xFF16213E);
  
  // Accent Colors
  static const Color accentBlue = Color(0xFF4FACFE);
  static const Color accentPurple = Color(0xFFB77FEB);
  static const Color accentPink = Color(0xFFFF85A6);
  static const Color accentGreen = Color(0xFF4ADE80);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C8);
  static const Color textHint = Color(0xFF6C6C8F);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, secondaryPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentBlue, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Status Colors
  static const Color success = Color(0xFF4ADE80);
  static const Color error = Color(0xFFFF6584);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF4FACFE);
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A6C63FF);
  static const Color shadowMedium = Color(0x336C63FF);
  static const Color shadowHeavy = Color(0x4D6C63FF);
}
