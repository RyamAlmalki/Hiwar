import 'package:chatapp/pages/home/search/search_widget/friend_tile.dart';
import 'package:chatapp/pages/home/search/search_widget/search_tile.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/shared/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../models/conversation.dart';
import '../../../models/user.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.names});
  final List<String>? names;

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  String? searchResult = '';
  late final _stream;

  // user started conversations 
  List<Conversation>? conversations;
  List<Conversation>? searchConversationsItems = [];

  // users in the database 
  List<ChatUser>? users;
  List<ChatUser>? searchUserItems = [];


  @override
  void initState() {
    _stream = DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).conversations?.distinct();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // filter user started conversations from the streambuilder
  void filterSearchConversationsResults(String query) {
  setState(() {
    searchConversationsItems = conversations
      ?.where((item) => item.username.toLowerCase().contains(query.toLowerCase()))
      .toList();
    });
  }

  // filter users in the database from the streambuilder
  void filterSearchUsersResults(String query) {
    setState(() {
      searchUserItems = users
        ?.where((item) => item.username.toLowerCase().contains(query.toLowerCase()))
        .toList();
    });
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
                        icon: const Icon(Icons.arrow_back_ios ,color: Colors.white, ),
                        onPressed: () {
                           Navigator.of(context).pushReplacementNamed('homeScreen');
                        },
                      ),
                    ),

                    const Padding(
                      padding:  EdgeInsets.only(top: 50),
                      child:  Text(
                        'Search', 
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
                  color: accentColor, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        searchResult = value;
                        filterSearchConversationsResults(searchResult!);
                        filterSearchUsersResults(searchResult!);
                      });
                    },
                    controller: searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white,),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 17),
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  StreamBuilder<List<Conversation>?>(
                  stream: _stream,
                  builder: (context, snapshot) {
                    
                    if(snapshot.hasData){
                    conversations = snapshot.data?.reversed.toList();
                
                    if(searchResult == '' || searchResult == null){
                      searchConversationsItems = conversations;
                    }
            
                    return Center(
                      child: Column(
                        children: [
                          // Title 
                            searchResult!.isEmpty || searchResult!.isNotEmpty && searchConversationsItems!.isNotEmpty? const Row(
                              children: [
                                Padding(
                                  padding:EdgeInsets.all(10.0),
                                  child: Text('Friends', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                                ),
                              ],
                            ) : Container(),
                      
                            conversations!.isEmpty && searchResult == '' || searchResult == null? Container(
                            decoration: ShapeDecoration(
                                color: accentColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  )
                                ),
                                width: MediaQuery.of(context).size.width / 1.05,
                                height: 100,
                                child: const Center(child: Text('No Friends', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 18),)),
                          ) : Container(),
                            
                            
                          // List user started conversations from the filter 
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
                                itemCount: searchConversationsItems?.length,
                                itemBuilder: (context, index) {
                                Conversation conversation = searchConversationsItems!.elementAt(index);
                                
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
            
              StreamBuilder<List<ChatUser>?>(
              stream: DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid).users(widget.names),
              builder: (context, snapshot) {
                
                if(snapshot.hasData){
                users = snapshot.data;
                
                if(searchResult == '' || searchResult == null){
                  searchUserItems = [];
                }

                // title 
                return Center(
                  child: Column(
                    children: [
                          // Title 
                            searchResult!.isNotEmpty && searchUserItems!.isNotEmpty ||  searchResult!.isNotEmpty && searchConversationsItems!.isEmpty ?  const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('Message', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                                ),
                              ],
                            ) : Container(),
                    
                            searchConversationsItems!.isEmpty && searchResult!.isNotEmpty && searchUserItems!.isNotEmpty|| searchResult == '' || searchResult!.isNotEmpty && searchConversationsItems!.isNotEmpty && searchUserItems!.isNotEmpty || searchResult!.isNotEmpty && searchConversationsItems!.isNotEmpty && searchUserItems!.isEmpty?  Container( ) :Container(
                            decoration: ShapeDecoration(
                                color: accentColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  )
                                ),
                                width: MediaQuery.of(context).size.width / 1.05,
                                height: 100,
                                child: const Center(child: Text('Nothing Found', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 18),)),
                            ) ,
                    
                            // List user in the database from the filter
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
                                  itemCount: searchUserItems?.length,
                                  itemBuilder: (context, index) {
                                  ChatUser user = searchUserItems!.elementAt(index);
                                  
                                  return SearchTile(user: user);
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
              ),
            ),
          ),
        )
      )
    );
  }
}







