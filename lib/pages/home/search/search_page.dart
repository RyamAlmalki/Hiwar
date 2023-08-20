import 'package:chatapp/models/user.dart';
import 'package:chatapp/pages/home/search/search_widget/search_tile.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/shared/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/conversation.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  String? searchResult;
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 108, 
        leading: null,
        backgroundColor: Colors.black,
        elevation: 0,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:const EdgeInsets.only(left: 8, right: 8, top: 2),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: IconButton(
                        icon: const RotatedBox(
                        quarterTurns: 1,
                        child: Icon(Icons.arrow_forward_ios_outlined ,color: Colors.white, )),
                        onPressed: () {
                           Navigator.of(context).pushReplacementNamed('homeScreen');
                        },
                      ),
                    ),

                    const Padding(
                      padding:  EdgeInsets.only(top: 50),
                      child:  Text(
                        'Add Friends', 
                        style: TextStyle(
                          fontWeight: 
                          FontWeight.bold, 
                          fontSize: 20,
                          color: Colors.white
                          ),
                        ),
                    ),


                    const SizedBox(
                      height: 50,
                      width: 50,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration:  BoxDecoration(
                  color: accentColor, borderRadius: BorderRadius.circular(40)),
                child: Center(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchResult = value;
                      });
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.white,),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white,),
                        onPressed: () {
                          searchController.clear();
                        },
                      ),
                      hintText: 'Search',
                      hintStyle: const TextStyle(color: Colors.white, fontSize: 17),
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            // search stream builder 
            // StreamBuilder<List<ChatUser>?>(
            //   stream: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).users(searchResult),
            //   builder: (context, snapshot) {
            //     if(snapshot.hasData){
            //       List<ChatUser>? users = snapshot.data;

            //       return Expanded(
            //           child: ListView.separated(
            //           itemCount: users!.length,
            //           itemBuilder: (context, index) {
            //             ChatUser user = users.elementAt(index);

            //             print(user);
            //             return SearchsTile(user: user);
            //           }, separatorBuilder: (BuildContext context, int index) { 
            //              return const Divider(
            //                 height: 15,
            //                 thickness: 1,
            //                 indent: 1,
            //                 endIndent: 0,
            //                 color: Colors.black26,
            //               );
            //            },
            //         ),
            //       );
            //     }else{
            //       return const CircularProgressIndicator();
            //     }
            //   },
            // )


                StreamBuilder<List<Conversation>?>(
                stream: DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).conversations?.distinct(),
                builder: (context, snapshot) {
                  
                  if(snapshot.hasData){
                  List<Conversation>? conversations = snapshot.data?.reversed.toList();

                  return Center(
                    child: Column(
                      children: [
                        // Title 
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Friends', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),),
                              ),
                            ],
                          ),


                        Container(
                          decoration: ShapeDecoration(
                              color: accentColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                )
                              ),
                              width: MediaQuery.of(context).size.width / 1.05,
                              child: ListView.builder(
                              shrinkWrap: true,
                              
                              itemCount: conversations!.length,
                              itemBuilder: (context, index) {
                              Conversation conversation = conversations.elementAt(index);
                              
                              return FriendTile(conversation: conversation);
                            
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }else{
                  // return loading page 
                  return Expanded(child: Container());
                }
              }
            ),
          ],
        )
      )
    );
  }
}







