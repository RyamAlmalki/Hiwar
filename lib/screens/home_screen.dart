import 'package:chatapp/const.dart';
import 'package:chatapp/screens/widgets/searchbar.dart';
import 'package:chatapp/screens/widgets/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


final user = FirebaseAuth.instance.currentUser!;

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
            const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            IconButton(
              icon: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('loginScreen');
                  }
                );
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
                const SearchBar(),
                Expanded(
                child: ListView.builder(
    
                itemCount: 4,
                itemBuilder: (context, index) {
                  return UserTile();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


