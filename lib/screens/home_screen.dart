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
      appBar: AppBar(title: const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),), centerTitle: false, backgroundColor:background, elevation: 0,),
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



// Text('${user.email}' ,style: const TextStyle(color: Colors.white),),
//             MaterialButton(
//               color: primaryColor,
//               child: Text('Sign Out'),
//               onPressed: (() {
//                 FirebaseAuth.instance.signOut();
//               }
//             ))