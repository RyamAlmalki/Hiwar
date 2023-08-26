import 'package:chatapp/services/auth.dart';
import 'package:flutter/material.dart';
import '../../shared/const.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  TextEditingController usernameForm = TextEditingController();
  TextEditingController passwordForm = TextEditingController();

  @override
  void dispose() {
    usernameForm.dispose();
    passwordForm.dispose();
    super.dispose();
  }

  // Login the user 
  Future login() async{
    // loading CircularProgress 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );

    // login the user with given username and password 
    dynamic result = await AuthService().login(usernameForm, passwordForm); 
    
    if (context.mounted) Navigator.of(context).pop();

    // if result is null 
    if(result == null){
      usernameForm.clear();
      passwordForm.clear();
      if (context.mounted) {
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Login Failed'),
            content: Text('Could not sign in with those credentials'),
            );
          }
        );
      }
    }else{
      // if result is a user object 
      if (context.mounted) Navigator.of(context).pushReplacementNamed('homeScreen');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Center(
            child: Column(  
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5.5,
                ),

                // Form 
                Form(
                    key: _formKey,
                    child: SingleChildScrollView(
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
                              
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: TextFormField(
                                  scrollPadding: const EdgeInsets.only(
                                    bottom: 30),
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
                            ),
            
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: TextFormField(
                                scrollPadding: const EdgeInsets.only(
                                bottom: 30),
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
                                await login();
                              }, 
                              child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold),),
                            )
                          ),
                            
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 4,
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
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

