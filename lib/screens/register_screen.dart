import 'package:chatapp/const.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  TextEditingController emailForm = TextEditingController();
  TextEditingController passwordForm = TextEditingController();
  TextEditingController firstNameForm = TextEditingController();
  TextEditingController lastNameForm = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  width: 350,
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: emailForm,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter your first name',
                      ),
                    ),
                ),
                
                const SizedBox(height: 20,),
                
                SizedBox(
                  width: 350,
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: emailForm,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                      ),
                    ),
                ),
                
                const SizedBox(height: 20,),

                SizedBox(
                  width: 350,
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: emailForm,
                      decoration: const InputDecoration(
                        labelText: 'Email',
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
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          // Update the state i.e. toggle the state of passwordVisible variable
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
                          child: const Text("Register"),
                        ),
                    ),
                  ),

                const SizedBox(height: 10,),

                TextButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginOrRegister()),);
                }, 
                child: RichText(
                    text: TextSpan(
                      text: "Have an account? ",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black, backgroundColor: Colors.transparent, ),
                      children: <TextSpan>[
                        TextSpan(text: ' Login', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: primaryColor, backgroundColor: Colors.transparent, ),),
                      ],
                    ),
                  ),
                )
              ],
            )
          ),
      ),
    );
  }
}
