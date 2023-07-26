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
        subtitle: Text('${user?.email}', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 10),),
        tileColor: background,
        leading: const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        title: Text('${user?.displayName}', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MessageScreen(user: user, numberOfUnseenMessages: 0,)),
          );
        },
      ),
    );
  }
}

