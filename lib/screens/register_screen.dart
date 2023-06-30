import 'package:chatapp/const.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/widgets/background.dart';
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
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(  
          children: [
            const LineBackground(),
            
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
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  const [
                         SizedBox(
                          width: 140,
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(5,0,5,0),
                          child: Text('Register', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),

                         SizedBox(
                          width: 140,
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),


                    const SizedBox(height: 10,),
            
                    
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
                            labelText: 'Full name',
                            hintText: 'Enter your full name',
                             prefixIcon: Icon(Icons.person, color: textColor,)
                          ),
                        ),
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
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: textColor, width: 0),
                            ),
                            labelStyle: TextStyle(color: textColor),
                            labelText: 'Email',
                            hintText: 'Enter your Email',
                            prefixIcon: Icon(Icons.email, color: textColor,)
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
                          labelStyle: TextStyle(color: textColor),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock, color: textColor,),
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
                      child: const Text("Register"),
                    ),
                ),
                  
                   
                  const SizedBox(height: 220,),
                  
                  TextButton(
                    onPressed: (){
                       Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginOrRegister()),);
                  }, 
                  child: RichText(
                  text:  TextSpan(
                        text: "Have an account?",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: textColor, backgroundColor: Colors.transparent, ),
                        children: const <TextSpan>[
                          TextSpan(text: ' Login', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.white, backgroundColor: Colors.transparent, ),),
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
