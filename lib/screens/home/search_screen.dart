import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/home/message_screen.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/shared/const.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final myController = TextEditingController();
  
  final DatabaseService database = DatabaseService();
  final AuthService _auth = AuthService(); // instance of the AuthService class 
  ChatUser? user;

  Future getSearch() async {
    dynamic snapshot= await database.gettingUserData(myController.text);
    
    try{
      if(snapshot != null){
        setState(() {
          user = ChatUser(uid: snapshot["uid"], displayName: snapshot["fullName"], email: snapshot["email"], profilePic: snapshot["profilePic"]);
        });
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, ),
          onPressed: () {
             Navigator.of(context).pushReplacementNamed('homeScreen');
          },
        ),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration:  BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
        
              onTap: () async {
                // search for email in data base and get name and profile 
                getSearch();
              },
              controller: myController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    myController.clear();
                  },
                ),
                hintText: 'Search',
                border: InputBorder.none
              ),
            ),
          ),
        ),
      ),
      body: user != null ? Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: ListTile(
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text('${user?.email}', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.normal, fontSize: 15),),
                    ), 
                    tileColor: background,
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    title: Text('${user?.displayName}', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
                    onTap: (){
                      // when this user clicks on this name he will move to the message screen 
                      // with this users data 
                      // if this user doesnt have any conversation with him it will show 
                      // if he send a message a converstion will be created for them 
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  MessageScreen(reciver: user,)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ) : null
    );
  }
}
