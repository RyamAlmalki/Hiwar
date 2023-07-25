import 'package:chatapp/screens/home/widgets/user_message_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../shared/const.dart';


class MessageScreen extends StatefulWidget {
  String? chatId;
  ChatUser? user;
  MessageScreen({super.key, this.chatId, this.user});
  
  @override
  State<MessageScreen> createState() => _MessageScreentState();
}

class _MessageScreentState extends State<MessageScreen> {
  int numberOfMessages = 0;
  final DatabaseService database = DatabaseService();
  final messageTextConroller = TextEditingController();
  String? messageText;
  bool forBool = false;

  sendMessage() async {
    if(widget.chatId == null){
      // create a conversation 
      String newConversationId = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createConveration(widget.user!.uid);
      widget.chatId = newConversationId;

      // set the chatId to this conversation 
      setState(() {
        widget.chatId = newConversationId;
      });
      
      // take each user and add the conversation 

      // update message
      DatabaseService().addMessage(widget.chatId, messageText, numberOfMessages);
    }else{
      DatabaseService().addMessage(widget.chatId, messageText, numberOfMessages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
      child: Column(
        children: [
        const UserMessageTile(),

        widget.chatId != null? StreamBuilder(
        stream: DatabaseService().messages(widget.chatId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
                List<Message> messages = [];

                if(snapshot.hasData){
                  DocumentSnapshot<Object?>? messagesSnapshot = snapshot.data;
                  Map messagesMap = messagesSnapshot!.get('messages');
                  numberOfMessages = messagesMap.length;

                  for (var message in messagesMap.values) {
                    messages.add(Message(message: message['text'], senderId: message['senderId']));
                  }
                 
                  return Expanded(
                    child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: MessageBubble(message: messages[index]),
                        );
                      },
                    ),
                  );
                }else{
                  return const Expanded(child: CircularProgressIndicator());
                }
              }
            ): Expanded(child: Container()),
            
      

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 40,
                    child: TextField(
                      controller: messageTextConroller,
                      style: TextStyle(color:textColor), 
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: forBool ? null : "Type your message...",
                        hintStyle: TextStyle(color: textColor),
                        prefixIcon: Icon(Icons.search, color: textColor,),
                        filled: true,
                        fillColor: accentColor, 
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: textColor,
                  ),
                  onPressed: () {
                    setState(() {
                      messageText = messageTextConroller.text;
                    });

                    messageTextConroller.clear(); 
                    sendMessage();
                  },
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({super.key, required this.message});
  Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: message.senderId == message.senderId ? CrossAxisAlignment.end : CrossAxisAlignment.start, 
        children: [
          Text('${message.senderId}', style: TextStyle(color: textColor, fontSize: 12),),
          Material(
            color: message.senderId == FirebaseAuth.instance.currentUser!.uid ? primaryColor : Colors.white,
            elevation: 5,
            borderRadius: BorderRadius.only(topLeft:   message.senderId == FirebaseAuth.instance.currentUser!.uid! ? Radius.circular(30.0) : Radius.circular(0.0), bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), topRight:  message.senderId == FirebaseAuth.instance.currentUser!.uid! ? Radius.circular(0.0) : Radius.circular(30.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  '${message.message}', 
                  style:  TextStyle(color: message.senderId == FirebaseAuth.instance.currentUser!.uid! ? Colors.white: Colors.black, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

