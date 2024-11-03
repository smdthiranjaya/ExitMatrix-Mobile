import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

// Create a custom scroll behavior to allow touch and mouse devices to be used
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Return a set of pointer devices that can be used for dragging
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

// Create a function to return a TextStyle based on the given parameters
TextStyle SafeGoogleFont(
  // The font family to use
  String fontFamily, {
  // An optional TextStyle
  TextStyle? textStyle,
  // An optional color
  Color? color,
  // An optional background color
  Color? backgroundColor,
  // An optional font size
  double? fontSize,
  // An optional font weight
  FontWeight? fontWeight,
  // An optional font style
  FontStyle? fontStyle,
  // An optional letter spacing
  double? letterSpacing,
  // An optional word spacing
  double? wordSpacing,
  // An optional text baseline
  TextBaseline? textBaseline,
  // An optional height
  double? height,
  // An optional locale
  Locale? locale,
  // An optional foreground paint
  Paint? foreground,
  // An optional background paint
  Paint? background,
  // An optional list of shadows
  List<Shadow>? shadows,
  // An optional list of font features
  List<FontFeature>? fontFeatures,
  // An optional text decoration
  TextDecoration? decoration,
  // An optional decoration color
  Color? decorationColor,
  // An optional decoration style
  TextDecorationStyle? decorationStyle,
  // An optional decoration thickness
  double? decorationThickness,
}) {
  // Try to return the TextStyle based on the given parameters
  try {
    return GoogleFonts.getFont(
      fontFamily,
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  // If an exception is thrown, return a default TextStyle
  } catch (ex) {
    return GoogleFonts.getFont(
      "Source Sans Pro",
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }
}