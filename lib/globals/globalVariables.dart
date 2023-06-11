import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Globals {
  static Color colorOne = Color.fromRGBO(63, 227, 45, 1);
  static Color appBarBackgroundColor = Color.fromRGBO(85, 175, 71, 1);
  static Color tileBackgroundColor = Color.fromRGBO(243, 243, 243, 1);
  static Color floatingAddButton = Color.fromRGBO(85, 175, 71, 1);

  //drawer
  static Color drawerTextColor = Color.fromRGBO(255, 255, 255, 1);
  static Color drawerBackgroundColor = Color.fromRGBO(85, 175, 71, 1);
  static Color drawerIconColor = Color.fromRGBO(255, 255, 255, 1);
  //navbar
  static Color navBarBackgroundColor = Color.fromRGBO(85, 175, 71, 1);
  static Color selectedNavBarIcon = Color.fromARGB(255, 39, 196, 55);
  static Color unselectedNavBarIcon = Color.fromARGB(255, 110, 133, 112);

  static InputDecoration inputDecorationStyling = InputDecoration(
    filled: true,
    fillColor: Colors.grey[200],
    hintText: 'Digite aqui...',
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
      borderSide: BorderSide.none,
    ),
  );
}
