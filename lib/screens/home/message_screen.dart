import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/home/widgets/user_message_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import '../../shared/const.dart';

final user = FirebaseAuth.instance.currentUser!;
final messages = FirebaseFirestore.instance.collection('messages');


class MessageScreen extends StatefulWidget {
  ChatUser? reciver;
  MessageScreen({super.key, required this.reciver});
  
  @override
  State<MessageScreen> createState() => _MessageScreentState();
}

class _MessageScreentState extends State<MessageScreen> {
  final DatabaseService database = DatabaseService();
  final messageTextConroller = TextEditingController();
  String? messageText;
  bool ForBool = false;
  dynamic conversation;
  final AuthService _auth = AuthService(); // instance of the AuthService class 
  
  @override
  void initState() {
    getConversation();
    super.initState();
  }

  getConversation() async {
    try{
      dynamic result = await database.gettingConversation(widget.reciver!.uid, _auth.user!.uid);

      setState(() {
        conversation = result;
      });
    }catch(e){
      print(e);
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
                  onPressed: () async {
                    print(conversation);
                    if(conversation == null){
                        await database.createConveration(widget.reciver!.uid, _auth.user!.uid);
                        getConversation();
                      }

                    setState(() {
                       messageText = messageTextConroller.text;
                      // if this the first conversation between the two a new converstion collection will be created 
                      
                      print(conversation.get('messages')!);

                      database.conversationsCollection.doc('LNXO3SEsiJ4FdcDqIbv4').update(
                        {
                           "messages.{}": {
                            'text': 'hi',
                           },
                          }
                  
                      )
                      ;




                        // {
                        //   messages: {
                        //     'text': messageText, // John Doe
                        //     'senderId': user.uid, // Stokes and Sons
                        //     'type': 'text',
                        //     'date': DateTime.now()
                        //   }
                        // },
                        // SetOptions(merge: true));

                        // if this is not the first converstion between the two then add to message 
                        //messageText = messageTextConroller.text;
                          // text + sender mail 
                          // messages
                          //   .add({
                          //     'text': messageText, // John Doe
                          //     'sender': user.email, // Stokes and Sons
                          //     'reciver': 'test@gmail.com',
                          //     'date': DateTime.now()
                          //   })
                          //   .then((value) => print("message Added"))
                          //   .catchError((error) => print("Failed to add message: $error"));

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

  // here i should find the collection between the two and display the text between them 
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

