import 'package:flutter/material.dart';

/// Night-market palette lifted straight from the Aunty Runner design board (1d).
/// Danger = red-orange. Anything the player wants = teal or gold. Nothing else
/// is saturated.
class AppColors {
  AppColors._();

  static const primary = Color(0xFFFF5A3C); // danger / red-orange
  static const primaryShadow = Color(0xFFC13A22); // hard bottom shadow for buttons
  static const secondary = Color(0xFF17B4A6); // teal
  static const accent = Color(0xFFFFC94A); // gold / currency

  static const background = Color(0xFF17102B);
  static const surface = Color(0xFF241736);
  static const surfaceRaised = Color(0xFF2E1F45);

  static const textPrimary = Color(0xFFFFF3E2);
  static const textSecondary = Color(0xFFB7A9CF);

  static const success = Color(0xFF45D97B);
  static const warning = Color(0xFFFFB020);
  static const error = Color(0xFFFF4757);
  static const ink = Color(0xFF1B1424); // art outline

  // Daytime sky + street, used by the Flame background layers.
  static const skyTop = Color(0xFF5FC6E8);
  static const skyMid = Color(0xFF9BDDEE);
  static const skyWarm = Color(0xFFFFE0B4);
  static const skyLow = Color(0xFFFFCE96);

  static const roadAsphalt = Color(0xFF46414F);
  static const roadKerb = Color(0xFF6E6679);
  static const sidewalk = Color(0xFF8A8195);
  static const roadLine = Color(0xFFF2E4C6);

  static const skylineFar = Color(0xFF2A3A60);
}
