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
                Navigator.of(context).pop();
              },
            ),
          ],
        ), 
        centerTitle: false, 
        backgroundColor:background, 
        elevation: 0,
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
                child: CircleAvatar(
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
                                Navigator.of(context).pushReplacementNamed('uploadImageScreen');
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
                      topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
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

