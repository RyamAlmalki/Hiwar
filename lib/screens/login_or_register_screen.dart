import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/register_screen.dart';
import 'package:chatapp/screens/widgets/button.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                ElevatedButton(
                style: buttonStyle(),
                onPressed: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }, 
                child: const Text('Login', style: TextStyle(
                    color: Colors.black,
                    fontSize: 20, 
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),

              const SizedBox(height: 10,),

              ElevatedButton(
                style: buttonStyle(),
                onPressed: (){
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                }, 
                child: const Text('Register', style: TextStyle(
                    color: Colors.black,
                    fontSize: 20, 
                    fontStyle: FontStyle.normal,
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
