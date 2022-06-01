// ignore_for_file: constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';

enum AppTheme { Yellow, GreenBlue, ImperialBlue, Black, RCS }

/// Returns enum value name without enum class name.
String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeData = {
  AppTheme.ImperialBlue: setTheme(
    mainColor: imperialBluePrimary,
    secondColor: imperialBlueAccent,
  ),
  AppTheme.GreenBlue: setTheme(
    mainColor: greenBluePrimary,
    secondColor: greenBlueAccent,
  ),
  AppTheme.Yellow: setTheme(
    mainColor: yellowPrimary,
    secondColor: yellowAccent,
  ),
  AppTheme.Black: setTheme(
    mainColor: blackPrimary,
    secondColor: blackAccent,
    textColor: Colors.white,
  ),
  AppTheme.RCS: setTheme(
    mainColor: rcsPrimary,
    secondColor: rcsAccent,
    textColor: Colors.white,
  ),
};

/// ----  Imperial Blue Theme  ----
const imperialBluePrimary = Color.fromRGBO(128, 183, 222, 1);
const imperialBlueAccent = Color.fromRGBO(128, 183, 222, 0.3);
// final imperialBlueTheme = setTheme(
//   mainColor: imperialBluePrimary,
//   secondColor: imperialBlueAccent,
// );

/// ----  Green Blue Theme  ----
const greenBluePrimary = Color.fromRGBO(87, 191, 196, 1);
const greenBlueAccent = Color.fromRGBO(87, 191, 196, 0.25);
// final greenBlueTheme = setTheme(
//   mainColor: greenBluePrimary,
//   secondColor: greenBlueAccent,
// );

/// ----  Yellow Theme  ----
const yellowPrimary = Color.fromRGBO(243, 203, 15, 1);
const yellowAccent = Color.fromRGBO(243, 203, 15, 0.2);
// final yellowTheme = setTheme(
//   mainColor: yellowPrimary,
//   secondColor: yellowAccent,
// );

/// ----  Black Theme  ----
const blackPrimary = Color.fromRGBO(63, 63, 63, 1);
const blackAccent = Color.fromRGBO(63, 63, 63, 0.25);
// final blackTheme = setTheme(
//   mainColor: blackPrimary,
//   secondColor: blackAccent,
//   textColor: Colors.white,
// );

/// ----  Brown Theme  ----
const rcsPrimary = Color.fromRGBO(83, 49, 37, 1);
const rcsAccent = Color.fromRGBO(83, 49, 37, 0.2);
// final pinkTheme = setTheme(
//   mainColor: pinkPrimary,
//   secondColor: pinkAccent,
// );

ThemeData setTheme({
  mainColor,
  secondColor,
  textColor = Colors.black,
}) {
  return ThemeData(
    primaryColor: mainColor,
    dividerTheme: const DividerThemeData(
      color: Colors.white,
    ),
    fontFamily: 'Padauk',
    textTheme: ThemeData.light().textTheme.copyWith(
          bodyText1: TextStyle(
            color: textColor,
          ),
          bodyText2: TextStyle(
            color: textColor,
          ),
          headline6: const TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w500,
          ),
        ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: secondColor),
  );
}
