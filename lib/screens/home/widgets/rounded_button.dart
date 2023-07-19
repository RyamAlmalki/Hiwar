import 'package:flutter/material.dart';
import '../../../const.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({super.key, this.title, required this.onPressed});

  final String? title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(29))),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white
      ),
      onPressed: onPressed,
      child: Text("$title"),
    );
  }
}