import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/conversation.dart';

class DatabaseService{

  final String? uid;
  DatabaseService({this.uid});

  // refrence for our collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference conversationsCollection = FirebaseFirestore.instance.collection('conversations');


  // updating the userdata 
  Future updateUserData(String fullName, String email) async{
    await userCollection.doc(uid).set(
      {
        "fullName": fullName,
        "email": email,
        "profilePic": "",
        "uid": uid,
      }
    );
  }


  // Search List fron snapshot 
  List<ChatUser>? _searchUserListFromSnapshot(QuerySnapshot snapshot){
      return snapshot.docs
      .map((doc) {
        return ChatUser(
          uid: doc['uid'] ?? '',
          displayName: doc['fullName'] ?? '', 
          email: doc['email'] ?? '', 
          profilePic: doc['profilePic'] ?? '',
        );
      }
    ).toList();
  }


  // get users from a stream
  Stream<List<ChatUser>?>? users(search){
    if(search == null){
      return userCollection
      .snapshots()
      .map((snapshot){
        return _searchUserListFromSnapshot(snapshot);
      });
    }

    if(search != null){
      return userCollection
      .where('email', whereIn: [search])
      .snapshots()
      .map((snapshot){
        return _searchUserListFromSnapshot(snapshot);
      });
    }
  }
  

  // Search List fron snapshot 
  List<Conversation>? _searchConversationListFromSnapshot(QuerySnapshot snapshot){
      return snapshot.docs
      .map((doc) {
        return Conversation(
          id: doc['conversationId'] ?? '',
          fullName: doc['fullName'] ?? '', 
          lastMessage: doc['lastMessage'] ?? '', 
          profilePic: doc['profilePic'] ?? '',
          numberOfUnseenMessages: doc['numberOfUnseenMessages']
        );
      }
    ).toList();
  }


  // get conversations from a strea,
  Stream<List<Conversation>?>? get conversations{
    return userCollection
    .doc('WjVIq9S6Z8hrvPws5ViFfuH1KAj2')
    .collection('converstions')
    .snapshots()
    .map(_searchConversationListFromSnapshot);
  }


  // get conversations from a stream
  Stream<DocumentSnapshot<Object?>> messages(conversationId){
    return conversationsCollection
    .doc(conversationId)
    .snapshots();
  }



  // addMessage 
  addMessage(conversationId, textMessage, numberOfMessages){
    conversationsCollection
    .doc(conversationId)
    .set(
      {
        'messages': {
          '${numberOfMessages++}' : {
            'text': textMessage,
            'senderId': uid,
          }
        }
      }, SetOptions(merge: true),
    );
  }

  
  // create a conversation 
  Future<String> createConveration(String reciverUid) async {
    return await conversationsCollection.add(
      {
        "members": [
          reciverUid,
          uid
        ],
        "messages": [],
      }
    ).then((DocumentReference doc ) {
        conversationsCollection.doc(doc.id).set(
          {
            'id': doc.id,
          }, SetOptions(merge: true)
        );

        return doc.id;
      } 
    );
  }

}