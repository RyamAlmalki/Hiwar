import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/home/widgets/search_tile.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/shared/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  String? searchResult;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, ),
          onPressed: () {
             Navigator.of(context).pushReplacementNamed('homeScreen');
          },
        ),
        title: Container(
          width: double.infinity,
          height: 50,
          decoration:  BoxDecoration(
            color: accentColor, borderRadius: BorderRadius.circular(40)),
          child: Center(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchResult = value;
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white,),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white,),
                  onPressed: () {
                    searchController.clear();
                  },
                ),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white, fontSize: 17),
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
              stream: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).users(searchResult),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  List<ChatUser>? users = snapshot.data;

                  return Expanded(
                      child: ListView.builder(
                      itemCount: users?.length,
                      itemBuilder: (context, index) {
                        ChatUser user = users!.elementAt(index);
                        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getSearchConversation(user.uid);
                        // have to check if i have conversation with this user 


                        return SearchTile(user: user);
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







