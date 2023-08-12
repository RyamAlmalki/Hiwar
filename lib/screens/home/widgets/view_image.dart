import 'package:flutter/material.dart';

import '../../../models/message.dart';
import '../../../shared/const.dart';


class ViewImage extends StatelessWidget {
  const ViewImage({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: textColor,
                size: 30,
                
              ),
              onPressed: () {
               Navigator. of(context). pop();
              },
            ),
          ],
        ), 
        centerTitle: false, 
        backgroundColor: background, 
        elevation: 0,
      ),
      body: Container(
        
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(0),
            image: DecorationImage(
              fit: BoxFit.scaleDown,
              image: NetworkImage("${message.message}"),
            ),
          ),
        ),
    );
  }
}