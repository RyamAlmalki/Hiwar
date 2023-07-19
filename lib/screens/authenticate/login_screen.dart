import 'package:chatapp/screens/authenticate/auth_widget/background.dart';
import 'package:chatapp/screens/authenticate/auth_widget/line_title.dart';
import 'package:chatapp/screens/home/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../const.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  TextEditingController emailForm = TextEditingController();
  TextEditingController passwordForm = TextEditingController();

  @override
  void dispose() {
    emailForm.dispose();
    passwordForm.dispose();
    super.dispose();
  }

  Future signIn() async{
    // loading circle 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailForm.text.trim(), 
      password: passwordForm.text.trim());
    
    // pop the loading circle 
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: false,
      body: Stack(  
        children: [
          const AuthBackground(),
            
          Positioned(
          top: MediaQuery.of(context).size.height / 4,
          left: MediaQuery.of(context).size.width / 11,
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
            
                      Hero(
                        tag: "logo",
                          child: SizedBox(
                            height: 100,
                            child: Center(
                              child: Image.asset('assets/images/logo.png'),
                          ),
                        )
                      ),
                        
                      TitleLine(
                        title: 'Login', 
                        width: 150,
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
                              prefixIcon: Icon(Icons.email, color: textColor,
                            ),
                          )
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
                          decoration: decorationStyles.copyWith( labelText: 'Enter Password', prefixIcon: Icon(Icons.lock, color: textColor,), 
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
                          await signIn();
                          Navigator.of(context).pushReplacementNamed('homeScreen');
                        }, 
                        title: 'Login',
                      )
                    ),
                      
                    const SizedBox(height: 250,),
                    
                    TextButton(
                      onPressed: (){
                          Navigator.of(context).pushReplacementNamed('registerScreen');
                    }, 
                    child: RichText(
                    text:  TextSpan(
                          text: "Have an account?",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: textColor, backgroundColor: Colors.transparent, ),
                          children: const  <TextSpan>[
                            TextSpan(text: ' Register', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white, backgroundColor: Colors.transparent, ),),
                          ],
                        ),
                      ),
                    ),             
                  ],
                ),
              )
            ),
          )
        ],
      )
    );
  }
}

