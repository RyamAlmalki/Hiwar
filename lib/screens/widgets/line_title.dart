import 'package:flutter/material.dart';

class TitleLine extends StatelessWidget {
  TitleLine({super.key, this.title, this.width});

  String? title;
  double? width;

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  [
         SizedBox(
          width: width,
          child: const Divider(
            color: Colors.white,
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(5,0,5,0),
          child: Text('$title', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        ),

        const SizedBox(
        width: 150,
        child: Divider(
          color: Colors.white,
          ),
        ),
      ],
    );
  }
}