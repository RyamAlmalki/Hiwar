import 'package:chatapp/pages/authenticate/upload_image_screen.dart';
import 'package:chatapp/shared/const.dart';
import 'package:chatapp/pages/authenticate/auth_widget/background.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';


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
  TextEditingController usernameForm = TextEditingController();
  final AuthService _auth = AuthService(); // instance of the AuthService class 
  
    bool isStringOnlyLetters(String str) {
    return str.trim().isNotEmpty && str.split('').every((char) => RegExp(r'^[a-zA-Z]+$').hasMatch(char));
    }


   Future signUp() async{
     // loading circle 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );

    if(usernameForm.text.isNotEmpty && isStringOnlyLetters(usernameForm.text) && usernameForm.text.length <= 20){
      dynamic result = await _auth.register(emailForm, passwordForm, usernameForm); // dynamic because result can be null or User
    
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      emailForm.clear();
      passwordForm.clear();
      usernameForm.clear();

      if(result == 'usernameTaken'){
        // ignore: use_build_context_synchronously
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              title: Text('Register failed'),
              content: Text('Username is Taken'),
            );
          }
        );
      }else if(result == null){
        // ignore: use_build_context_synchronously
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              title: Text('Register failed'),
              content: Text('Invalid Email'),
            );
          }
        );
      }
      else{
        
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  UploadImageScreen(userId: result,)),
        );
      }
    }else{
      usernameForm.clear();
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Display Name Warning'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
              children: [
                Text('Make sure your display name is'),
                Text('Not empty'),
                Text('Only letters'),
                Text('No space'),
                Text('Not more than 20 char'),
              ],
            ),
          );
        }
      );






    }
   
  }


  @override
  void dispose() {
    emailForm.dispose();
    passwordForm.dispose();
    usernameForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(  
          children: [
            const AuthBackground(),
            
            Positioned(
            top: MediaQuery.of(context).size.height /4,
            left: MediaQuery.of(context).size.width / 10,
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Hero(
                        tag: "logo",
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 60,
                            child: Center(child: Image.asset('assets/images/big_logo.png'),),
                        )
                      ),
                        
                    
                      const SizedBox(height: 40,),
                

                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.text,
                            controller: usernameForm,
                            decoration: decorationStyles.copyWith(
                              labelText: 'Enter Username', 
                              prefixIcon: Icon(Icons.person, color: textColor,
                            ),
                          )
                        ),
                      ),

                      const SizedBox(height: 20,),
                      
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailForm,
                            decoration: decorationStyles.copyWith(
                              labelText: 'Enter Email', 
                              prefixIcon: Icon(Icons.email, color: textColor,),)
                          ),
                      ),

                      const SizedBox(height: 20,),
                      
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          controller: passwordForm,
                          obscureText: !_passwordVisible,
                          decoration: decorationStyles.copyWith(labelText: 'Enter Password', prefixIcon: Icon(Icons.lock, color: textColor,), 
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
                        width: MediaQuery.of(context).size.width / 1.4,
                        height: 50,       
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          onPressed: () async {
                            await signUp();
                          }, 
                          child: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold),),
                        )
                      ),
                    
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5 ,
                    ),
                    
                    TextButton(
                      onPressed: (){
                      Navigator.of(context).pushReplacementNamed('loginScreen');
                    }, 
                    child: RichText(
                    text:  TextSpan(
                          text: "Have an account? ",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: textColor, backgroundColor: Colors.transparent, ),
                          children: <TextSpan>[
                            TextSpan(text: ' Login', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryColor, backgroundColor: Colors.transparent, ),),
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
