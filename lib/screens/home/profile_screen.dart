import 'package:chatapp/services/database.dart';
import 'package:chatapp/shared/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/auth.dart';
import '../../services/storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProlfieScreenState();
}

class _ProlfieScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService(); // instance of the AuthService class 

  Future singout() async {
    _auth.signout();
    Navigator.of(context).pushReplacementNamed('loginScreen');
  }

  changeProfileImage() async{
    // Step 1: Pick image 
    ImagePicker imagePicker =  ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if(file==null) {return;}

    // Step 2: generate a unique name for each image 
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Step 3: Upload image to Firestore Storage 
    String? imageUrl = await StorageService().uploadImage(uniqueFileName, file.path);

    print(imageUrl);
    print('rtrtrtrtrttrtrtrtrtr'); 
    if(imageUrl != null){
      DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).updateImageUrlForOtherUsers(imageUrl);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [  
            IconButton(
                icon:  const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () async{
                Navigator.of(context).pushReplacementNamed('homeScreen');
              },
            ),
          ],
        ), 
        centerTitle: false, 
        backgroundColor: Colors.black, 
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20,),

              CircleAvatar(
                radius: 100,
                backgroundColor: accentColor,
                child: CircleAvatar(
                  backgroundColor: accentColor,
                  radius: 90,
                  backgroundImage: NetworkImage(_auth.user?.photoURL ?? '') ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: primaryColor,
                            child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white,),
                            onPressed: () {
                                changeProfileImage();
                              },
                            )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              Text('${_auth.user?.displayName}', style: const TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold, color: Colors.white), ),
              
              const SizedBox(height: 40),

              Container(
                width: MediaQuery.of(context).size.width / 1.1,
 
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                  
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: background,
                          child: const Icon(Icons.person, color: Colors.white,)
                        ),
                        title: const Text('Edit name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: background,
                          child: const Icon(Icons.mail, color: Colors.white,)
                        ),
                        title: const Text('Edit email', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: background,
                          child: const Icon(Icons.delete, color: Colors.white,)
                        ),
                        title: const Text('Delete account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: background,
                          child: const Icon(Icons.waving_hand, color: Colors.white),
                        ),
                        title: const Text('Sign out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                        onTap: () async {
                          await singout();
                        },
                      ),
                    )
                  ],
                )
              )
            ]
          ),
        ),
      ),
    );
  }
}

