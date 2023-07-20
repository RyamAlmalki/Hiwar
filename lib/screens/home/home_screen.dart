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
            TextButton(
              onPressed: () async{
                 Navigator.of(context).pushReplacementNamed('profileScreen');
              },
              child: const CircleAvatar(
                radius: 19,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
              
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text('Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            ),
            
            
            SizedBox(
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: accentColor, 
                    child: IconButton(
                    icon:  const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () async{
                        await singout();
                      },
                    ),
                  ),

                 
                  CircleAvatar(
                    radius: 19,
                    backgroundColor: accentColor, 
                    child: IconButton(
                    icon:  const Icon(
                        Icons.person_add_alt_sharp,
                        color: Colors.white,
                        size: 25,
                      ),
                      onPressed: () async{
                        await singout();
                      },
                    ),
                  ),
                ],
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
                .collection('messages').orderBy('date')
                .snapshots(),
                builder: (context, snapshot){
                  List<UserTile> messageBubbles = [];
                  if(!snapshot.hasData){
                    return const CircularProgressIndicator();
                  }
                    List<QueryDocumentSnapshot<Object?>>? messages = snapshot.data?.docs.reversed.toList();
                    
                    for(var message in messages!){
                        final userTile = UserTile(
                          lastMessage: message.get('text'),
                          userName: message.get('sender'),
                        );
                        messageBubbles.add(userTile);
                     }
                  
                    return Expanded(
                      child: ListView.builder(
                      itemCount: 1,
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


