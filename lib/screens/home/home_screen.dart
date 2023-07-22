import 'package:chatapp/screens/home/message_screen.dart';
import 'package:chatapp/shared/const.dart';
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
            TextButton(
              onPressed: () async{
                 Navigator.of(context).pushReplacementNamed('profileScreen');
              },
              child: const CircleAvatar(
                radius: 19,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
              
            const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            
            SizedBox(
              width: 60,
              child: CircleAvatar(
                radius: 19,
                backgroundColor: accentColor, 
                child: IconButton(
                icon:  const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () async{
                    Navigator.of(context).pushReplacementNamed('searchScreen');
                  },
                ),
              ),
            ),    
          ],
        ), 
        centerTitle: false, 
        backgroundColor:background, 
        elevation: 1,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children:  [
                StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                .collection('conversations')
                .snapshots(),
                builder: (context, snapshot){
                  List<UserTile> conversationsList = [];
                  if(!snapshot.hasData){
                    return const CircularProgressIndicator();
                  }
                    List<QueryDocumentSnapshot<Object?>>? converstions = snapshot.data?.docs.reversed.toList();
                    
                    for(var converstion in converstions!){
                      for(var member in converstion.get('members')){
                        if(member == _auth.user!.uid){ // if the user is part of a conversation then 
                          final userTile = UserTile(
                            lastMessage: 'we',
                            userName: 'friend'
                        );
                        conversationsList.add(userTile);
                        }
                      }
                     }
                  
                    return Expanded(
                      child: ListView.builder(
                      itemCount: conversationsList.length,
                      itemBuilder: (context, index) {
                        return conversationsList[index];
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


