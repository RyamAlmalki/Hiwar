import 'package:flutter/material.dart';

import '../../../shared/const.dart';

class BlockedPage extends StatefulWidget {
  const BlockedPage({super.key});

  @override
  State<BlockedPage> createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: accentColor, width: 1)
        ),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [  
            IconButton(
                icon:  const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async{
                Navigator.of(context).pop();
              },
            ),

            const Text('Blocked', style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold, color: Colors.white), ),

            const SizedBox(
              width: 60,
              height: 50,
            ),
          ],
        ), 
        centerTitle: false, 
        backgroundColor: Colors.black, 
        elevation: 0,
      ),
    );
  }
}