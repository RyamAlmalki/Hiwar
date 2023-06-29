import 'package:chatapp/screens/register_screen.dart';
import 'package:chatapp/screens/widgets/background.dart';
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
      backgroundColor: background,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(  
          children: [
            const LineBackground(),
            
            
            Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: MediaQuery.of(context).size.width / 10,
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    
                  
                  Hero(
                  tag: "logo",
                    child: SizedBox(
                      height: 100,
                      child: Center(child: Image.asset('assets/images/logo3.png'),),
                        )
                    ),
                    
                    const SizedBox(height: 20,),
            
                    
                    SizedBox(
                      width:350,
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: emailForm,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: accentColor,
                            enabledBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: textColor, width: 0),
                            ),
                            labelStyle: TextStyle(color: textColor),
                            labelText: 'First Name',
                            hintText: 'Enter your Email',
                          ),
                        ),
                    ),
                  
                    const SizedBox(height: 20,),

                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordForm,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: accentColor,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor, width: 0),
                            ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: textColor),
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: textColor,
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
                    width: 300,
                    height: 50,       
                    child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(29))),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white
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
                   
                  const SizedBox(height: 200,),
                  
                  TextButton(
                    onPressed: (){
                       Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),);
                  }, 
                  child: RichText(
                  text: const TextSpan(
                        text: "Have an account?",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white, backgroundColor: Colors.transparent, ),
                        children: <TextSpan>[
                          TextSpan(text: ' Register', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white, backgroundColor: Colors.transparent, ),),
                        ],
                      ),
                    ),
                  ),


                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}

