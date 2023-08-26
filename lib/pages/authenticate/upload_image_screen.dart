import 'package:chatapp/pages/home/home_page.dart';
import 'package:chatapp/shared/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/Image.dart';
import '../../services/database.dart';


class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key, required this.userId});
  final String userId;

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  dynamic profileImage = FirebaseAuth.instance.currentUser?.photoURL;
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameForm = TextEditingController();

  bool nameValidation(String str) {
    RegExp rex = RegExp(r"[a-zA-Z][a-zA-Z ]+[a-zA-Z]$");
     
    if (rex.hasMatch(str)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    fullNameForm.dispose();
    super.dispose();
  }

  uploadImage() async {
    // Here we will get the imageUrl after adding it to firebase storage 
    String? imageUrl = await Images().getImageFromGallery();

    if(imageUrl != null){
      setState(() {
        profileImage = imageUrl;
      });
      FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
      //update in the database
      DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).updateUserProfileImage(imageUrl);
    }
  }

  // update the user display name 
  updateName() async {
    // loading circle 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );
    
    if(fullNameForm.text.isNotEmpty &&  fullNameForm.text.length <= 20){
      await FirebaseAuth.instance.currentUser?.updateDisplayName(fullNameForm.text);
      await DatabaseService(uid: widget.userId).updateName(fullNameForm.text);

     
      if (context.mounted) Navigator.of(context).pop();

       if (context.mounted) {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  const HomeScreen()),
        );
       }
    }else{
      if (context.mounted) Navigator.of(context).pop();
      
      if (context.mounted) {
        showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              title: Text('Name Missing'),
              content: Text('Please include a display name'),
            );
          }
       );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5.5,
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
    
                    Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                            CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 100,
                              child: CircleAvatar(
                              backgroundColor: accentColor,
                              radius: 97,
                              backgroundImage: NetworkImage(profileImage ?? '') ,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                profileImage == '' || profileImage == null ? const SizedBox(
                                  height: 50,
                                ) : const SizedBox(),
    
                                profileImage == ''  || profileImage == null? const Icon(Icons.person_2_outlined, color: Colors.white, size: 70,) : const SizedBox(),
    
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: primaryColor,
                                        child: IconButton(
                                        icon: const Icon(Icons.add, color: Colors.white,),
                                        onPressed: () async{
                                            await uploadImage();
                                          },
                                        )
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ),
                    ), 
    
                    const SizedBox(height: 60,),
    
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          controller: fullNameForm,
                          decoration: decorationStyles.copyWith(
                            labelText: 'Enter Display Name', 
                            prefixIcon: Icon(Icons.person, color: textColor,
                          ),
                        )
                      ),
                    ),
    
                  const SizedBox(height: 70,),
                    
                  
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
                        updateName();
                      }, 
                      child: const Text('Start Chatting', style: TextStyle(fontWeight: FontWeight.bold),),
                      )
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