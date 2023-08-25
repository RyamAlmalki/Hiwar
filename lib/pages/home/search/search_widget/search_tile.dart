import 'package:chatapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../services/database.dart';
import '../../../../shared/const.dart';
import '../../message/message_screen.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({super.key, required this.user});
  final ChatUser? user;

  setup(context) async {
    String id = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createConveration(user!.uid); 

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  MessageScreen(newconversation: true, userId: user?.uid, numberOfUnseenMessages: 0, newUser: true, chatId: id,)),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('${user?.username}', style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 15),),
        ),
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          radius: 30,
          backgroundImage: NetworkImage(user!.photoURL ?? '') ,
          child: user?.photoURL == "" ? Text(user!.displayName![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),) : null,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
        title: Text('${user?.displayName}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
        onTap: () {
         setup(context);
        },
      ),
    );
  }
}