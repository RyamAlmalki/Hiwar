import 'package:chatapp/models/conversation.dart';
import 'package:flutter/material.dart';
import '../../../shared/const.dart';
import 'package:chatapp/screens/home/message_screen.dart';

class ConversationTile extends StatelessWidget {
  ConversationTile({super.key, this.conversation});
  Conversation? conversation;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(conversation!.lastMessage, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.normal, fontSize: 15),),
              CircleAvatar(
                radius: 10,
                backgroundColor: primaryColor, 
                child:  const Padding(
                  padding:  EdgeInsets.all(1.0),
                  child:  Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ), 
        tileColor: background,
        leading: const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/profile.png'),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${conversation!.fullName}', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
            Text('Tue', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
          ],
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MessageScreen(chatId: conversation?.id,)),
          );
        },
      ),
    );
  }
}