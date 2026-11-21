import 'package:flutter/material.dart';

/// Centralized design tokens and color definitions
abstract final class AppColors {
  // ==========================================
  // LIGHT THEME (Navy, Off-White, Warm Orange)
  // ==========================================
  static const Color lightPrimary = Color(0xFF0F1E36);            // Deep Navy
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFF1E3A66);
  static const Color lightOnPrimaryContainer = Color(0xFFD6E4FF);

  static const Color lightSecondary = Color(0xFFFF6B35);          // Vibrant Warm Orange
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFFFDBCF);
  static const Color lightOnSecondaryContainer = Color(0xFF380D00);

  static const Color lightBackground = Color(0xFFF8F9FA);         // Soft Off-White
  static const Color lightOnBackground = Color(0xFF0F172A);
  static const Color lightSurface = Color(0xFFFFFFFF);            // Clean card/modal surface
  static const Color lightOnSurface = Color(0xFF0F172A);
  static const Color lightSurfaceVariant = Color(0xFFE9ECEF);
  static const Color lightOnSurfaceVariant = Color(0xFF475569);
  static const Color lightOutline = Color(0xFFCBD5E1);

  // ===================================================
  // DARK THEME (Obsidian Black, Cherry Red, Champagne Gold)
  // ===================================================
  static const Color darkBackground = Color(0xFF121212);          // Obsidian Black
  static const Color darkOnBackground = Color(0xFFF1F5F9);
  static const Color darkSurface = Color(0xFF1E1E1E);             // Elevated dark card surface
  static const Color darkOnSurface = Color(0xFFF1F5F9);
  static const Color darkSurfaceVariant = Color(0xFF282828);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkOutline = Color(0xFF3D3D3D);

  static const Color darkPrimary = Color(0xFFD90429);             // Cherry Red
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkPrimaryContainer = Color(0xFF5E0111);
  static const Color darkOnPrimaryContainer = Color(0xFFFFD9DF);

  static const Color darkSecondary = Color(0xFFE0A96D);           // Champagne Gold / Warm Amber
  static const Color darkOnSecondary = Color(0xFF2C1C07);
  static const Color darkSecondaryContainer = Color(0xFF4D351A);
  static const Color darkOnSecondaryContainer = Color(0xFFFFDFB6);

  // ==========================================
  // SHARED FEEDBACK & STATUS COLORS
  // ==========================================
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color info = Color(0xFF0288D1);
}
