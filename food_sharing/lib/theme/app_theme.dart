import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme() {
  return ThemeData(

    scaffoldBackgroundColor: BrandColors.cream,

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: BrandColors.cream
    ),

    appBarTheme: AppBarThemeData(
      backgroundColor: BrandColors.cream
    ),  

    primaryColor: BrandColors.darkGreen,

    textTheme: TextTheme(
      displayLarge: GoogleFonts.nunito(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 16,
      ),
    ),
  );
}

class BrandColors {
  static const green = Color.fromARGB(255, 19, 124, 53);
  static const darkGreen = Color.fromARGB(255, 9, 46, 21);
  static const mediumGreen = Color.fromARGB(255, 88, 129, 87);
  static const cream =  Color(0xFFFFFAEE);
  static const red = Color.fromARGB(255, 193, 18, 31);
  static const darkRed = Color.fromARGB(255, 141, 16, 24);
  static const yellow = Color.fromARGB(255, 246, 189, 96);
  static const darkYellow = Color.fromARGB(255, 102, 72, 24);
  static const black = Colors.black;
  static const white = Colors.white;
  static const gray = Color.fromARGB(255, 196, 194, 192);
  static const darkGray =Color.fromARGB(255, 109, 107, 105);

}

class TextStyleTheme {
  static final title = GoogleFonts.sourGummy(
    fontSize: 64,
    fontWeight: FontWeight.w800,
    color: BrandColors.darkGreen,
    height: 0.8,
  );
  
  static final titleSmall = GoogleFonts.sourGummy(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: BrandColors.darkGreen,
    height: 0.8,
  );


  static final titleXs = GoogleFonts.sourGummy(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: BrandColors.darkGreen,
    height: 0.8,
  );

  static final heading = GoogleFonts.sourGummy(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: BrandColors.darkRed,
    height: 0.8,
  );

  static final heading_white = GoogleFonts.sourGummy(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: BrandColors.white,
    height: 0.8,
  );

  static final heading_white_md = GoogleFonts.sourGummy(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: BrandColors.white,
    height: 0.8,
  );

    static final heading_white_s = GoogleFonts.sourGummy(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: BrandColors.white,
    height: 0.8,
  );
  
  static final body = GoogleFonts.sourGummy(
    fontSize: 18,
    color: BrandColors.black
  );

  static final body_sub = GoogleFonts.sourGummy(
    fontSize: 16,
    color: BrandColors.darkGray
  );

  static final subtitle_bold = GoogleFonts.sourGummy(
    fontSize: 22,
    color: BrandColors.black,
    fontWeight: FontWeight.bold
  );

  static final subtitle = GoogleFonts.sourGummy(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: BrandColors.black
  );

  static final button = GoogleFonts.sourGummy(    
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  
  static final insets = EdgeInsets.all(8);

  static InputDecoration textInput({required String label, Widget? prefixIcon}) {
  return InputDecoration(
    filled: true,
    fillColor: BrandColors.white,
    labelText: label, 
    prefixIcon: prefixIcon,
    
    labelStyle: TextStyle(color: BrandColors.darkGreen),
    
    floatingLabelStyle: TextStyle(
      color: BrandColors.darkGreen, 
      fontWeight: FontWeight.bold
    ),

    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: BrandColors.darkGreen),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: BrandColors.darkGreen),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: BrandColors.darkGreen, width: 2),
    ),

    prefixIconColor: BrandColors.darkGreen,
  );
}


}


