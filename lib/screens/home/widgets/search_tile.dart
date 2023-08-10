import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';

import '../../../shared/const.dart';
import '../message_screen.dart';

class SearchTile extends StatelessWidget {

  ChatUser? user;
  SearchTile({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('${user?.email}', style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 15),),
        ),
        tileColor: background,
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(user!.photoURL ?? '') ,
        ),
        title: Text('${user?.displayName}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MessageScreen(userId: user?.uid, numberOfUnseenMessages: 0,)),
          );
        },
      ),
    );
  }
}

