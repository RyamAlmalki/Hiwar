import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

final Color accentColor = HexColor("#222229");
final Color primaryColor = HexColor("#F7931E");
final Color background = HexColor("#1E1E27");
final Color textColor = HexColor("#C4C4C4");


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
