import 'package:chatapp/shared/const.dart';
import 'package:chatapp/screens/home/widgets/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../services/database.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService(); // instance of the AuthService class 
  final DatabaseService database = DatabaseService();
  String? reciverName;
  ChatUser? user;


  getName(otherMember) { // user2
      FirebaseFirestore.instance.collection('users').doc(otherMember).get().then(
        (snapshot) {
          setState(() {
          user = ChatUser(uid: snapshot["uid"], displayName: snapshot["fullName"], email: snapshot["email"], profilePic: snapshot["profilePic"]);
          });
        } 
      );
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

                // notify us of new action done to the conversation  
                StreamBuilder<QuerySnapshot>(
                    stream: DatabaseService().conversations,
                    builder: (context, snapshot){
                      
                    if(!snapshot.hasData){
                      return const CircularProgressIndicator();
                    }

                    List<QueryDocumentSnapshot<Object?>>? converstions = snapshot.data?.docs.reversed.toList();
                    List<UserTile> conversationsList = [];

                    for(var converstion in converstions!){
                      print(converstion);
                      // dynamic newList = converstion.get('members'); // [user1, user2] 
                      // newList.remove(_auth.user!.uid); // [user2] remove member if he is the current user

                      // getName(newList[0]);
                    
          
                      // final userTile = UserTile(
                      //   lastMessage: '${converstion.get('messages')['1']['text']}',
                      //   userName: 'frined',
                      //   user: user,
                      // );


                      // conversationsList.add(userTile);
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





