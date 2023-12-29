import 'package:flutter/material.dart';

class Globals {
  static Color mainBackgroundColor = Color.fromARGB(235, 248, 248, 248);

  static Color secondaryColor = Color.fromARGB(255, 188, 108, 37);
  static Color primaryColor = Color.fromARGB(255, 96, 108, 56);

  static Color appBarBackgroundColor = Color.fromRGBO(255, 255, 255, 1);
  static Color tileBackgroundColor = Color.fromRGBO(243, 243, 243, 1);
  static Color floatingAddButton = secondaryColor;

  //drawer
  static Color drawerTextColor = Color.fromRGBO(255, 255, 255, 1);
  static Color drawerBackgroundColor = primaryColor;
  static Color drawerIconColor = primaryColor;
  //navbar
  static Color selectedNavBarIcon = secondaryColor;
  static Color unselectedNavBarIcon = Color.fromARGB(255, 68, 81, 40);

  static BoxDecoration tagDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20.0), color: secondaryColor);

  static InputDecoration inputDecorationStyling(textHint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintText: (textHint != null) ? textHint : 'Digite aqui...',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Globals.secondaryColor),
      ),
    );
  }
}
