import 'package:chatapp/models/conversation.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/home/image_page.dart';
import 'package:chatapp/screens/home/page_view.dart';
import 'package:chatapp/screens/home/pictures_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart';
import '../../services/database.dart';
import '../../shared/const.dart';
import 'shared_widget.dart/options.dart';


class FriendProfileScreen extends StatefulWidget {
  FriendProfileScreen({this.conversation, super.key, this.user, this.chatId, this.lastSavedConversationDate});
  final String? chatId;
  final ChatUser? user;
  final DateTime? lastSavedConversationDate;
  Conversation? conversation;
  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}


class _FriendProfileScreenState extends State<FriendProfileScreen> {
  TextEditingController nameForm = TextEditingController();

   @override
  void initState() {
    super.initState();
  }

  List<ImagePage> pages = [
    //...
  ];

 editDisplayName() async{

  }
   blockUser() async{
    
  }

  updateName() async{
    await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).editFriendDisplayName(widget.user?.uid, nameForm.text);
    updateConversation();
  }


  void updateConversation() async{
    // i will get the previous conversation from the reciver since i will use numberOfUnseenMessages from his side to update and resent the numberOfUnseenMessages to 0 for the sender
    Conversation? conversation = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getPreviousConversation(widget.user?.uid);

    if (mounted) {
      if(conversation != null ){
        setState(() {
          widget.conversation = conversation;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [  
            IconButton(
                icon:  const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () async{
                Navigator.of(context).pop(true);
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
                  child: widget.conversation?.profilePic == "" ? Text(widget.conversation!.fullName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),) : null,
                ),
              ),

              const SizedBox(height: 20,),

              Text('${widget.conversation?.fullName}', style: const TextStyle(fontSize: 30 ,fontWeight: FontWeight.bold, color: Colors.white), ),
              
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
                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PictureScreen(chatId: widget.chatId, lastSavedConversationDate: widget.lastSavedConversationDate, conversation: widget.conversation,)),
                        );
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

                              for(int i = 0; i < imageMessages.length; i++){
                                pages.add(ImagePage(message: imageMessages.elementAt(i), conversation: widget.conversation));
                              }
                
                              return imageMessages.isNotEmpty ? GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, 
                                    mainAxisExtent: 200,
                                    mainAxisSpacing: 1,
                                    crossAxisSpacing: 1
                                  ),
                                  primary: false,
                                  itemCount: imageMessages.length >= 6 ? 6 : imageMessages.length,
                                  shrinkWrap: true, 
                                  itemBuilder: (BuildContext context, int index) {  
                                    

                                    return Padding(
                                    padding: const EdgeInsets.only(top: 2, left: 2, right: 2),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  MainpageScreen(pages: pages, value: index, conversation: widget.conversation,)
                                          ),
                                        );
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context).size.width,
                                            height: 250,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage("${imageMessages.elementAt(index)?.message}"),
                                              ),
                                            ),
                                          ),
                                    )
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

              Options(
                optionsName: const ['Edit Name'], 
                icons: const [Icons.person],
                optionsFunctions: [editDisplayName()],
                title: 'General',
              ),
              
              const SizedBox(height: 30,),
              
              Options(
                optionsName: const ['Clear Chat', 'Block Account'], 
                icons: const [Icons.clear, Icons.block],
                optionsFunctions: [blockUser(), blockUser()],
                title: 'Danger Zone',
              ),

              const SizedBox(height: 30,),
            ]
          ),
        ),
      ),
    );
  }
}

























////////////////////////////////////

// clear chat function 
// Navigator.of(context).pushReplacementNamed('homeScreen');
// // update lastSavedConversationDate to be 
// await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).clearChat(widget.chatId);





// edit name function 
// return showDialog(
//   context: context, 
//   builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: accentColor,
//         content: Container(
//         width: MediaQuery.of(context).size.width ,
//         color: accentColor,
//         child: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//                   const Padding(
//                     padding:  EdgeInsets.only(top: 50),
//                     child:  Text('Edit Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
//                   ),

//                   const SizedBox(height: 30,),

//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 1.2,
//                     child: TextFormField(
//                         validator: (value) => value!.isEmpty ? 'value cannot be empty' : null,
//                         style: const TextStyle(color: Colors.white),
//                         keyboardType: TextInputType.name,
//                         controller: nameForm,
//                         decoration: decorationStyles.copyWith(
//                           fillColor: Colors.black,
//                           labelText: 'New Name', 
//                           prefixIcon: Icon(Icons.person, color: textColor,
                          
//                         ),
//                       )
//                     ),
//                   ),
          
//                   const SizedBox(height: 50,),
                  
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 1.5,
//                     height: 50,       
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: primaryColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)
//                         )
//                       ),
//                       onPressed: () async {
//                         updateName();
                        
//                         Navigator.of(context).pop();
//                       }, 
//                       child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold),),
//                     )
//                   ),

//                   const SizedBox(height: 5,),

//                   SizedBox(
//                     width: MediaQuery.of(context).size.width / 1.5,
//                     height: 50,       
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: accentColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)
//                         )
//                       ),
//                       onPressed: () async {                                              
//                         Navigator.of(context).pop();
//                       }, 
//                       child: const Text('Cancle', style: TextStyle(fontWeight: FontWeight.bold),),
//                     )
//                   ),


//                 ]
//               )
//             ),
//           )
//         ) ,
//       );
//     }
//   );