import 'package:chatapp/screens/home/home_screen.dart';
import 'package:chatapp/screens/authenticate/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen for change
    // Return either Home or Authenticate Widget
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return const HomeScreen();
          }else{
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

