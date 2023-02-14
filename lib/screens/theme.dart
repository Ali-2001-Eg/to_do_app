import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color blushClr = Color(0xff4e5ae8);
const Color yellowClr = Color(0xffffb746);
const Color pinkClr = Color(0xffff4667);
const Color white = Colors.white;
const primaryClr = blushClr;
const Color darkGreyClr = Color(0xff121212);
const Color darkHeaderClr = Color(0xff424242);

class Themes {
  static final lightMode = ThemeData(
    backgroundColor: white,
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );
  static final darkMode = ThemeData(
    backgroundColor: darkGreyClr,
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle => GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: (Get.isDarkMode) ? Colors.grey[400] : Colors.grey,
      ),
    );
TextStyle get headingStyle => GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: (Get.isDarkMode) ? Colors.white : Colors.black,
      ),
    );


TextStyle get titleStyle => GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: (Get.isDarkMode) ? Colors.white : Colors.black,
      ),
    );

TextStyle get subTitleStyle => GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: (Get.isDarkMode) ? Colors.grey[100] : Colors.grey[600],
      ),
    );
