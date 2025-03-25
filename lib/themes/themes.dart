import 'package:flutter/material.dart';
import 'package:golf_uiv2/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: GolfColor.BackgroundLightColor,
    primaryColor: GolfColor.GolfPrimaryColor,
    primaryTextTheme: lightTextTheme.copyWith(
      titleSmall: GoogleFonts.openSans(
        //subTitle
        fontSize: 12.0.sp,
        color: GolfColor.TextFieldLightColor,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: ThemeData.light().primaryTextTheme.titleMedium!.copyWith(
        color: GolfColor.TextDarkColor,
      ),
    ),
    textTheme: lightTextTheme,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: lightColorScheme.surface),
      actionsIconTheme: IconThemeData(color: lightColorScheme.surface),
      titleTextStyle: GoogleFonts.openSansTextTheme().headlineLarge?.copyWith(
        color: lightColorScheme.surface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  static final dark = ThemeData.dark().copyWith(
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: GolfColor.BackgroundDarkColor,
    primaryColor: GolfColor.GolfPrimaryColor,
    primaryTextTheme: darkTextTheme.copyWith(
      titleSmall: GoogleFonts.openSans(
        //subTitle
        fontSize: 12.0.sp,
        color: GolfColor.TextFieldDarkColor,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: ThemeData.light().primaryTextTheme.titleMedium!.copyWith(
        color: GolfColor.TextDarkColor,
      ),
    ),
    textTheme: darkTextTheme,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: darkColorScheme.surface),
      actionsIconTheme: IconThemeData(color: darkColorScheme.surface),
      titleTextStyle: GoogleFonts.openSansTextTheme().headlineLarge?.copyWith(
        color: darkColorScheme.surface,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0XFF11AF4E),
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

  static final TextTheme lightTextTheme = GoogleFonts.interTextTheme()
      .copyWith(
        headlineMedium: GoogleFonts.openSans(
          //headerLine 1
          fontSize: 16.0.sp,
          color: GolfColor.TextDarkColor,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: GoogleFonts.openSans(
          //headerLine 3
          fontSize: 12.0.sp,
          color: GolfColor.TextLightColor,
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: GoogleFonts.openSans(
          // headerLine 3
          fontSize: 20.0.sp,
          color: GolfColor.TextLightColor,
          fontWeight: FontWeight.w500,
        ),
      );

  static final TextTheme darkTextTheme = GoogleFonts.interTextTheme()
      .copyWith(
        headlineMedium: GoogleFonts.openSans(
          // headerLine 1
          fontSize: 16.0.sp,
          color: GolfColor.TextDarkColor,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: GoogleFonts.openSans(
          // headerLine 3
          fontSize: 12.0.sp,
          color: GolfColor.TextDarkColor,
          fontWeight: FontWeight.w500,
        ),
        headlineLarge: GoogleFonts.openSans(
          //subTitle
          fontSize: 10.0.sp,
          color: GolfColor.SubTextColor,
          fontWeight: FontWeight.w400,
        ),
      );
}
