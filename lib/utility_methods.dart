import 'package:flutter/material.dart';

TextStyle kTextStyle({double size = 16.0}) {
  //18
  return TextStyle(
    // fontFamily: 'Padauk',
    fontFamily: 'Pyidaungsu',
    fontSize: size,
    color: Colors.black,
  );
}

final RoundedRectangleBorder kRoundedRectangleBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
);

final InputDecoration kInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hoverColor: Colors.white,
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
  errorStyle: kTextStyle().copyWith(
    color: Colors.red,
  ),
);

final BoxDecoration kTableRowBoxDecoration = BoxDecoration(
  border: Border.all(color: Colors.white),
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(10.0),
    topRight: Radius.circular(10.0),
  ),
);

const Color kButtonColor = Color(0xff4896D0);

const BoxDecoration kBackgroundContainer = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(10.0)),
  color: Color(0xff80B7DE),
);

const kPadding = EdgeInsets.symmetric(
  vertical: 40.0,
  horizontal: 20.0,
);

const kDropdownPadding = EdgeInsets.only(
  left: 20.0,
  right: 10.0,
);

final kDropdownBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10.0),
  border: Border.all(),
  color: Colors.white,
);
