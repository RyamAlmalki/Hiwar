import 'dart:async';
import 'package:chatapp/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  
  _SplashScreenState(){
    Timer(const Duration(milliseconds: 2000), (){
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginOrRegister()), (route) => false);
      });
    });

     Timer(
      const Duration(milliseconds: 10),(){
        setState(() {
          _isVisible = true; // Now it is showing fade effect and navigating to Login page
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Image.asset('assets/images/logo3.png'),
        ),
      ),
    );
  }
}
