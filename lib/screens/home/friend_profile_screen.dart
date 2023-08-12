import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../services/database.dart';
import '../../shared/const.dart';

class FriendProfileScreen extends StatefulWidget {
  const FriendProfileScreen({super.key, this.user, this.chatId});
  final String? chatId;
  final ChatUser? user;

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
                child: Column(
               
                  children: [
                  
                    SingleChildScrollView(
                      child: StreamBuilder<List<Message>?>(
                        stream: DatabaseService().messagesImage(widget.chatId),

                        builder: (context, snapshot){
                    
                          if(snapshot.hasData){
                            List<Message>? messages = snapshot.data?.reversed.toList();
                    
                            return GridView.builder(
                              
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 0,
                                  mainAxisExtent: 150,
                                ),
                                primary: false,
                                itemCount: 3,
                                shrinkWrap: true, itemBuilder: (BuildContext context, int index) {  
                                  
                                return Padding(
                                  padding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                                  child: Container(
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover, image: NetworkImage('${messages?.elementAt(index).message}')),
                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                      color: Colors.redAccent,
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
                    ),

                    SizedBox(
                      width: 100,
                      height: 50,
                      
                      child: TextButton(
                        child: const Text('View All', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),), 
                        onPressed: (){

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