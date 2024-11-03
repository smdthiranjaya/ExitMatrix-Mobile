import 'dart:ui';

import 'package:flutter/material.dart';

const finishedOnBoardingConst = 'finishedOnBoarding';
const colorPrimary = 0xFF201e1f;
const homebg = 0xFFFFFFFF;
const nav = 0xFF8CA52D;
const usersCollection = 'users';
const eula =
    'https://www.termsfeed.com/public/uploads/2021/12/sample-terms-conditions-agreement.pdf';

class MapThemeColors {
  static const Color background = Color(0xFF000000);    // Black background
  static const Color primary = Color(0xFFFF0000);       // Red for primary elements
  static const Color secondary = Color(0xFFFFFFFF);     // White for secondary elements
  
  // Map specific colors
  static const Color wallColor = Color(0xFF1A1A1A);     // Dark gray for walls
  static const Color pathColor = Color(0xFF333333);     // Lighter gray for paths
  static const Color playerColor = Color(0xFFFFFFFF);   // White for player
  static const Color exitColor = Color(0xFF00FF00);     // Keep green for exit (safety)
  static const Color fireColor = Color(0xFFFF0000);     // Red for fire
  static const Color fireZoneColor = Color(0xFFFF4444); // Lighter red for fire zone
  static const Color escapePathColor = Color(0xFFFFFFFF); // White for escape path
}

class EmergencyThemeColors {
  static const Color background = Colors.white;
  static const Color primary = Color(0xFFE53935);    // Bright red for warnings/critical
  static const Color secondary = Color(0xFF2196F3);  // Blue for information
  static const Color text = Color(0xFF212121);       // Near black for text
  static const Color surface = Color(0xFFFAFAFA);    // Light grey for surfaces
  
  // Map specific colors
  static const Color wallColor = Color(0xFF424242);  // Dark grey for walls
  static const Color pathColor = Color(0xFFE0E0E0);  // Light grey for paths
  static const Color playerColor = Color(0xFF2196F3); // Blue for player
  static const Color exitColor = Color(0xFF4CAF50);  // Green for exits
  static const Color fireColor = Color(0xFFE53935);  // Red for fire
  static const Color fireZoneColor = Color(0xFFFFCDD2); // Light red for fire zones
  static const Color escapePathColor = Color(0xFF4CAF50); // Green for escape path
}