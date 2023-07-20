import 'package:chatapp/screens/authenticate/auth_widget/background.dart';
import 'package:chatapp/screens/authenticate/auth_widget/line_title.dart';
import 'package:chatapp/screens/home/widgets/rounded_button.dart';
import 'package:chatapp/services/auth.dart';
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
  final AuthService _auth = AuthService(); // instance of the AuthService class 

  @override
  void dispose() {
    emailForm.dispose();
    passwordForm.dispose();
    super.dispose();
  }

  Future login() async{
    // loading CircularProgress 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );

    dynamic result = await _auth.login(emailForm, passwordForm); // dynamic because result can be null or User
    
    // pop the loading circle 
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    if(result == null){
      emailForm.clear();
      passwordForm.clear();
      // ignore: use_build_context_synchronously
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Login failed'),
          content: Text('please try again'),
          );
        }
      );
    }else{
      print(result);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('homeScreen');
    }
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
                          validator: (value) => value!.length < 6 ? 'Enter a password 6+ chars long' : null,
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
                          await login();
                        }, 
                        title: 'Login',
                      )
                    ),
                      
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4 ,
                    ),
                    
                    TextButton(
                      onPressed: (){
                      Navigator.of(context).pushReplacementNamed('registerScreen');
                    }, 
                    child: RichText(
                    text:  TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: textColor, backgroundColor: Colors.transparent, ),
                          children: <TextSpan>[
                            TextSpan(text: ' Register', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryColor, backgroundColor: Colors.transparent, ),),
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

