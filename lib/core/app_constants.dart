import 'package:flutter/material.dart';

class AppConstants {
  static const String appTitle = 'پرواز گنجشک سه بعدی';
  static const String appSubtitle = 'بازی ماجراجویی با نقاشی‌های دست‌ساز';
  
  // Game Play settings
  static const double baseFlightSpeed = 12.0;
  static const double maxHealth = 100.0;
  static const double initialHealth = 100.0;
  static const double damagePerHit = 25.0;
  static const double scorePenaltyPerHit = 50.0;
  static const double waterHealthBonus = 15.0;
  static const double seedHealthBonus = 20.0;
  static const double waterScoreBonus = 30.0;
  static const double seedScoreBonus = 50.0;
  
  // Growth mechanics
  static const double initialScale = 1.0;
  static const double growthPerItem = 0.08;
  static const double maxGrowthScale = 2.4;
  
  // World bounds in 3D
  static const double worldWidth = 16.0;
  static const double worldHeight = 12.0;
  static const double spawnDistanceZ = 180.0;
  static const double despawnDistanceZ = -15.0;
  
  // Storage Keys
  static const String keyHighScore = 'sparrow_high_score';
  static const String keyUnlockedLevel = 'sparrow_unlocked_level';
  static const String keySoundEnabled = 'sparrow_sound_enabled';
}

class AppColors {
  static const Color primary = Color(0xFF8D5524);
  static const Color primaryDark = Color(0xFF5D3614);
  static const Color accent = Color(0xFFE89A3C);
  static const Color gold = Color(0xFFFFD54F);
  static const Color waterBlue = Color(0xFF29B6F6);
  static const Color forestGreen = Color(0xFF2E7D32);
  static const Color woundRed = Color(0xFFE53935);
  static const Color warmBg = Color(0xFF1E1711);
  static const Color surfaceOverlay = Color(0xCC1E1711);
}
