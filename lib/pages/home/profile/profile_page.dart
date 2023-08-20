import 'package:chatapp/pages/home/profile/blocked_page.dart';
import 'package:chatapp/pages/home/profile/change_email_page.dart';
import 'package:chatapp/pages/home/profile/change_name.dart';
import 'package:chatapp/pages/home/profile/reauthenticate_password_page.dart';
import 'package:chatapp/pages/home/home_widget/options.dart';
import 'package:chatapp/services/Image.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/shared/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/auth.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProlfieScreenState();
}

class _ProlfieScreenState extends State<ProfileScreen> {

  // Signout method 
  singout() async {
    await AuthService().signout();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('loginScreen');
  }

  // Change profile image method 
  changeProfileImage() async{
    // Here we will get the imageUrl after adding it to firebase storage 
    String? imageUrl = await Images().getImageFromGallery();

    if(imageUrl != null){
      DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).updateImageUrlForOtherUsers(imageUrl);
    }
  }

  // edit email method 
  changeEmail() async{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangeEmailPage()),
    );
  }

  // edit display name method
  editDisplayName() async{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangeNamePage()),
    );
  } 

  // view blocked method 
  viewBlockedUsers() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BlockedPage()),
    );
  }
  
  // change password method 
  changePassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReauthenticatePasswordPage()),
    );
  }

  // delete account method 
  deleteAccount() async{

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
                size: 30,
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

              // Profile Image 
              CircleAvatar(
                radius: 100,
                backgroundColor: primaryColor,
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 95,
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL ?? '') ,
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
              
              // Profile Display Name 
              Text('${FirebaseAuth.instance.currentUser?.displayName}', style: const TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold, color: Colors.white), ),
              
              const SizedBox(height: 40),

              // General options
              Options(
                optionsName: const ['Edit Name', 'Change Email', 'Blocked', 'Change Pasword'], 
                icons: const [Icons.person, Icons.email, Icons.block, Icons.password],
                optionsFunctions: [editDisplayName, changeEmail, viewBlockedUsers, changePassword],
                title: 'General',
              ),

              const SizedBox(height: 20),

               // Danger Zone options
                Options(
                optionsName: const ['Delete Account', 'Singout'], 
                icons: const [Icons.delete, Icons.handshake],
                optionsFunctions: [
                  deleteAccount, 
                  singout
                ],
                title: 'Danger Zone',
              ),

              const SizedBox(height: 30,)
            ]
          ),
        ),
      ),
    );
  }
}

