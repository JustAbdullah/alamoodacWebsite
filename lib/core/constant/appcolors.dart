import 'package:flutter/material.dart';

class AppColors {
  static Color get TheMainLight => Color.fromARGB(255, 24, 60, 176);
  static Color get TextSecondary => Color(0xFF666666);
  static Color get BackgroundLight => Color(0xFFF8F9FA);
  static Color get BackgroundDark => Color(0xFF1A1A1A);
  ////////
  static Color primaryColor = Colors.blueAccent;
  static const darkBackgroundColor = Color(0xFF121212);
  /////////// The App Main Color ///////////////////////
  static const Color TheMain = Color(0xFF001A6E);
  static const Color blueLight = Color(0xFF4CC9FE);
  static const Color blueDark = Color(0xFF1976D2);

  static const Color brown = Color(0xFFF4D2A1D);
  static const Color oragne = Color(0xFFFDFA047);

  /////////////// White Colors /////////////////////////
  static const Color whiteColor = Color.fromARGB(255, 255, 255, 255);
  static const Color whiteColorTypeOne = Color.fromARGB(250, 250, 250, 250);
  static const Color whiteColorTypeTwo = Color(0xFFF0EFEF);
  static const Color whiteColorTypeThree = Color.fromARGB(255, 225, 225, 225);

  /////////////// Black Colors /////////////////////////
  static const Color blackColor = Color.fromARGB(255, 0, 0, 0);
  static const Color blackColorsTypeOne = Color(0xFF2B2B2B);

  static const Color blackColorTypeTeo = Color(0xFF272829);
  static const Color balckColorTypeThree = Color.fromARGB(255, 36, 38, 41);
  static const Color balckColorTypeFour = Color.fromARGB(255, 48, 47, 47);

  //////////////////// Additional Colors ////////////////////
  static const Color purpleColor = Color(0xFF241468);
  static const Color darkBlueColor = Color(0xFF060047);
  static const Color redColor = Color(0xFFD80032);
  static const Color yellowColor = Color(0xFFFFC800);

  /////////////// Dynamic Colors for Light & Dark Mode ///////////////
  static Color backgroundColor(bool isDarkMode) =>
      isDarkMode ? blackColorsTypeOne : whiteColorTypeOne;

  static Color cardColor(bool isDarkMode) =>
      isDarkMode ? balckColorTypeFour : whiteColor;

  static Color textColor(bool isDarkMode) =>
      isDarkMode ? whiteColorTypeOne : blackColorTypeTeo;
  static Color textColorOne(bool isDarkMode) =>
      isDarkMode ? whiteColorTypeOne : const Color.fromARGB(255, 63, 62, 62);
  static Color borderColor(bool isDarkMode) =>
      isDarkMode ? balckColorTypeThree : whiteColorTypeOne;
  static const Color diamondColor = Color(0xFF00C2FF);
  static const Color investorColor = Color(0xFFFF9900);
  static const Color commercialColor = Color(0xFF2ECC71);
  static const Color economicColor = Color(0xFFFF4757);
  static const Color textGrey = Color(0xFF666666);
  static const Color textBlack = Color(0xFF333333);
  static Color backgroundColorIcon(bool isDarkMode) =>
      isDarkMode ? whiteColorTypeOne : Color.fromARGB(255, 52, 51, 51);

  static Color backgroundColorIconBack(bool isDarkMode) =>
      isDarkMode ? oragne : Color(0xFF001A6E);

  static Color backgroundColorIconBackTwo(bool isDarkMode) => isDarkMode
      ? const Color.fromARGB(255, 233, 177, 99)
      : Color.fromARGB(255, 24, 60, 176);
  static Color primaryDark = Color(0xFF2A2D3E);
  static Color primaryLight = Color(0xFF3C4156);
  static Color accentColor = Color(0xFFF5A623);
  static Color cardBackground = Color(0xFFFFFFFF);
  static Color primaryText = Color(0xFF2A2D3E);
  static Color secondaryText = Color(0xFF6B7280);
  static Color errorColor = Color(0xFFE53935);
  static const Color TheMainPurple = Color(0xFF6A1B9A);
  static const Color greyColor = Color(0xFFE0E0E0);

  static Color dividerColor(bool isDark) =>
      isDark ? Colors.grey[800]! : Colors.grey[200]!;

  static Color iconColor(bool isDark) =>
      isDark ? Colors.grey[300]! : Colors.grey[700]!;

  static Color warningColor = Colors.amber.shade700;

  static const Color orange = Color(0xFFFF6D00);
  static const Color green = Color.fromARGB(255, 44, 165, 7);
  static Color primaryTextColor = Color(0xFF1A237E);
  static Color secondaryTextColor = Color(0xFF616161);
  static Color successColor = Color(0xFF4CAF50);

  static const Color commercialBadge = Color(0xFF2196F3);
  static const Color personalBadge = Color(0xFF4CAF50);
  static const Color instagramColor = Color(0xFFE1306C);
  static const Color facebookColor = Color(0xFF3B5998);
  static const Color youtubeColor = Color(0xFFFF0000);
  static const Color linkedinColor = Color(0xFF0077B5);
  static const Color secondaryColor = Color(0xFF00C853);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color darkCardBackground = Color(0xFF2D2D2D);

// Social Media Colors
  static const Color instagram = Color(0xFFE1306C);
  static const Color facebook = Color(0xFF1877F2);
  static const Color youtube = Color(0xFFFF0000);
  static const Color linkedin = Color(0xFF0A66C2);
}
