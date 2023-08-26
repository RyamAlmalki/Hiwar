import 'package:chatapp/models/conversation.dart';
import 'package:chatapp/pages/home/search/search_page.dart';
import 'package:chatapp/shared/const.dart';
import 'package:chatapp/pages/home/home_widget/conversation_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String>? myFriendsids = [];

  // We will get ids of everyone who have started conversation with this user 
  getFriendsIds() async {
    myFriendsids = await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).getConversationUserId();
  }

  @override
  void initState() {
    getFriendsIds();
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: accentColor, width: 1)
        ),
        automaticallyImplyLeading: false,
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 60,
              child: CircleAvatar(
                radius: 19,
                backgroundColor: accentColor, 
                child: IconButton(
                icon:  const Icon(
                    Icons.person_2,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () async{
                    Navigator.of(context).pushReplacementNamed('profileScreen');
                  },
                ),
              ),
            ),  
              
            const Text(
            'Messages', 
            style: TextStyle(
              fontWeight: 
              FontWeight.bold, 
              fontSize: 20),
            ),

            SizedBox(
              width: 60,
              child: CircleAvatar(
                radius: 19,
                backgroundColor: accentColor, 
                child: IconButton(
                icon:  const Icon(
                    Icons.search_sharp,
                    color: Colors.white,
                    size: 20,
                    weight: 10,
                  ),
                  onPressed: () async{
                    // ids will be passed to search screen 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen(names: myFriendsids)),
                    );
                  },
                ),
              ),
            ),    
          ],
        ), 
        centerTitle: false, 
        backgroundColor: Colors.black, 
        elevation: 0,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
                  // Here we will retrive all the users conversations
                  StreamBuilder<List<Conversation>?>(
                  stream: DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).conversations?.distinct(),
                  builder: (context, snapshot) {
                    
                    if(snapshot.hasData){
                    List<Conversation>? conversations = snapshot.data?.reversed.toList();

                    return Expanded(
                        child: ListView.separated(
                        itemCount: conversations!.length,
                        itemBuilder: (context, index) {
                        Conversation conversation = conversations.elementAt(index);
                        
                        return ConversationTile(conversation: conversation);
                          
                        }, separatorBuilder: (BuildContext context, int index) {  
                          return  Divider(
                            height: 20,
                            thickness: 1,
                            indent: 1,
                            endIndent: 0,
                            color: accentColor,
                          );
                        },
                      ),
                    );
                  }else{
                    // return loading page 
                    return Expanded(child: Container());
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





