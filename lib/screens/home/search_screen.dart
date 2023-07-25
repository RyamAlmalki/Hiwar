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
              onChanged: (value) {
                setState(() {
                  searchResult = value;
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
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
              stream: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).users(searchResult),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  List<ChatUser>? users = snapshot.data;

                  return Expanded(
                      child: ListView.builder(
                      itemCount: users?.length,
                      itemBuilder: (context, index) {
                        ChatUser user = users!.elementAt(index);
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







