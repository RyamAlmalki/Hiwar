import 'package:chatapp/models/conversation.dart';

import 'package:chatapp/screens/home/image_page.dart';
import 'package:flutter/material.dart';




class MainpageScreen extends StatefulWidget {

  MainpageScreen({super.key, required this.pages, required this.value, required this.conversation});

  Conversation? conversation;

  List<ImagePage> pages = [
    //...
  ];
  
  int value = 0; // index of the first page to be clicked 

  int getPage() {
    return value; // here we got the index 
  }

  void setPage(int page) { // here we set the page index 
    value = page;
  }

  @override
  _MainpageScreenState createState() => _MainpageScreenState();
}


class _MainpageScreenState extends State<MainpageScreen> {

  late final PageController controller;


  @override
  void initState() {
   controller = PageController(
    initialPage: widget.getPage()
  );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
    direction: DismissDirection.vertical,
    key: const Key('key'),
    background: Scaffold(backgroundColor: Colors.amber),
    onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            setState(() {
              widget.setPage(index);
              controller.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
            });
          },
          itemBuilder: (context, index) => widget.pages[index],
          itemCount: widget.pages.length,
        )
      ),
    );
  }
}