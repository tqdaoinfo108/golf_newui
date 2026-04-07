import 'package:flutter/material.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Themes {
  static double _adaptiveSp(double value, {required double min, required double max}) {
    return value.sp.clamp(min, max).toDouble();
  }

  static TextTheme _buildTextTheme({
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color mutedTextColor,
  }) {
    final base = GoogleFonts.interTextTheme();

    return base.copyWith(
      // Headline
      headlineMedium: GoogleFonts.openSans(
        fontSize: 16.0.sp,
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      headlineSmall: GoogleFonts.openSans(
        fontSize: 12.0.sp,
        color: secondaryTextColor,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),
      headlineLarge: GoogleFonts.openSans(
        fontSize: 11.0.sp,
        color: secondaryTextColor,
        fontWeight: FontWeight.w500,
        height: 1.25,
      ),

      // Title
      titleLarge: GoogleFonts.openSans(
        fontSize: 14.0.sp,
        color: primaryTextColor,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      titleMedium: GoogleFonts.openSans(
        fontSize: 12.0.sp,
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      titleSmall: GoogleFonts.openSans(
        fontSize: 10.5.sp,
        color: secondaryTextColor,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),

      // Body
      bodyLarge: GoogleFonts.inter(
        fontSize: 11.5.sp,
        color: primaryTextColor,
        fontWeight: FontWeight.w500,
        height: 1.35,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 10.0.sp,
        color: secondaryTextColor,
        fontWeight: FontWeight.w400,
        height: 1.35,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 9.0.sp,
        color: mutedTextColor,
        fontWeight: FontWeight.w400,
        height: 1.3,
      ),

      // Label / Button
      labelLarge: GoogleFonts.inter(
        fontSize: 10.0.sp,
        color: primaryTextColor,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 9.0.sp,
        color: secondaryTextColor,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 8.0.sp,
        color: mutedTextColor,
        fontWeight: FontWeight.w500,
        height: 1.2,
      ),
    );
  }

  static final light = ThemeData.light().copyWith(
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: GolfColor.BackgroundLightColor,
    primaryColor: GolfColor.GolfPrimaryColor,

    primaryTextTheme: lightTextTheme.apply(
      bodyColor: lightColorScheme.onPrimary,
      displayColor: lightColorScheme.onPrimary,
    ),
    textTheme: lightTextTheme,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: lightColorScheme.surface),
      actionsIconTheme: IconThemeData(color: lightColorScheme.surface),
      titleTextStyle: lightTextTheme.titleLarge?.copyWith(
        color: lightColorScheme.surface,
        fontSize: _adaptiveSp(13.8, min: 13.0, max: 17.0),
        fontWeight: FontWeight.w700,
      ),
    ),
  );
  static final dark = ThemeData.dark().copyWith(
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: GolfColor.BackgroundDarkColor,
    primaryColor: GolfColor.GolfPrimaryColor,
    primaryTextTheme: darkTextTheme.apply(
      bodyColor: darkColorScheme.onPrimary,
      displayColor: darkColorScheme.onPrimary,
    ),
    textTheme: darkTextTheme,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: darkColorScheme.surface),
      actionsIconTheme: IconThemeData(color: darkColorScheme.surface),
      titleTextStyle: darkTextTheme.titleLarge?.copyWith(
        color: darkColorScheme.surface,
        fontSize: _adaptiveSp(13.8, min: 13.0, max: 17.0),
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: GolfColor.GolfPrimaryColor,
    primaryContainer: Color(0XFF4CB94D),
    secondary: Color(0XFFE8A21A),
    secondaryContainer: Color(0xFFE8A21A),
    background: Color(0xFFF1F1FA),
    surface: Color(0xFF000000),
    onBackground: Color(0xFFFCFCFF),
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Color(0xFFFCFCFF),
    onSecondary: Color(0xFFFCFCFF),
    onSurface: Color(0xFFA1A1A1),
    brightness: Brightness.light,
  );

  static final ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0XFF11AF4E),
    primaryContainer: Color(0XFF4CB94D),
    secondary: Color(0XFFE8A21A),
    secondaryContainer: Color(0xFFE8A21A),
    background: Color(0xFF161719),
    surface: Color(0xFFFCFCFF),
    onBackground: Color(0xFF212325),
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Color(0xFFFCFCFF),
    onSecondary: Color(0xFFFCFCFF),
    onSurface: Color(0xFFA1A1A1),
    brightness: Brightness.dark,
  );

  static final TextTheme lightTextTheme = _buildTextTheme(
    primaryTextColor: GolfColor.TextDarkColor,
    secondaryTextColor: GolfColor.TextLightColor,
    mutedTextColor: GolfColor.SubTextColor,
  );

  static final TextTheme darkTextTheme = _buildTextTheme(
    primaryTextColor: GolfColor.TextDarkColor,
    secondaryTextColor: GolfColor.TextDarkColor,
    mutedTextColor: GolfColor.SubTextColor,
  );
}
