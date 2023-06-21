import 'package:flutter/material.dart';

Widget createButton(String? title){
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        minimumSize: const Size(300 , 50), //////// HERE
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.indigoAccent, width: 2),
      ),
    onPressed: (){}, 
    child: Text('$title', style: const TextStyle(
        color: Colors.black,
        fontSize: 20, 
        fontStyle: FontStyle.normal,
      ),
    ),
  );
}