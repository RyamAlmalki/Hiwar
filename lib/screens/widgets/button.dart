import 'package:flutter/material.dart';

ButtonStyle buttonStyle(){
  return ElevatedButton.styleFrom(
    minimumSize: const Size(300 , 50), //////// HERE
    backgroundColor: Colors.white,
    side: const BorderSide(color: Colors.indigoAccent, width: 2),
  );
}


