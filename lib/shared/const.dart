import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

final Color accentColor = HexColor("#35353d"); 
final Color primaryColor = HexColor("#F7931E");
final Color background = HexColor("#202025"); 
final Color textColor = HexColor("#C4C4C4");
final Color bubbleColor = HexColor("#de841b");

// we can use this constant in the different form field.
InputDecoration decorationStyles = InputDecoration(
    border: InputBorder.none,
    filled: true,
    fillColor: accentColor,
    hintStyle: TextStyle(color: textColor),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 1),
    ),
    enabledBorder:  OutlineInputBorder(
    borderSide: BorderSide(color: textColor, width: 0),
  ),
  labelStyle: TextStyle(color: textColor),
);
