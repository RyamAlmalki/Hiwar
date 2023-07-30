import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../shared/const.dart';


class MessageScreen extends StatefulWidget {
  String? chatId;
  ChatUser? user;
  int numberOfUnseenMessages = 0;
  MessageScreen({super.key, this.chatId, this.user, required this.numberOfUnseenMessages});
  
  @override
  State<MessageScreen> createState() => _MessageScreentState();
}

class _MessageScreentState extends State<MessageScreen> {
  int numberOfMessages = 0;
  final DatabaseService database = DatabaseService();
  final messageTextConroller = TextEditingController();
  String? messageText;
  bool forBool = false;
  bool hasText = false;

  sendMessage() async {
    if(widget.chatId == null){
      // create a conversation 
      String newConversationId = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createConveration(widget.user!.uid);
      widget.chatId = newConversationId;

      // set the chatId to this conversation 
      if (this.mounted) {
        setState(() {
           widget.chatId = newConversationId;
        });
      }
      
      // add the new conversation to sender 
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createUserConversation(widget.chatId, widget.user?.photoURL, widget.user?.displayName , messageText, widget.user?.uid);

      // add the new conversation to the reciver 
      DatabaseService(uid: widget.user!.uid).createUserConversation(widget.chatId, FirebaseAuth.instance.currentUser?.photoURL, FirebaseAuth.instance.currentUser?.displayName, messageText, FirebaseAuth.instance.currentUser?.uid);

      // update message
      DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).addMessage(widget.chatId, messageText, FirebaseAuth.instance.currentUser?.displayName);
      
    }else{

      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).addMessage(widget.chatId, messageText, FirebaseAuth.instance.currentUser?.displayName);

      // update user last message + last message day 
      DatabaseService().updateLastMessage(widget.chatId, FirebaseAuth.instance.currentUser!.uid, messageText);

      DatabaseService().updateLastMessage(widget.chatId, widget.user!.uid, messageText);

      // update the last unseen message for the other user who didn't send the message 
      updateLastUnseenMessage();
    }
  }

  updateLastUnseenMessage(){
    setState(() {
        widget.numberOfUnseenMessages += 1;
      });

     // update
      DatabaseService().updateLastUnseenMessage(widget.chatId, widget.user!.uid, widget.numberOfUnseenMessages);
  }


  @override
  void initState() {
    // update last seem message 
    resetLastUnseenMessage();
    super.initState();
  }

  resetLastUnseenMessage(){
    setState(() {
      widget.numberOfUnseenMessages = 0;
    });

     // update user last message + last message day + add to number of last seen message 
      DatabaseService().updateLastUnseenMessage(widget.chatId, FirebaseAuth.instance.currentUser!.uid, widget.numberOfUnseenMessages);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
            IconButton(
              icon: Icon(
                
                Icons.arrow_back_ios,
                color: textColor,
                size: 30,
                
              ),
              onPressed: () {
                 Navigator.of(context).pushReplacementNamed('homeScreen');
              },
            ),
            
              TextButton(
              onPressed: () async{
                  //Navigator.of(context).pushReplacementNamed('homeScreen');
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.user!.photoURL ?? '') , // should show the user image
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${widget.user?.displayName}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), 
              ],
            ),
          ],
        ), 
        centerTitle: false, 
        backgroundColor:background, 
        elevation: 0,
      ),
      body: SafeArea(
      child: Column(
        children: [

            StreamBuilder<List<Message>?>(
              stream: DatabaseService().messages(widget.chatId),
              builder: (context, snapshot){

                if(snapshot.hasData){
                  List<Message>? messages = snapshot.data?.reversed.toList();
              

                  return Expanded(
                      child: ListView.builder(
                      reverse: true,
                      itemCount: messages?.length,
                      itemBuilder: (context, index) {
                        Message message = messages!.elementAt(index);
           
                        return MessageBubble(message: message, isMe: message.senderId == FirebaseAuth.instance.currentUser!.uid);
                      },
                      
                    ),
                  );
                }else{
                  return const Expanded(child: CircularProgressIndicator());
                }
              }
            ),
            
            

            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 1),
              child: TextField(
                onChanged: (value) {
                  value.isNotEmpty ? setState(() => hasText = true) : setState(() => hasText = false);
                },
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.multiline,
                controller: messageTextConroller,
                style: TextStyle(color:textColor), 
                
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(50),
                    borderSide:  BorderSide(
                      color: primaryColor , 
                      width: 0.5
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.transparent)
                  ),
                  hintText: forBool ? null : "Send Message...",
                  hintStyle: TextStyle(color: textColor),
                  filled: true,
                  fillColor: accentColor, 
                  prefixIcon: !hasText ?      
                    IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: textColor
                    ),
                    onPressed: () {
                      
                    },
                  ): IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white10
                    ),
                    onPressed: () {
                      
                    },
                  ),
                  suffixIcon: hasText ? 
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: textColor
                    ),
                    onPressed: () {
                      setState(() {
                        messageText = messageTextConroller.text;
                      });
                                
                      messageTextConroller.clear(); 
                      sendMessage();
                    },
                  ): IconButton(
                    icon: Icon(
                      Icons.mic,
                      color: textColor
                    ),
                    onPressed: () {
                      
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({super.key, required this.message, required this.isMe});
  Message message;
  bool isMe;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, 
        children: [
          //Text('${message.senderName}', style: TextStyle(color: Colors.white, fontSize: 12),),
          Material(
            
            color: isMe? bubbleColor : accentColor,
            elevation: 0,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0) , bottomRight: const Radius.circular(30.0), bottomLeft: const Radius.circular(30.0), topRight:   const Radius.circular(30.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    '${message.message}', 
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style:  TextStyle(color: isMe ? Colors.white: Colors.white, fontSize: 16),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Text(DateFormat.jm().format(message.date), style:  TextStyle(color:  Colors.white, fontSize: 10, fontWeight: FontWeight.bold), ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


