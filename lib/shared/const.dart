import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

final Color accentColor = HexColor("#1a1a1a"); 
final Color primaryColor = HexColor("#F7931E");
final Color background = HexColor("#1a1a1a"); 
final Color textColor = HexColor("#e6e6e6");
final Color bubbleColor = HexColor("#de841b");

// we can use this constant in the different form field.
InputDecoration decorationStyles = InputDecoration(
    border: InputBorder.none,
    filled: true,
    fillColor: accentColor,
    hintStyle: TextStyle(color: textColor),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: accentColor, width: 0),
      borderRadius: BorderRadius.circular(10)
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: accentColor, width: 0),
      borderRadius: BorderRadius.circular(10)
    ),
    enabledBorder:  OutlineInputBorder(
      borderSide: BorderSide(color: accentColor, width: 0),
      borderRadius: BorderRadius.circular(10)
    ),
  labelStyle: TextStyle(color: textColor),
);


