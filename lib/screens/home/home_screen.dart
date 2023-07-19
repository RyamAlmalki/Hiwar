import 'package:chatapp/const.dart';
import 'package:chatapp/screens/home/widgets/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


final user = FirebaseAuth.instance.currentUser!;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            IconButton(
              icon: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('loginScreen');
                  }
                );
              },
            ),
          ],
        ), 
        centerTitle: false, 
        backgroundColor:background, 
        elevation: 0,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children:  [
                StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                .collection('messages').orderBy('date')
                .snapshots(),
                builder: (context, snapshot){
                  List<UserTile> messageBubbles = [];
                  if(!snapshot.hasData){
                    return const CircularProgressIndicator();
                  }
                    List<QueryDocumentSnapshot<Object?>>? messages = snapshot.data?.docs.reversed.toList();
                    
                    for(var message in messages!){
                      if(message.get('reciver') == user.email){
                        final userTile = UserTile(
                          lastMessage: message.get('text'),
                          userName: message.get('sender'),
                        );
                         messageBubbles.add(userTile);
                      }
                      if(message.get('sender') == user.email){
                        final userTile = UserTile(
                          lastMessage: message.get('text'),
                          userName: message.get('reciver'),
                        );
                         messageBubbles.add(userTile);
                      }
                    }
                  
                    return Expanded(
                      child: ListView.builder(
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
            ],
          ),
        ),
      ),
    );
  }
}


