import 'package:chatapp/pages/home/home_page.dart';
import 'package:chatapp/pages/authenticate/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    //Set up a stream between our flutter app and the firebase Auth Service.
    //The firebase Auth service will emit something to us every time the user
    //either signs in or signs out. And that something can be a Null value or a User object. 
    //And based on the value our flutter app can determin whether they're logged in or logged out.
    //and at that moment we want to update UI appropriately.

    return Scaffold(
      // FirebaseUser 
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

