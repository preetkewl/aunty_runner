import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Type ramp from the design board (1d): Baloo 2 for anything loud,
/// Mukta for anything read.
class AppText {
  AppText._();

  static TextStyle display({double size = 40, Color color = AppColors.textPrimary}) =>
      GoogleFonts.baloo2(
        fontSize: size,
        height: 1.0,
        fontWeight: FontWeight.w800,
        color: color,
      );

  static TextStyle title({double size = 24, Color color = AppColors.textPrimary}) =>
      GoogleFonts.baloo2(
        fontSize: size,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle button({double size = 21, Color color = AppColors.textPrimary}) =>
      GoogleFonts.baloo2(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: color,
      );

  static TextStyle score({double size = 40, Color color = AppColors.textPrimary}) =>
      GoogleFonts.baloo2(
        fontSize: size,
        height: 1.0,
        fontWeight: FontWeight.w800,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle body({double size = 14, Color color = AppColors.textSecondary}) =>
      GoogleFonts.mukta(
        fontSize: size,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle label({double size = 11, Color color = AppColors.textSecondary}) =>
      GoogleFonts.mukta(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.08 * size,
        color: color,
      );

  static TextStyle number({double size = 15, Color color = AppColors.textPrimary}) =>
      GoogleFonts.mukta(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );
}
