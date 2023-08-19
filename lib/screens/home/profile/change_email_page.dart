import 'package:flutter/material.dart';

import '../../../services/auth.dart';
import '../../../shared/const.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
   final _formKey = GlobalKey<FormState>();
  TextEditingController emailForm = TextEditingController();

  changeEmail() async {
     // loading CircularProgress 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );
    
    dynamic result = await AuthService().changeEmail(emailForm.text);

    // pop the loading circle 
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    
    if(result == false){
      emailForm.clear();
      // ignore: use_build_context_synchronously
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Email Change failed'),
          content: Text('Could not change with new email'),
          );
        }
      );
    }else{
      emailForm.clear();
      // ignore: use_build_context_synchronously
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Email Change Successful'),
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

            const Text('Change Email', style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold, color: Colors.white), ),

            const SizedBox(
              width: 60,
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
                   
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: TextFormField(
                            validator: (value) => value!.isEmpty ? 'value cannot be empty' : null,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailForm,
                            decoration: decorationStyles.copyWith(
                              labelText: 'New Email', 
                              prefixIcon: Icon(Icons.email, color: textColor,
                            ),
                          )
                        ),
                      ),
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
                          await changeEmail();
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