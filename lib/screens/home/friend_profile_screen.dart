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
   final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  TextEditingController emailForm = TextEditingController();

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
                backgroundColor: primaryColor,
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 95,
                  backgroundImage: NetworkImage(widget.user?.photoURL ?? '') ,
                  child: widget.user?.photoURL == "" ? Text(widget.user!.displayName![0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),) : null,
                ),
              ),

              const SizedBox(height: 20,),

              Text('${widget.user?.displayName}', style: const TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold, color: Colors.white), ),
              
              const SizedBox(height: 5,),

              Text('${widget.user?.email}', style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.normal, color: textColor), ),

              const SizedBox(height: 40),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child:  Text('Saved in Chat', style: TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.bold),),
                    ),
                    TextButton(
                      child: Text('See All', style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold),), 
                      onPressed: (){
                      },
                    ),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                
                decoration: BoxDecoration(
                  color: accentColor,
                  
                  borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Column(      
                    children: [
                     
                  
                      SingleChildScrollView(
                        child: StreamBuilder<List<Message?>?>(
                          stream: DatabaseService().messagesImage(widget.chatId, widget.lastSavedConversationDate),
                  
                          builder: (context, snapshot){
                      
                            if(snapshot.hasData){
                      
                              List<Message?>? messages = snapshot.data?.reversed.toList();
                              List<Message?>? imageMessages = [];
                
                              // Here we will filter out any type other then Type = Image
                              messages?.forEach((element) {
                                if(element?.type == 'image'){
                                  imageMessages.add(element);
                                }
                              });
                
                
                              return imageMessages.isNotEmpty ? GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2,
                                    mainAxisExtent: 120,
                                  ),
                                  primary: false,
                                  itemCount: imageMessages.length >= 6 ? 6 : imageMessages.length,
                                  shrinkWrap: true, itemBuilder: (BuildContext context, int index) {  
                        
                                    return Padding(
                                    padding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                                    child: Container(
                                      width: 50.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover, image: NetworkImage('${imageMessages.elementAt(index)?.message}')),
                                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                        color: accentColor,
                                      ),
                                    ),
                                  );
                                }
                              ) : Padding(
                                padding: const EdgeInsets.only(bottom: 35, top: 15),
                                child: Center(child:Text('All Saved Media Will Show Here', style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.bold),), ),
                              ) ;
                
                      
                            }else{
                              return Expanded(child: Padding(
                                padding: const EdgeInsets.only(bottom: 35, top: 35),
                                child: Center(child:Text('All Saved Media Will Show Here', style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.bold),), ),
                              ));
                            }
                          }
                        ),
                      ),
                    ],
                  ),
                )
              ),
              
              const SizedBox(height: 30,),

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  children: [
                    
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('General', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
                        ),
                      ],
                    ),

                    ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      tileColor: accentColor,
                      selectedTileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: background,
                        child: const Icon(Icons.person, color: Colors.white,)
                      ),
                      title: const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text('Edit Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                      onTap: () async {
                        showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context, 
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)
                            )
                          ),
                          builder:(BuildContext context){
                          return  FractionallySizedBox(
                            heightFactor: 0.8,
                            child: Container(
                              color: Colors.black,
                              child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                        
                            
                                  Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width / 1.2,
                                      child: TextFormField(
                                          validator: (value) => value!.isEmpty ? 'value cannot be empty' : null,
                                          style: const TextStyle(color: Colors.white),
                                          keyboardType: TextInputType.emailAddress,
                                          controller: emailForm,
                                          decoration: decorationStyles.copyWith(
                                            labelText: 'Enter Display Name', 
                                            prefixIcon: Icon(Icons.person, color: textColor,
                                          ),
                                        )
                                      ),
                                    ),
                                  ),
                            
                          
                           
                            
                            const SizedBox(height: 50,),
                            
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.4,
                              height: 50,       
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  )
                                ),
                                onPressed: () async {
                                  
                                }, 
                                child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold),),
                              )
                            ),






                                         ]
                                     )
                               
                                ),
                              )
                            ) 
                          );
                        }
                      );
                       
                      },
                    ),
                  ],
                )
              ),
              
              const SizedBox(height: 30,),
              
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Danger Zone', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
                        ),
                      ],
                    ),

                    ListTile(
                      shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                    ),
                    tileColor: accentColor,
                    selectedTileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: background,
                        child: const Icon(Icons.clear, color: Colors.white,)
                      ),
                      title: const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text('Clear Chat', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      ),
                      onTap: () async {
                        
                        Navigator.of(context).pushReplacementNamed('homeScreen');
                        // update lastSavedConversationDate to be 
                        await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).clearChat(widget.chatId);
                       
                      },
                    ),
                  

                    ListTile(
                      shape: const RoundedRectangleBorder(
                         borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                      )
                      ),
                      tileColor: accentColor,
                      selectedTileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: background,
                        child: const Icon(Icons.block, color: Colors.white),
                      ),
                      title: const Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text('Block Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                      ),
                      onTap: () async {
                       
                      },
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