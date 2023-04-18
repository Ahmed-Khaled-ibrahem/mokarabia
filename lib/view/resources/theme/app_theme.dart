import 'package:flutter/material.dart';

class AppColors{
  static Color cubColor1 = const Color(0xFF6b4c30);
  static Color cubColor2 = const Color(0xFF6b4320);
  static Color lightBrown = const Color(0xFFDBD0C0);
  static Color orange = const Color(0xFFE5890A);
  static Color white = const Color(0xFFE6E6E6);
  static Color black = const Color(0xFF424642);
  static Color red = const Color(0xFFED2B2A);

  static Color card1 = const Color(0xFFEEEEEE);
  static Color card2 = const Color(0xFFFFFBF5);

  static Color card1D = const Color(0xFF424642);
  static Color card2D = const Color(0xFF293539);


}


ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primarySwatch: Colors.orange,
  primaryColor: AppColors.orange,
  scaffoldBackgroundColor: AppColors.white,




  colorScheme: ColorScheme.light(
    brightness: Brightness.light,

    primary: AppColors.orange,
    onPrimary: AppColors.black,
    inversePrimary: AppColors.lightBrown,

    background: AppColors.white,
    onBackground: AppColors.black,

    secondary: AppColors.card1,
    onSecondary: AppColors.card2,
    onInverseSurface: AppColors.lightBrown,

    surface: AppColors.white,  // app bar , floating button
    onSurface: AppColors.black,  // text
    inverseSurface: AppColors.lightBrown,

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
  scaffoldBackgroundColor: AppColors.black,

    buttonColor: AppColors.red,
    highlightColor: AppColors.red,
    indicatorColor: AppColors.red,



  colorScheme:  ColorScheme.dark(
    brightness: Brightness.dark,

    primary: AppColors.orange,
    onPrimary: AppColors.black,
    // inversePrimary: AppColors.lightBrown,

    background: AppColors.black,
    onBackground: AppColors.white,

    secondary: AppColors.card1D,
    onSecondary: AppColors.card2D,
    // onInverseSurface: AppColors.lightBrown,

    surface: AppColors.black,
    onSurface: AppColors.white,
    // inverseSurface: AppColors.lightBrown,
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

    dialogTheme: DialogTheme(
      backgroundColor: AppColors.black,
      contentTextStyle: TextStyle(
        color: AppColors.white
      )
      // surfaceTintColor: AppColors.red.withOpacity(1)
    )

    // appBarTheme: AppBarTheme(
    //     backgroundColor: Colors.red,
    //   iconTheme: IconThemeData(color: Colors.red,),
    // )
);
