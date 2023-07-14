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
    messageStream();
    super.initState();
  }

  void messageStream() async {
    await for( var snapshot in FirebaseFirestore.instance
    .collection('messages')
    .snapshots()){
      for(var message in snapshot.docs){
        print(message.data());
      }
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
            Expanded(child: ListView(scrollDirection: Axis.horizontal,)),
            
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

