import 'package:chatapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../services/database.dart';
import '../../shared/const.dart';

class FriendProfileScreen extends StatefulWidget {
  const FriendProfileScreen({super.key, this.user, this.chatId, this.lastSavedConversationDate});
  final String? chatId;
  final ChatUser? user;
  final DateTime? lastSavedConversationDate;
  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}


class _FriendProfileScreenState extends State<FriendProfileScreen> {
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
                  backgroundImage: NetworkImage(widget.user?.photoURL ?? '') ,
                  child: widget.user?.photoURL == "" ? Text(widget.user!.displayName![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),) : null,
                ),
              ),

              const SizedBox(height: 20,),

              Text('${widget.user?.displayName}', style: const TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold, color: Colors.white), ),
              
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                               
                    children: [
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding:  EdgeInsets.only(left: 10),
                                child:  Text('Photos', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                              TextButton(
                                child: Text('See All', style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold),), 
                                onPressed: (){
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                
                      SingleChildScrollView(
                        child: StreamBuilder<List<Message>?>(
                          stream: DatabaseService().messagesImage(widget.chatId, widget.lastSavedConversationDate),
                  
                          builder: (context, snapshot){
                      
                            if(snapshot.hasData){
                              List<Message>? messages = snapshot.data?.reversed.toList();
                      
                              return GridView.builder(
                                
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                    mainAxisExtent: 120,
                                  ),
                                  primary: false,
                                  itemCount: messages!.length >= 6 ? 6 : messages.length,
                                  shrinkWrap: true, itemBuilder: (BuildContext context, int index) {  
                                    
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                                    child: Container(
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover, image: NetworkImage('${messages?.elementAt(index).message}')),
                                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                        color: accentColor,
                                      ),
                                    ),
                                  );
                                }
                              );
                      
                            }else{
                              return const Expanded(child: CircularProgressIndicator());
                            }
                          }
                        ),
                      )
                    ],
                  ),
                )
              ),
              
              const SizedBox(height: 30,),


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
                          child: const Icon(Icons.clear, color: Colors.white,)
                        ),
                        title: const Text('Clear Chat', style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),),
                        onTap: () async {
                          
                          Navigator.of(context).pushReplacementNamed('homeScreen');
                          // update lastSavedConversationDate to be 
                          await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).clearChat(widget.chatId);
                         
                        },
                      ),
                    ),
                  

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                      child: ListTile(
                        focusColor: Colors.orange,
                        leading: CircleAvatar(
                          backgroundColor: background,
                          child: const Icon(Icons.block, color: Colors.white),
                        ),
                        title: const Text('Block Account', style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),),
                        onTap: () async {
                         
                        },
                      ),
                    )
                  ],
                )
              ),
            
              const SizedBox(height: 30,),
            ]
          ),
        ),
      ),
    );
  }
}