import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';

class AppFonts {
  static TextStyle hero({required Color color}) => TextStyle(
    fontFamily: "CormorantGaramond",
    fontSize: 42,
    fontVariations: const [FontVariation('wght', 500)],
    letterSpacing: -0.4,
    height: 0.98,
    color: color,
  );

  static TextStyle heading({required Color color}) => TextStyle(
    fontFamily: "CormorantGaramond",
    fontSize: 30,
    fontVariations: const [FontVariation('wght', 500)],
    height: 1.05,
    color: color,
  );

  static TextStyle bodyLarge({required Color color}) => TextStyle(
    fontFamily: "DMSANS",
    fontSize: 16,
    fontVariations: const [FontVariation('wght', 400)],
    height: 1.45,
    color: color,
  );

  static TextStyle body({required Color color}) => TextStyle(
    fontFamily: "DMSANS",
    fontSize: 14,
    fontVariations: const [FontVariation('wght', 400)],
    height: 1.5,
    color: color,
  );

  static TextStyle label({required Color color}) => TextStyle(
    fontFamily: "DMSANS",
    fontSize: 12,
    fontVariations: const [FontVariation('wght', 500)],
    letterSpacing: 2.2,
    height: 1.0,
    color: color,
  );

  static TextStyle buttonText({required Color color}) => TextStyle(
    fontFamily: "DMSANS",
    fontSize: 14,
    fontVariations: const [FontVariation('wght', 600)],
    height: 1.0,
    color: color,
  );
}
