import 'package:chatapp/screens/home/friend_profile_screen.dart';
import 'package:chatapp/screens/home/widgets/view_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/conversation.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../services/storage.dart';
import '../../shared/const.dart';


class MessageScreen extends StatefulWidget {
  String? chatId;
  int numberOfUnseenMessages = 0;
  DateTime? lastSavedConversationDate;
  MessageScreen({super.key, this.chatId, required this.numberOfUnseenMessages, this.userId, this.lastSavedConversationDate});
  
  // HAVE USER ID HERE 
  String? userId;

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
  bool? showitems = false;
  String? chatId;
  late final _stream;

  sendMessage() async {
    // if null no conversation has been created between the two 
    if(widget.chatId == null){
      // create a conversation 
      String newConversationId = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createConveration(user!.uid);
      widget.chatId = newConversationId;

      // set the chatId to this conversation 
      if (mounted) {
        setState(() {
           widget.chatId = newConversationId;
        });
      }
      
      // add the new conversation to sender 
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createUserConversation(widget.chatId, user?.photoURL, user?.displayName , messageText, user?.uid);

      // add the new conversation to the reciver 
      DatabaseService(uid: user!.uid).createUserConversation(widget.chatId, FirebaseAuth.instance.currentUser?.photoURL, FirebaseAuth.instance.currentUser?.displayName, messageText, FirebaseAuth.instance.currentUser?.uid);

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

  updateLastUnseenMessage(){
    setState(() {
        widget.numberOfUnseenMessages += 1;
      });

     // update
      DatabaseService().updateLastUnseenMessage(widget.chatId, user!.uid, widget.numberOfUnseenMessages);

      // the user who sent the message will not have new message showing
      DatabaseService().updateLastUnseenMessage(widget.chatId, FirebaseAuth.instance.currentUser!.uid, 0);
  }


  void getUser(userId) async{
    ChatUser? currentUser = await DatabaseService().getConversationUser(userId); 
    

    if (mounted) {
       setState(() {
        user = currentUser;
      });
    }

    getPreviousConversation();
  }


  // get previous conversation 
  void getPreviousConversation() async{
    // i will get the previous conversation from the reciver since i will use numberOfUnseenMessages from his side to update and resent the numberOfUnseenMessages to 0 for the sender
    Conversation? conversation = await DatabaseService(uid: user?.uid).getPreviousConversation(FirebaseAuth.instance.currentUser!.uid);

    if (mounted) {
      if(conversation != null ){
        setState(() {
          widget.chatId = conversation.id;
          widget.numberOfUnseenMessages = conversation.numberOfUnseenMessages;
        });
      }
    }
  
  }




  @override
  void initState() {
    print(widget.lastSavedConversationDate);
    super.initState();
    _stream = DatabaseService().messages(widget.chatId, widget.lastSavedConversationDate);
    // GETUSER 
    getUser(widget.userId);

    // update last seem message 
    resetLastUnseenMessage();
    
  }

  resetLastUnseenMessage(){
    setState(() {
      widget.numberOfUnseenMessages = 0;
    });

     // update user last message + last message day + add to number of last seen message 
      DatabaseService().updateLastUnseenMessage(widget.chatId, FirebaseAuth.instance.currentUser!.uid, widget.numberOfUnseenMessages);
  }


   Future<bool> getFromGallery() async {
       // Step 1: Pick image 
      ImagePicker imagePicker =  ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

      if(file==null) {
        return false;
      }

      // Step 2: generate a unique name for each image 
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Step 3: Upload image to Firestore Storage and return the image URL
      String? imageUrl = await StorageService().sendImage(uniqueFileName, file.path);
     
      setState(() {
        messageText = imageUrl;
        messageTextType = 'image';
      });

      return true;
    }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
              onPressed: () {
                // Before going to the homescreen we have to clear current user unseenMessages 
                // Because both users can be opening the chat at same time 

                resetLastUnseenMessage();
                 Navigator.of(context).pushReplacementNamed('homeScreen');
              },
            ),
            
              TextButton(
              onPressed: () async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FriendProfileScreen(user: user, chatId: widget.chatId, lastSavedConversationDate: widget.lastSavedConversationDate,))); 
              },
              child: CircleAvatar(
                backgroundColor: accentColor,
                radius: 20,
                backgroundImage: NetworkImage(user?.photoURL ?? '') ,
                child: user?.photoURL == "" ? Text(user!.displayName![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),) : null, 
                // should show the user image
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${user?.displayName}', style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),), 
              ],
            ),
          ],
        ), 
        centerTitle: false, 
        backgroundColor:Colors.black, 
        elevation: 1,
      ),
      body: SafeArea(
      child: Column(
        children: [

            StreamBuilder<List<Message>?>(
              stream: _stream,
              builder: (context, snapshot){

                if(snapshot.hasData){
                  List<Message>? messages = snapshot.data?.reversed.toList();
              

                  return Expanded(
                      child: ListView.builder(
                      reverse: true,
                      itemCount: messages?.length,
                      itemBuilder: (context, index) {
                        Message message = messages!.elementAt(index);
           
                        return MessageBubble(message: message, isMe: message.senderId == FirebaseAuth.instance.currentUser!.uid, );
                      },
                      
                    ),
                  );
                }else{
                  return Expanded(child: Container(color: Colors.black,));
                }
              }
            ),
            
            

            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
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
                        hintText: forBool ? null : "Send Message...",
                        hintStyle: TextStyle(color: textColor),
                        filled: true,
                        fillColor: accentColor, 
                        suffixIcon: hasText ? 
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: textColor
                          ),
                          onPressed: () async {
                            setState(() {
                              messageText = messageTextConroller.text;
                              messageTextType = 'text';
                            });
                                      
                            messageTextConroller.clear(); 
                            await sendMessage();
                          },
                        ): IconButton(
                          icon: Icon(
                            Icons.mic,
                            color: textColor
                          ),
                          onPressed: () {
                            
                          },
                        ),
                      ),
                    ),
                  ),
            
                  showitems == false ? Padding(
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
                        setState(() {
                          showitems = true;
                        });
                      }, 
                      child: Icon(Icons.add)
                      ),
                    ),
                  ) : const Column(),
            
                  showitems == true ? 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                          onPressed: () async{
                            
                            bool result = await getFromGallery();
                            
                              // if result is true
                              if(result){
                                sendMessage();
                              }

                              setState(() {
                                showitems = false;
                              });
                            }, 
                          child: const Icon(Icons.image)
                          ),
                        ),
                      ), 
            
                      Padding(
                        padding: const EdgeInsets.only(left: 5 , top: 5),
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
                            showitems = true;
                          }, 
                          child: Icon(Icons.camera_alt)
                          ),
                        ),
                      ),
            
                       Padding(
                        padding: const EdgeInsets.only(left: 5 , top: 5),
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
                            setState(() {
                              showitems = false;
                            });
                          }, 
                          child: Icon(Icons.clear)
                          ),
                        ),
                      ),
            
            
                    ],
                    ) : Column(),
            
                ]
              ),
            ),
          ],
        )
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.isMe, });
  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, 
        children: [
          
          ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5,
              ),
              child: Material(
              color: isMe? message.type == 'text' ? bubbleColor : Colors.black : message.type == 'text' ? accentColor : Colors.black ,
              elevation: 0,
              borderRadius: message.type == 'text' ? BorderRadius.only( topLeft: !isMe ? const Radius.circular(0.0): const Radius.circular(30.0), bottomRight: const Radius.circular(30.0), bottomLeft: const Radius.circular(30.0), topRight:  isMe ? const Radius.circular(0.0): const Radius.circular(30.0)) : const BorderRadius.only( topLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
              child: Padding(
                padding: message.type == 'text' ? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0) : const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message.type == 'text' ? Text(
                    '${message.message}', 
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style:  TextStyle(color: isMe ? Colors.white: Colors.white, fontSize: 16),
                    ) : GestureDetector(
                      onTap: () {
                        // view full image
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewImage(message: message,)),
                        );
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("${message.message}"),
                              ),
                            ),
                          ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}




