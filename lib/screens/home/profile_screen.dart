import 'package:chatapp/shared/const.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: accentColor,
              child: IconButton(
                  icon:  const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () async{
                  Navigator.of(context).pushReplacementNamed('homeScreen');
                },
              ),
            ),
              
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            ),
            
            
            const SizedBox(
              width: 90,  
            ),    
          ],
        ), 
        centerTitle: false, 
        backgroundColor:background, 
        elevation: 1,
      ),
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20,),

              CircleAvatar(
                radius: 100,
                backgroundColor: accentColor,
              ),

              const SizedBox(height: 20,),

              Text('${_auth.user?.displayName}', style: TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold, color: textColor), ),
              
              const SizedBox(height: 40),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 50,
                child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor, // Background color
                  ),
                  onPressed: () async{
                    Navigator.of(context).pushReplacementNamed('uploadImageScreen');
                  },
                  child: const Text('Edit Name'),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 50,
                child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor, // Background color
                  ),
                   onPressed: () async{
                    await singout();
                  },
                  child: const Text('Logout'),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}

