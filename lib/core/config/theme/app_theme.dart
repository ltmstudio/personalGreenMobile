import 'package:flutter/material.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/text_fonts.dart';

class AppTheme {
  const AppTheme();

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgColor,
       fontFamily: TextFonts.mulish,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgColor,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        shadowColor: Colors.white,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: TextFonts.mulish,
          fontSize: 20,
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: AppColors.darkBlue,
        ),
        titleMedium: TextStyle(
          //Последние заказы
          //  color: AppColors.accent,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: TextStyle(
          //Название заказа
          //    color: AppColors.darkBlue,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          //   color: AppColors.darkBlue,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          color: AppColors.darkBlue,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.gray,
        ),
      ),
      disabledColor: AppColors.lightGray,
    );
  }
}
