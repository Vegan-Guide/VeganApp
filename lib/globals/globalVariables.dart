import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Globals {
  static Color appBarBackgroundColor = Color.fromRGBO(65, 179, 103, 1);
  static Color drawerTextColor = Color.fromRGBO(0, 0, 0, 1);
  static Color drawerBackgroundColor = Color.fromRGBO(221, 255, 232, 1);
  static Color tileBackgroundColor = Color.fromRGBO(243, 243, 243, 1);
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
