import 'package:chatapp/screens/widgets/searchbar.dart';
import 'package:chatapp/screens/widgets/user_list.dart';
import 'package:chatapp/screens/widgets/user_message_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../const.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreentState();
}

class _MessageScreentState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
      child: Column(
        children: [
            UserMessageTile(),
            Expanded(child: ListView(scrollDirection: Axis.horizontal,)),
            SearchBar(), 
          ],
        )
      ),
    );
  }
}

