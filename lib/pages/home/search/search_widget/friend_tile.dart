import 'package:flutter/material.dart';

import '../../../../models/conversation.dart';
import '../../../../shared/const.dart';
import '../../message/message_screen.dart';



class FriendTile extends StatelessWidget {

  const FriendTile({super.key, required this.conversation});
  final Conversation? conversation;

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('${conversation?.email}', style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 15),),
        ),
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          radius: 30,
          backgroundImage: NetworkImage(conversation!.profilePic) ,
          child: conversation?.profilePic == "" ? Text(conversation!.fullName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),) : null,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
        title: Text('${conversation?.fullName}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MessageScreen(userId: conversation?.userId, numberOfUnseenMessages: 0, lastSavedConversationDate: conversation?.lastSavedConversationDate, chatId: conversation?.id, conversation: conversation, newUser: false,)),
          );
        },
      ),
    );
  }
}

