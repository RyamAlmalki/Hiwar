import 'package:flutter/material.dart';

import '../../../services/auth.dart';
import '../../../shared/const.dart';
import 'change_password_page.dart';

class ReauthenticatePasswordPage extends StatefulWidget {
  const ReauthenticatePasswordPage({super.key});

  @override
  State<ReauthenticatePasswordPage> createState() => _ReauthenticatePasswordPageState();
}

class _ReauthenticatePasswordPageState extends State<ReauthenticatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordForm = TextEditingController();
  bool _passwordVisible = false;

  reauthenticatePassword() async {
     // loading CircularProgress 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );
    
    dynamic result = await AuthService().reauthenticatePassword(passwordForm.text);

    // pop the loading circle 
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    
    if(result == false){
      passwordForm.clear();
      // ignore: use_build_context_synchronously
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Password failed'),
          content: Text('Could not sign in with those credentials'),
          );
        }
      );
    }else{
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePasswordPage()
        ),
      );
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: accentColor, width: 1)
        ),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [  
            IconButton(
                icon:  const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async{
                Navigator.of(context).pop();
              },
            ),

            const Text('Change password', style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold, color: Colors.white), ),

            const SizedBox(
              width: 50,
              height: 50,
            ),
          ],
        ), 
        centerTitle: false, 
        backgroundColor: Colors.black, 
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        validator: (value) => value!.length < 6 ? 'Enter a password 6+ chars long' : null,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        controller: passwordForm,
                        obscureText: !_passwordVisible,
                        decoration: decorationStyles.copyWith( labelText: 'Old Password', prefixIcon: Icon(Icons.lock, color: textColor,), 
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

                    const SizedBox(
                      height: 20,
                    ),

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
                          await reauthenticatePassword();
                        }, 
                        child: const Text('Next', style: TextStyle(fontWeight: FontWeight.bold),),
                      )
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}