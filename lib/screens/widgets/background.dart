import 'package:flutter/material.dart';

class LineBackground extends StatelessWidget {
  const LineBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/images/topline.png'),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/images/bottomline.png'),
          ],
        )
      ]
    );
  }
}
