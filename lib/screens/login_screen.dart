import 'package:chatapp/screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../const.dart';
import 'home_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  TextEditingController emailForm = TextEditingController();
  TextEditingController passwordForm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                      
                    Hero(
                    tag: "logo",
                    child: SizedBox(
                      height: 100,
                      child: Center(child: Text('Teddybud', style: TextStyle(decoration: TextDecoration.none, fontSize: 50, fontWeight: FontWeight.bold, color: primaryColor, backgroundColor: Colors.transparent, ), )),
                        )
                    ),

                      
                      const SizedBox(height: 50,),

                      SizedBox(
                        width:350,
                        child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: emailForm,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your Email',
                            ),
                          ),
                      ),

                      SizedBox(
                        width: 350,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordForm,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: primaryColor,
                              ),
                              onPressed: () {
                            
                                setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  }
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 50,),

                    SizedBox(
                      width: 340,
                      height: 50,
                      child: DecoratedBox( 
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            accentColor
                            //add more colors
                          ]),
                        ),
                        child:ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              //make color or elevated button transparent
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                          },
                          child: const Text("Login"),
                        ),
                    ),
                    ),
                     
                    const SizedBox(height: 10,),

                    TextButton(
                      onPressed: (){
                         Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),);
                    }, 
                    child: RichText(
                    text: TextSpan(
                          text: "Have an account? ",
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black, backgroundColor: Colors.transparent, ),
                          children: <TextSpan>[
                            TextSpan(text: 'Register', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: primaryColor, backgroundColor: Colors.transparent, ),),
                          ],
                        ),
                      ),
                    )
                ],
              )
            ),   
          ],
        ),
      ),
    );
  }
}

