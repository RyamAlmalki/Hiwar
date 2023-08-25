import 'package:chatapp/pages/authenticate/auth_widget/background.dart';
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


  uploadImage() async {
    // Here we will get the imageUrl after adding it to firebase storage 
    String? imageUrl = await Images().getImageFromGallery();

    if(imageUrl != null){
      setState(() {
        profileImage = imageUrl;
      });
      FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
      DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).updateUserProfileImage(imageUrl);
    }
  }

  updateName()async{
    // loading circle 
    showDialog(
      context: context, 
       builder: (context){
        return Center(child: CircularProgressIndicator(color: primaryColor,));
       }
    );
    

    if(fullNameForm.text.isNotEmpty){
      await FirebaseAuth.instance.currentUser?.updateDisplayName(fullNameForm.text);
      await DatabaseService(uid: widget.userId).updateName(fullNameForm.text);
       // pop the loading circle 
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );
    }else{
      // pop the loading circle 
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            const AuthBackground(),

            Positioned(
            top: MediaQuery.of(context).size.height / 5.5,
            left: MediaQuery.of(context).size.width / 10,
              child: Form(
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

                    const SizedBox(height: 100,),
                     
                    
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
                        child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold),),
                      )
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