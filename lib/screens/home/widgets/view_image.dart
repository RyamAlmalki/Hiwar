import 'package:flutter/material.dart';

import '../../../models/message.dart';



class ViewImage extends StatelessWidget {
  const ViewImage({super.key, this.message});
  final Message? message;



  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('showModalBottomSheet'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(0),
                  image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: NetworkImage("${message?.message}"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
