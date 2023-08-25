import 'package:chatapp/models/conversation.dart';
import 'package:flutter/material.dart';
import '../../../shared/const.dart';
import 'package:chatapp/pages/home/message/message_screen.dart';
import 'package:intl/intl.dart';


class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, required this.conversation});
  final Conversation conversation;


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
              conversation.lastMessage != 'Photo' ? SizedBox(width: MediaQuery.of(context).size.width / 1.5 ,child: Text(conversation.lastMessage, maxLines: 1, overflow: TextOverflow.clip, softWrap: false,  style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 15),)) : 
                SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, color: textColor, size: 15,),
                      const SizedBox(width: 6,),
                      Text(conversation.lastMessage, maxLines: 1, overflow: TextOverflow.fade, softWrap: false,  style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 15),)
                    ],
                  ),
                ),
              conversation.numberOfUnseenMessages != 0 ? CircleAvatar(
                radius: 12,
                backgroundColor: primaryColor, 
                child:  Text('${conversation.numberOfUnseenMessages}', style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold,),),
              ) : const CircleAvatar(backgroundColor: Colors.black, radius: 0,),
            ],
          ),
        ), 
        tileColor: Colors.black,
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          radius: 30,
          backgroundImage: NetworkImage(conversation.profilePic) ,
          child: conversation.profilePic == "" ? Text(conversation.fullName[0].toUpperCase(), style:  TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),) : null,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(conversation.fullName, softWrap: true, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
            Text(DateFormat('EEE').format(conversation.date), style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15),),
          ],
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MessageScreen(conversation: conversation, newUser: false, chatId: conversation.id, userId: conversation.userId, numberOfUnseenMessages: conversation.numberOfUnseenMessages, lastSavedConversationDate: conversation.lastSavedConversationDate,)),
          );
        },
      ),
    );
  }
}