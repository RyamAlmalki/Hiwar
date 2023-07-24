import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/home/widgets/search_tile.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/shared/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<List<ChatUser>?>(
              stream: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).users,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  List<ChatUser>? users = snapshot.data;
                
                  return Expanded(
                      child: ListView.builder(
                      itemCount: users?.length,
                      itemBuilder: (context, index) {
                        return SearchTile(user: users?.elementAt(index));
                      },
                    ),
                  );
                }else{
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        )
      )
    );
  }
}







