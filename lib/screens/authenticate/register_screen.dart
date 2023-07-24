import 'package:chatapp/shared/const.dart';
import 'package:chatapp/screens/authenticate/auth_widget/background.dart';
import 'package:chatapp/screens/authenticate/auth_widget/line_title.dart';
import 'package:chatapp/screens/home/widgets/rounded_button.dart';
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
  TextEditingController fullNameForm = TextEditingController();
  final AuthService _auth = AuthService(); // instance of the AuthService class 
  
 
   Future signUp() async{
     // loading circle 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );

    dynamic result = await _auth.register(emailForm, passwordForm, fullNameForm); // dynamic because result can be null or User
    
    Navigator.of(context).pop();

    if(result == null){
      emailForm.clear();
      passwordForm.clear();
      // ignore: use_build_context_synchronously
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Register failed'),
          content: Text('please supply a valid email'),
          );
        }
      );
    }else{
      
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('homeScreen');
    }
  }


  @override
  void dispose() {
    emailForm.dispose();
    passwordForm.dispose();
    fullNameForm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(  
          children: [
            const AuthBackground(),
            
            Positioned(
            top: MediaQuery.of(context).size.height / 5,
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
                            child: Center(child: Image.asset('assets/images/logo.png'),),
                        )
                      ),
                        
                      TitleLine(
                        title: 'Register', 
                        width: 130,
                        ),
                      
                      const SizedBox(height: 20,),
                
                      SizedBox(
                        width:350,
                        child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.text,
                            controller: fullNameForm,
                            decoration: decorationStyles.copyWith(
                              labelText: 'Enter Full Name', 
                              prefixIcon: Icon(Icons.person, color: textColor,
                            ),
                          )
                        ),
                      ),

                      const SizedBox(height: 20,),
                      
                      SizedBox(
                        width:350,
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
                        width: 350,
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
                      width: 300,
                      height: 50,       
                      child: RoundedButton(
                        onPressed: () async {
                          // it's async because we will perform an async task to register 
                          signUp();
                        }, 
                        title: 'Register',
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
