import 'package:chatapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/conversation.dart';
import '../../../services/database.dart';
import '../../../shared/const.dart';
import '../message_screen.dart';



class SearchsTile extends StatefulWidget {
  SearchsTile({super.key, required this.user});
  ChatUser? user;

  @override
  State<SearchsTile> createState() => _SearchsTileState();
}

class _SearchsTileState extends State<SearchsTile> {
  Conversation? conversation;
  


  // get previous conversation 
  void getPreviousConversation() async {
    // i will get the previous conversation from the reciver since i will use numberOfUnseenMessages from his side to update and resent the numberOfUnseenMessages to 0 for the sender
    Conversation? result = await DatabaseService(uid: widget.user?.uid).getPreviousConversation(FirebaseAuth.instance.currentUser!.uid);

    print(result);

    if (mounted) {
      if(conversation != null){
        setState(() {
          conversation = result;
        });
      }
    }      
  }



  @override
  void initState() {
    super.initState();
    getPreviousConversation();

    print(widget.user);
    
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('${widget.user?.email}', style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 15),),
        ),
        tileColor: Colors.black,
        leading: CircleAvatar(
          backgroundColor: accentColor,
          radius: 30,
          backgroundImage: NetworkImage(widget.user!.photoURL ?? '') ,
          child: widget.user?.photoURL == "" ? Text(widget.user!.displayName![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),) : null,
        ),
        title: Text('${widget.user?.displayName}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MessageScreen(userId: widget.user?.uid, numberOfUnseenMessages: 0, lastSavedConversationDate: conversation?.lastSavedConversationDate, chatId: conversation?.id, conversation: conversation,)),
          );
        },
      ),
    );
  }
}









// class SearchTile extends StatelessWidget {

//   final ChatUser? user;
//   const SearchTile({super.key, this.user});


  
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 2),
//       child: ListTile(
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 5.0),
//           child: Text('${user?.email}', style: TextStyle(color: textColor, fontWeight: FontWeight.normal, fontSize: 15),),
//         ),
//         tileColor: Colors.black,
//         leading: CircleAvatar(
//           backgroundColor: accentColor,
//           radius: 30,
//           backgroundImage: NetworkImage(user!.photoURL ?? '') ,
//           child: user?.photoURL == "" ? Text(user!.displayName![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),) : null,
//         ),
//         title: Text('${user?.displayName}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
//         onTap: (){
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) =>  MessageScreen(userId: user?.uid, numberOfUnseenMessages: 0,)),
//           );
//         },
//       ),
//     );
//   }
// }

