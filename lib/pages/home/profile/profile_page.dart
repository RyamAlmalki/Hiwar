import 'package:chatapp/pages/authenticate/login_screen.dart';
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
  dynamic profileImage = FirebaseAuth.instance.currentUser?.photoURL;
  String? username = '';

  getUsername() async {
    String? result = await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).getUsername();
    setState(() {
      username = result;
    });
  }

  @override
  void initState() {
    getUsername();
    super.initState();
  }
  
  // Signout method 
  singout() async {
    await AuthService().signout();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('loginScreen');
    }
  }

  // Change profile image method 
  changeProfileImage() async{
    // Here we will get the imageUrl after adding it to firebase storage 
    String? imageUrl = await Images().getImageFromGallery();

    if(imageUrl != null){
      FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
      DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).updateImageUrlForOtherUsers(imageUrl);
    }

    setState(() {
      profileImage = imageUrl;
    });
  }

  // edit display name method
  editDisplayName() async{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangeNamePage()),
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
    await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).deleteConversationMessages();
    await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).deleteConversations();
    await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).deleteAccount();
    await AuthService().deleteAccount();
     if (context.mounted) {
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
     }
  }

  // remove image method 
  removeImage() async{
    setState(() {
      profileImage = '';
    });
    FirebaseAuth.instance.currentUser?.updatePhotoURL('');
    DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).updateUserProfileImage('');
    DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).updateImageUrlForOtherUsers('');
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
                  backgroundColor: accentColor,
                  radius: 97,
                  backgroundImage: NetworkImage(profileImage ?? '') ,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      profileImage == '' || profileImage == null ? const SizedBox(
                        height: 50,
                      ) : const SizedBox(),

                     profileImage == ''  || profileImage == null? Text('${FirebaseAuth.instance.currentUser?.displayName![0].toUpperCase()}', style: const TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),) : const SizedBox(),
                     
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

              const SizedBox(height: 5,),

              Text(username!, style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.normal, color: textColor), ),


              const SizedBox(height: 40),

              // General options
              Options(
                optionsName: const ['Edit Name', 'Change Pasword', 'Remove Image'], 
                icons: const [Icons.person, Icons.password, Icons.remove_circle],
                optionsFunctions: [editDisplayName, changePassword, removeImage],
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

