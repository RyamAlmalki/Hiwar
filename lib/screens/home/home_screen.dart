import 'package:chatapp/const.dart';
import 'package:chatapp/screens/home/widgets/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService(); // instance of the AuthService class 
  
  Future singout() async {
    _auth.signout();
    Navigator.of(context).pushReplacementNamed('loginScreen');
  }

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
              onPressed: () async{
                await singout();
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
                      if(message.get('reciver') == _auth.user?.email){
                        final userTile = UserTile(
                          lastMessage: message.get('text'),
                          userName: message.get('sender'),
                        );
                         messageBubbles.add(userTile);
                      }
                      if(message.get('sender') == _auth.user?.email){
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


