import 'package:flutter/material.dart';

import '../../../services/auth.dart';
import '../../../shared/const.dart';

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({super.key});

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameForm = TextEditingController();


    bool nameValidation(String str) {
    RegExp rex = RegExp(r"[a-zA-Z][a-zA-Z ]+[a-zA-Z]$");
     
    if (rex.hasMatch(str)) {
      return true;
    } else {
      return false;
    }
  }

  changeName() async {
    // loading CircularProgress 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );
    
    // check if display name follows the rules 
    if(nameForm.text.isNotEmpty && nameValidation(nameForm.text) && nameForm.text.length <= 20){
      dynamic result = await AuthService().changeName(nameForm.text);

      if (context.mounted) Navigator.of(context).pop();
      
      if(result == false){
        nameForm.clear();
        if (context.mounted) {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Name Change failed'),
            );
          }
        );
        }
      }else{
        nameForm.clear();
        if (context.mounted) {
          showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Name Change Successful'),
            );
          }
        );
        }
      }
    }else{
      nameForm.clear();
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Display Name Warning'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
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
                Navigator.of(context).pushNamed('profileScreen');
              },
            ),

            const Text('Change Name', style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold, color: Colors.white), ),

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
                            keyboardType: TextInputType.name,
                            controller: nameForm,
                            decoration: decorationStyles.copyWith(
                              labelText: 'New Name', 
                              prefixIcon: Icon(Icons.person, color: textColor,
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
                          changeName();
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