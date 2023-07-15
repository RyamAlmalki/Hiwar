import 'package:chatapp/screens/widgets/user_message_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../const.dart';


class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreentState();
}

class _MessageScreentState extends State<MessageScreen> {
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');
  final user = FirebaseAuth.instance.currentUser!;
  
  String? messageText;
  bool ForBool = false;

  @override
  void initState() {

    super.initState();
  }

  // flutter is being notified of anychages vie the stream of data snapshot 
  // void messageStream() async {
  //   await for( var snapshot in FirebaseFirestore.instance
  //   .collection('messages')
  //   .snapshots()){
  //     for(var message in snapshot.docs){
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
      child: Column(
        children: [
            const UserMessageTile(),

            
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
              .collection('messages')
              .snapshots(),
              builder: (context, snapshot){
                List<MessageBubble> messageBubbles = [];
                if(!snapshot.hasData){
                  return const CircularProgressIndicator();
                }
                  List<QueryDocumentSnapshot<Object?>>? messages = snapshot.data?.docs;
                  
                  for(var message in messages!){
                    final messageText = message.get('text');
                    final messageSender = message.get('sender');

                    final messageBubble = MessageBubble(sender: messageSender, text: messageText,);
                    messageBubbles.add(messageBubble);
                  }
                
                 return Expanded(
                   child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: messageBubbles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: messageBubbles[index],
                        );
                      },
                    ),
                 );
              }
            ),
            
            
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 40,
                    child: TextField(
                      
                      style: TextStyle(color:textColor), 
                      decoration: InputDecoration(
                        hintText: ForBool ? null : "Search...",
                        hintStyle: TextStyle(color: textColor),
                        prefixIcon: Icon(Icons.search, color: textColor,),
                        filled: true,
                        fillColor: accentColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: background), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(50.0),
                        ),      
                      ),
                      onChanged: (value) {
                        if (value.length <= 0) {
                          setState(() {
                            ForBool = false;
                          });
                        } else {
                          setState(() {
                            ForBool = true;
                          });
                        }
                        
                          messageText = value;
                      },
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
                        // text + sender mail 
                       messages
                        .add({
                          'text': messageText, // John Doe
                          'sender': user.email, // Stokes and Sons
                        })
                        .then((value) => print("message Added"))
                        .catchError((error) => print("Failed to add message: $error"));
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

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, this.sender, this.text});
  final String? sender;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$sender', style: TextStyle(color: textColor, fontSize: 12),),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
              '$text', 
              style:  const TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}