import 'dart:async';
import 'package:chatapp/screens/login_or_register_screen.dart';
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
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [primaryColor, accentColor],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: const Center(
          child: SizedBox(
            height: 500.0,
            width: 500.0,
            child: Center(
              child: null,
            ),
          ),
        ),
      ),
    );
  }
}
