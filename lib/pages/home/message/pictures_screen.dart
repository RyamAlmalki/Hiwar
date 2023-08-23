import 'package:chatapp/models/conversation.dart';
import 'package:chatapp/pages/home/message/page_view.dart';
import 'package:flutter/material.dart';

import '../../../models/message.dart';
import '../../../models/user.dart';
import '../../../services/database.dart';
import '../../../shared/const.dart';
import 'image_page.dart';

class PictureScreen extends StatefulWidget {
  const PictureScreen({super.key, this.user, this.chatId, this.lastSavedConversationDate, this.conversation});
  final String? chatId;
  final DateTime? lastSavedConversationDate;
  final Conversation? conversation;
  final ChatUser? user;

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}


class _PictureScreenState extends State<PictureScreen> {

  List<ImagePage> pages = [
    //...
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [  
            IconButton(
                icon:  const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () async{
                Navigator.of(context).pop();
              },
            ),

            Text('${widget.conversation == null? widget.user?.displayName : widget.conversation?.fullName}', style: const TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold, color: Colors.white), ),

            const SizedBox(
              width: 50,
              height: 50,
            )

          ],
        ), 
        centerTitle: false, 
        backgroundColor: Colors.black, 
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            StreamBuilder<List<Message?>?>(
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
                      }
                      
                    );

                    for(int i = 0; i < imageMessages.length; i++){
                      pages.add(ImagePage(message: imageMessages.elementAt(i), conversation: widget.conversation));
                    }

                    return imageMessages.isNotEmpty ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, 
                        mainAxisExtent: 200,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1
                      ),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: imageMessages.length,
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
                                    );
            
                }else{
                  return  Padding(
                    padding: const EdgeInsets.only(bottom: 35, top: 35),
                    child: Center(child:Text('All Saved Media Will Show Here', style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.bold),), ),
                  );
                }
              }
            )
          ],
        ),
      )
    );
  }
}