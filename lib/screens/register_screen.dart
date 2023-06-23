import 'package:chatapp/screens/home_screen.dart';
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
                SizedBox(
                  width: 300,
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
                  width: 300,
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
                  width: 300,
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
                  width: 300,
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
                          color: Theme.of(context).primaryColorDark,
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

                const SizedBox(height: 20,),
      
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                  },
                  child: const Text("Register"),
                ),
      
              ],
            )
          ),
      ),
    );
  }
}