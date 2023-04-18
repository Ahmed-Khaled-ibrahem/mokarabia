import 'package:flutter/material.dart';

class AppColors{
  static Color cubColor1 = const Color(0xFF6b4c30);
  static Color cubColor2 = const Color(0xFF6b4320);
  static Color lightBrown = const Color(0xFFDBD0C0);
  static Color orange = const Color(0xFFE5890A);
  static Color white = const Color(0xFFE6E6E6);
  static Color black = const Color(0xFF424642);
}


ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  primaryColor: AppColors.orange,
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColors.lightBrown,

    background: AppColors.white,
    onBackground: AppColors.black,

  ),
  // appBarTheme: AppBarTheme(
  //   color: Colors.red
  // ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(AppColors.cubColor1)
    )
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(AppColors.white),
        backgroundColor: MaterialStateProperty.all(AppColors.cubColor1)
    )
  ),


);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primarySwatch: Colors.orange,
    primaryColor: AppColors.orange,

  colorScheme:  ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.black,

    background: AppColors.white,
    onBackground: AppColors.black,
  ),

    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(AppColors.cubColor1)
        )
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(AppColors.white),
            backgroundColor: MaterialStateProperty.all(AppColors.cubColor1)
        )
    ),

    // appBarTheme: AppBarTheme(
    //     backgroundColor: Colors.red,
    //   iconTheme: IconThemeData(color: Colors.red,),
    // )
);
