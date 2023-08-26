import 'package:flutter/material.dart';

import '../../../services/auth.dart';
import '../../../shared/const.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordForm = TextEditingController();
  TextEditingController confirmPasswordForm = TextEditingController();
  bool _passwordVisible = false;

  changePassword() async {
    // loading CircularProgress 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );

    if(newPasswordForm.text == confirmPasswordForm.text) {
      dynamic result = await AuthService().changePassword(newPasswordForm.text);

      if (context.mounted) Navigator.of(context).pop();
      
      if(result == false){
        newPasswordForm.clear();
        confirmPasswordForm.clear();
        if (context.mounted) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Password failed to Update'),
            content: Text('Could not sign in with those credentials'),
            );
          }
        );
        }
      }else{
        if (context.mounted) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Password Change Successful'),
            );
          }
        );
        }
      }
    }else{
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Password Mismatch'),
          content: Text('Please try again'),
          );
        }
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
            const SizedBox(
              width: 30,
              height: 50,
            ),

            const Text('Change password', style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold, color: Colors.white), ),

            IconButton(
                icon:  const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async{
                Navigator.of(context).pushReplacementNamed('profileScreen');
              },
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
                        controller: newPasswordForm,
                        obscureText: !_passwordVisible,
                        decoration: decorationStyles.copyWith( labelText: 'New Password', prefixIcon: Icon(Icons.lock, color: textColor,), 
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
                      height: 10,
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                        validator: (value) => value!.length < 6 ? 'Enter a password 6+ chars long' : null,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        controller: confirmPasswordForm,
                        obscureText: !_passwordVisible,
                        decoration: decorationStyles.copyWith( labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock, color: textColor,), 
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
                          await changePassword();
                        }, 
                        child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold),),
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