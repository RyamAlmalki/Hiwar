import 'package:chatapp/screens/widgets/user_message_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../const.dart';

final user = FirebaseAuth.instance.currentUser!;
final messages = FirebaseFirestore.instance.collection('messages');


class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreentState();
}

class _MessageScreentState extends State<MessageScreen> {
  
  final messageTextConroller = TextEditingController();
  String? messageText;
  bool ForBool = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
      child: Column(
        children: [
            const UserMessageTile(),

            MessageStream(messageText: messageText,),
            
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
                        hintText: ForBool ? null : "Type your message...",
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
                        // text + sender mail 
                       messages
                        .add({
                          'text': messageText, // John Doe
                          'sender': user.email, // Stokes and Sons
                          'date': DateTime.now()
                        })
                        .then((value) => print("message Added"))
                        .catchError((error) => print("Failed to add message: $error"));
                        messageTextConroller.clear();
                      }
                    );
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


class MessageStream extends StatelessWidget {
  MessageStream({super.key, this.messageText});
  final ScrollController _controller = ScrollController();
  String? messageText;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
      .collection('messages').orderBy('date')
      .snapshots(),
      builder: (context, snapshot){
        List<MessageBubble> messageBubbles = [];
        if(!snapshot.hasData){
          return const CircularProgressIndicator();
        }
          List<QueryDocumentSnapshot<Object?>>? messages = snapshot.data?.docs.reversed.toList();
          
          for(var message in messages!){
            final messageText = message.get('text');
            final messageSender = message.get('sender');

            final messageBubble = MessageBubble(
              sender: messageSender, 
              text: messageText,
              isMe: user.email == messageSender,
              );
            messageBubbles.add(messageBubble);
          }
        
          return Expanded(
            child: ListView.builder(
            reverse: true,
            itemCount: messageBubbles.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: messageBubbles[index],
                );
              },
            ),
          );
      }
    );
  }
}


class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, this.sender, this.text, this.isMe});
  final String? sender;
  final String? text;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: user.email == sender ? CrossAxisAlignment.end : CrossAxisAlignment.start, 
        children: [
          Text('$sender', style: TextStyle(color: textColor, fontSize: 12),),
          Material(
            color: isMe! ? primaryColor : Colors.white,
            elevation: 5,
            borderRadius: BorderRadius.only(topLeft:  isMe! ? Radius.circular(30.0) : Radius.circular(0.0), bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), topRight:  isMe! ? Radius.circular(0.0) : Radius.circular(30.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  '$text', 
                  style:  TextStyle(color: isMe! ? Colors.white: Colors.black, fontSize: 15),
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

