import 'package:chatapp/pages/authenticate/upload_image_screen.dart';
import 'package:chatapp/shared/const.dart';
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


  bool usernameValidation(String str) {
    RegExp rex = RegExp(r"^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$");
     
    if (rex.hasMatch(str)) {
      return true;
    } else {
      return false;
    }

  }

  // Register the user
  Future signUp() async{
    // loading circle 
    showDialog(
      context: context, 
      builder: (context){
      return Center(child: CircularProgressIndicator(color: primaryColor,));
      }
    );

    // Validate username before register
    if(usernameForm.text.isNotEmpty && usernameValidation(usernameForm.text)){
      
      dynamic result = await AuthService().register(emailForm, passwordForm, usernameForm); 
    
      if (context.mounted) Navigator.of(context).pop();

      emailForm.clear();
      passwordForm.clear();
      usernameForm.clear();

      if(result == 'usernameTaken'){
        if (context.mounted) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Register Failed'),
              content: Text('Username is Taken'),
              );
            }
          );
        }
      }else if(result == null){
        if (context.mounted) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
                title: Text('Register Failed'),
                content: Text('Invalid Email'),
              );
            }
          );
        }
      }
      else{
      if (context.mounted) {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  UploadImageScreen(userId: result,)),
      );
      }
    }
    }else{
      usernameForm.clear();
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Username Warning'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Make sure your display name is'),
                Text('Not empty'),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(  
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              
              Form(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
