import 'package:chatapp/models/conversation.dart';
import 'package:chatapp/shared/const.dart';
import 'package:chatapp/screens/home/widgets/conversation_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';


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
            TextButton(
              onPressed: () async{
                 Navigator.of(context).pushReplacementNamed('profileScreen');
              },
              child: const CircleAvatar(
                radius: 19,
                backgroundImage: AssetImage('assets/images/profile.png'), // should show the user image
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
            children: [
                  // Here we will retrive all the users conversations
                  StreamBuilder<List<Conversation>?>(
                  stream: DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).conversations,
                  builder: (context, snapshot){
                    print(snapshot);
                    if(snapshot.hasData){
                    List<Conversation>? conversations = snapshot.data;

                    return Expanded(
                        child: ListView.builder(
                        itemCount: conversations?.length,
                        itemBuilder: (context, index) {
                          Conversation conversation = conversations!.elementAt(index);
                          return ConversationTile(conversation: conversation);
                        },
                      ),
                    );
                  }else{
                    return const Text('No Frineds :(', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),);
                  }
                }
              ),
            ],   
          ),
        ),
      ),
    );
  }
}





