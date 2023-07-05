import 'package:chatapp/const.dart';
import 'package:chatapp/screens/widgets/searchbar.dart';
import 'package:chatapp/screens/widgets/user_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

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
                  child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return const UserTile();
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                              ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


