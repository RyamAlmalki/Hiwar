import 'package:chatapp/models/conversation.dart';
import 'package:chatapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../shared/const.dart';
import 'package:chatapp/screens/home/message_screen.dart';
import 'package:intl/intl.dart';

class ConversationTile extends StatelessWidget {
  ConversationTile({super.key, required this.conversation, this.user});
  Conversation conversation;
  ChatUser? user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(conversation.lastMessage, maxLines: 1, overflow: TextOverflow.clip, softWrap: false,  style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 15),)),
              conversation.numberOfUnseenMessages != 0 ? CircleAvatar(
                radius: 10,
                backgroundColor: primaryColor, 
                child:  Padding(
                  padding:  const EdgeInsets.all(1.0),
                  child:  Text('${conversation.numberOfUnseenMessages}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              ) : CircleAvatar(backgroundColor: background, radius: 10,),
            ],
          ),
        ), 
        tileColor: background,
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(conversation.profilePic ?? '') ,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${conversation.fullName}', softWrap: true, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
            Text(DateFormat('EEEE').format(conversation.date), style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
          ],
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MessageScreen(chatId: conversation.id, user: user, numberOfUnseenMessages: conversation.numberOfUnseenMessages,)),
          );
        },
      ),
    );
  }
}