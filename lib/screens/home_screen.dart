import 'package:chatapp/const.dart';
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
      appBar: AppBar(title: const Text('Messages'),),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${user.email}' ,style: const TextStyle(color: Colors.white),),
            MaterialButton(
              color: primaryColor,
              child: Text('Sign Out'),
              onPressed: (() {
                FirebaseAuth.instance.signOut();
              }
            ))
          ],
        ),
      ),
    );
  }
}