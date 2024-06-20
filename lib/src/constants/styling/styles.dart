import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mystyles {
  // Text Styles
  static TextStyle textstyle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color:const Color(0xFF68BBE3),
  );

  static TextStyle headingstyle = GoogleFonts.roboto(
    color: const Color(0xFFD3B1C2),
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

 static TextStyle headingcardstyle = GoogleFonts.roboto(
    color: const Color(0xFF7EC8E3),
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static TextStyle textinbutton = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
    static TextStyle textinelevatedbutton = GoogleFonts.roboto(
    color:const Color(0xFFF2FBE0),
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle hintbuttontext = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // Color Styles
  static Color mybackgroundColor = const Color(0xFF050A30);
  static Color mybuttonColor = Colors.blue;
  static Color mybottomNavigationBarColor =const Color(0xFF211522);
  static Color myappBarColor = const Color(0xFF050A30);
  static Color myprimaryTextColor = const Color(0xFFD3B1C2);
  static Color mysecondaryTextColor =const Color(0xFFC197D2);
  static Color myaccentColor =const Color(0xFF003060);
  static Color myelevatedbuttoncolor = const Color(0xFF000C66);


  // Other styles can be added here
}
