import 'dart:async';
import 'package:chatapp/pages/home/home_widget/options.dart';
import 'package:chatapp/pages/home/message/friend_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../../models/conversation.dart';
import '../../../models/message.dart';
import '../../../models/user.dart';
import '../../../services/Image.dart';
import '../../../services/database.dart';

import '../../../shared/const.dart';
import 'message_widget/message_bubble.dart';


class MessageScreen extends StatefulWidget {
  String? chatId;
  int numberOfUnseenMessages = 0;
  Conversation? conversation;
  DateTime? lastSavedConversationDate;
  bool? newUser;
  MessageScreen({super.key, this.newconversation, this.newUser ,this.conversation,this.chatId, required this.numberOfUnseenMessages, this.userId, this.lastSavedConversationDate});
  
  // HAVE USER ID HERE 
  String? userId;
  bool? newconversation;

  @override
  State<MessageScreen> createState() => _MessageScreentState();
}


class _MessageScreentState extends State<MessageScreen> {
  int numberOfMessages = 0;
  final DatabaseService database = DatabaseService();
  final messageTextConroller = TextEditingController();
  String? messageText;
  bool forBool = false;
  bool hasText = false;
  // HAVE USER HERE
  ChatUser? user;
  String? messageTextType;
  Conversation? previousConversation;
  String? chatId;
  late final _messageStream;
  bool newCon = true;
  int frinedlastmessage = 0;
  String? hintMessage = 'Send message...';
  bool isEnabled = true;

  sendMessage() async {
    
    if(widget.newconversation == true){

      setState(() {
        widget.newconversation = false;
      });
      
      // add the new conversation to sender 
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createUserConversation(widget.chatId, user?.photoURL, user?.displayName , messageText, user?.uid, user?.email, user?.username);

      // add the new conversation to the reciver 
      DatabaseService(uid: user!.uid).createUserConversation(widget.chatId, FirebaseAuth.instance.currentUser?.photoURL, FirebaseAuth.instance.currentUser?.displayName, messageText, FirebaseAuth.instance.currentUser?.uid, FirebaseAuth.instance.currentUser?.email, await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).getUsername());

      // update message
      DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).addMessage(widget.chatId, messageText, FirebaseAuth.instance.currentUser?.displayName, messageTextType);

      // check type of last message before you update 
      if(messageTextType == 'image'){
        // update last message for each user !!!
        DatabaseService().updateLastMessage(widget.chatId, FirebaseAuth.instance.currentUser!.uid, 'Photo');

        DatabaseService().updateLastMessage(widget.chatId, user!.uid, 'Photo');

      }else if(messageTextType == 'text'){
         // update last message for each user !!!
        DatabaseService().updateLastMessage(widget.chatId, FirebaseAuth.instance.currentUser!.uid, messageText);

        DatabaseService().updateLastMessage(widget.chatId, user!.uid, messageText);
      }
     
      // update the last unseen message for the other user who didn't send the message 
      updateLastUnseenMessage();

    }else{

      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).addMessage(widget.chatId, messageText, FirebaseAuth.instance.currentUser?.displayName, messageTextType);

      // check type of last message before you update 
      if(messageTextType == 'image'){
        // update last message for each user !!!
        DatabaseService().updateLastMessage(widget.chatId, FirebaseAuth.instance.currentUser!.uid, 'Photo');

        DatabaseService().updateLastMessage(widget.chatId, user!.uid, 'Photo');

      }else if(messageTextType == 'text'){
         // update last message for each user !!!
        DatabaseService().updateLastMessage(widget.chatId, FirebaseAuth.instance.currentUser!.uid, messageText);

        DatabaseService().updateLastMessage(widget.chatId, user!.uid, messageText);
      }
     
      // update the last unseen message for the other user who didn't send the message 
      updateLastUnseenMessage();
    }
  }


  void getUser(userId) async{
    ChatUser? currentUser = await DatabaseService().getConversationUser(userId); 
    

    if (mounted) {
       setState(() {
        user = currentUser;
      });
    }

    getLastUnseenMessage();
  }

  void getLastUnseenMessage() async{
    Conversation? conversation = await DatabaseService(uid: user!.uid).getConversation(widget.chatId);


    if (mounted) {
      if(conversation != null){
        setState(() {
          widget.numberOfUnseenMessages = conversation.numberOfUnseenMessages;
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();

    // get friend user if 
    getUser(widget.userId);

    // get the message stream
    _messageStream = DatabaseService().messages(widget.chatId, widget.lastSavedConversationDate);
    
    // update the number of the unseen messages
    resetLastUnseenMessage();
  }

  // update information 
  void updateConversation() async{
    // i will get the previous conversation from the reciver since i will use numberOfUnseenMessages from his side to update and resent the numberOfUnseenMessages to 0 for the sender
    Conversation? conversation = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getPreviousConversation(user?.uid);

    if (mounted) {
      if(conversation != null ){
        setState(() {
          widget.conversation = conversation;
        });
      }
    }
  }



  // Reset unseen messages for current user who opended the chat 
  resetLastUnseenMessage(){
    setState(() {
      widget.numberOfUnseenMessages = 0;
    });

    // update user last message + last message day + add to number of last seen message 
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).updateLastUnseenMessage(widget.chatId, 0);
  }




  // update unseen messages for both users 
  updateLastUnseenMessage() async {

    if (mounted) {
       setState(() {
        widget.numberOfUnseenMessages += 1;
      });
    }

    // update
    DatabaseService(uid: user!.uid).updateLastUnseenMessage(widget.chatId, widget.numberOfUnseenMessages);
    
    // the user who sent the message will not have new message showing
    //DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).updateLastUnseenMessage(widget.chatId, 0);
  }


  // get image from gallery 
   getFromGallery() async {
    String? imageUrl = await Images().getImageFromGallery();
    
    setState(() {
      messageText = imageUrl;
      messageTextType = 'image';
    });
    
    if(imageUrl != null){
      sendMessage();
    }
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: accentColor, width: 1)
          ),
        automaticallyImplyLeading: false,
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: textColor,
                size: 30,
              ),
              onPressed: () async{
                // Before going to the homescreen we have to clear current user unseenMessages
                // Because both users can be opening the chat at the same time 

                await resetLastUnseenMessage();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacementNamed('homeScreen');
              },
            ),
            
            TextButton(
              onPressed: () async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FriendProfileScreen(conversation: widget.conversation, user: user, chatId: widget.chatId, lastSavedConversationDate: widget.lastSavedConversationDate,))).then((value) { 
                  // here we update the conversation to get any new update done 
                  updateConversation(); 
                });
              },
              child: CircleAvatar(
                backgroundColor: primaryColor,
                radius: 20,
                backgroundImage: NetworkImage(user?.photoURL ?? '') ,
                child: widget.conversation == null ? user?.photoURL == "" ? Text(user!.displayName![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),) : null :  widget.conversation!.profilePic.isNotEmpty ?  null : Text(widget.conversation!.fullName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),) , 
                // should show the user image
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${ widget.conversation == null? user?.displayName : widget.conversation?.fullName}', style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), 
              ],
            ),
          ],
        ), 
        centerTitle: false, 
        backgroundColor: Colors.transparent, 
        elevation: 0,
      ),
      body: SafeArea(
      child: Column(
        children: [
            // middle section  
            StreamBuilder<List<Message>?>(
              stream: _messageStream,
              builder: (context, snapshot){

                if(snapshot.hasData){
                  List<Message>? messages = snapshot.data?.reversed.toList();

                  return Expanded(
                      child: ListView.builder(
                      reverse: true,
                      itemCount: messages?.length,
                      itemBuilder: (context, index) {
                        Message message = messages!.elementAt(index);
  
                        return MessageBubble(message: message, isMe: message.senderId == FirebaseAuth.instance.currentUser!.uid, conversation: widget.conversation,); 
                      },
                    ),
                  );
                }else{
                  return Expanded(child: Container(color: Colors.black,));
                }
              }
            ),
            
            // Bottom section 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: isEnabled,
                        onChanged: (value) {
                          value.isNotEmpty ? setState(() => hasText = true) : setState(() => hasText = false);
                        },
                        minLines: 1,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        controller: messageTextConroller,
                        style: TextStyle(color:textColor),  
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(20),
                            borderSide:  const BorderSide(
                              color: Colors.black , 
                              width: 0.5
                            )
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.transparent)
                          ),
                          hintText: forBool ? null : hintMessage,
                          hintStyle: TextStyle(color: textColor),
                          filled: true,
                          fillColor: accentColor, 
                          suffixIcon: hasText ? 
                          IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,  
                            icon: Icon(
                              Icons.send,
                              color: primaryColor
                            ),
                            onPressed: () async {
                              if(messageTextConroller.text.trim().isNotEmpty){
                                 setState(() {
                                  messageText = messageTextConroller.text;
                                  messageTextType = 'text';
                                });
                                          
                                messageTextConroller.clear(); 
                                hasText = false;
                                await sendMessage();
                              }
                             
                            },
                          ): Icon(Icons.send, color: textColor,)
                        ),
                      ),
                    ),
              
                     Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)
                          )
                        ),
                        onPressed: (){
                          getFromGallery();
                        }, 
                        child: const Icon(Icons.camera_alt)
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}







