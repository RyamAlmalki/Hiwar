import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../services/database.dart';
import '../../shared/const.dart';

class FriendProfileScreen extends StatefulWidget {
  FriendProfileScreen({super.key, this.user, this.chatId});
  String? chatId;
  ChatUser? user;

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
                  radius: 90,
                  backgroundImage: NetworkImage(widget.user?.photoURL ?? '') ,
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
                        stream: DatabaseService().messages(widget.chatId)?.distinct(),

                        builder: (context, snapshot){
                    
                          if(snapshot.hasData){
                            List<Message>? messages = snapshot.data?.reversed.toList();
                    
                            return GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0,
                                  
                                ),
                                primary: false,
                                itemCount: messages?.length,
                                shrinkWrap: true, itemBuilder: (BuildContext context, int index) {  
                                  
                                  if(messages?.elementAt(index).type == 'image'){
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover, image: NetworkImage('${messages?.elementAt(index).message}')),
                                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    );
                                  }else{
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        width: 100.0,
                                        height: 150.0,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ); 
                                  }
                                }
                            );
                    
                          }else{
                            return const Expanded(child: CircularProgressIndicator());
                          }
                        }
                      ),
                    ),

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