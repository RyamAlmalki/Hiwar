import 'package:chatapp/models/conversation.dart';
import 'package:chatapp/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/const.dart';


class ImagePage extends StatelessWidget {
  const ImagePage({super.key, required this.message, required this.conversation});
  final Message? message;
  final Conversation? conversation;
  
  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.scaleDown,
                image: NetworkImage(message?.message ?? ''),
              ),
            ),
          ),
    
    
    
          Positioned(
            top: MediaQuery.of(context).size.height / 14,
            left: 20,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: message?.senderId == FirebaseAuth.instance.currentUser?.uid ? NetworkImage(FirebaseAuth.instance.currentUser?.photoURL ?? '') : NetworkImage(conversation!.profilePic),
                      ),
    
                      const SizedBox(
                            width: 10,
                      ),
    
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                      ),
    
                      message?.senderId == FirebaseAuth.instance.currentUser?.uid ? Text('${FirebaseAuth.instance.currentUser?.displayName}', style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white, ) ,) : Text('${conversation?.fullName}', style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),),
    
    
                      Text(DateFormat('yyyy-MM-dd').format(message!.date), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13, color: textColor),) 
                    ],
                  ), 
                ],
              ),
            ),
          ),
        ],
    );
  }
}