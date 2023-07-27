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
    FirebaseAuth.instance.currentUser!.updateDisplayName(fullName);
    FirebaseAuth.instance.currentUser!.updatePhotoURL("");
    
    await userCollection.doc(uid).set(
      {
        "fullName": fullName,
        "email": email,
        "profilePic": "",
        "uid": uid,
      }
    );
  }


  // update user image 
  updateUserProfileImage(path){
    userCollection
    .doc(uid) 
    .update({
      'profilePic': path
    });
  }

  // Search List fron snapshot 
  List<ChatUser>? _searchUserListFromSnapshot(QuerySnapshot snapshot){
      return snapshot.docs
      .map((doc) {
        return ChatUser(
          uid: doc['uid'] ?? '',
          displayName: doc['fullName'] ?? '', 
          email: doc['email'] ?? '', 
          photoURL: doc['profilePic'] ?? '',
        );
      }
    ).toList();
  }


  // get conversation user 
  Future<ChatUser?> getConversationUser(userId) async {
    ChatUser? user;
    
    await userCollection
    .doc(userId)
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      user = ChatUser(uid: documentSnapshot.get('uid'), displayName: documentSnapshot.get('fullName'), email: documentSnapshot.get('email'), photoURL: documentSnapshot.get('profilePic'));
    });

    return user;
  }


  // get users from a stream
  Stream<List<ChatUser>?>? users(search){
    if(search == null){
      return userCollection
      .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
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
          userId: doc['userId'],
          id: doc['conversationId'] ?? '',
          fullName: doc['fullName'] ?? '', 
          lastMessage: doc['lastMessage'] ?? '', 
          profilePic: doc['profilePic'] ?? '',
          numberOfUnseenMessages: doc['numberOfUnseenMessages'],
          date:(doc['date'] as Timestamp).toDate()
        );
      }
    ).toList();
  }


  // get conversations from a strea,
  Stream<List<Conversation>?>? get conversations{
    return userCollection
    .doc(uid)
    .collection('converstions')
    .snapshots()
    .map(_searchConversationListFromSnapshot);
  }


  // updateLastUnseenMessage
  updateLastUnseenMessage(conversationId, id, numberOfUnseenMessages){
    userCollection
    .doc(id) // each user id 
    .collection('converstions') 
    .where('conversationId', isEqualTo: conversationId)
    .get()
    .then((QuerySnapshot querySnapshot){
        if(querySnapshot.docs.isNotEmpty){
          
          querySnapshot.docs[0].reference.update(
            {
              'numberOfUnseenMessages': numberOfUnseenMessages
            }
          );
        }
      }
    );
  }


  // Search List fron snapshot 
  List<Message>? _searchMessagesListFromSnapshot(QuerySnapshot snapshot){
      return snapshot.docs
      .map((doc) {
        return Message(
          message: doc['text'],
          senderId: doc['senderId'],
          senderName: doc['senderName']
        );
      }
    ).toList();
  }


  // get messages from a strea,
  Stream<List<Message>?>? messages(conversationId){
    return conversationsCollection
    .doc(conversationId)
    .collection('messages')
    .orderBy('date')
    .snapshots()
    .map(_searchMessagesListFromSnapshot);
  }


  // addMessage 
  addMessage(conversationId, textMessage, senderName){
    conversationsCollection
    .doc(conversationId)
    .collection('messages')
    .add({
      'text': textMessage,
      'senderId': uid,
      'date': FieldValue.serverTimestamp(),
      'senderName': senderName,
    });
  }


  // update conversation last message
  updateLastMessage(conversationId, id, lastMessage){
    userCollection
    .doc(id) // each user id 
    .collection('converstions') 
    .where('conversationId', isEqualTo: conversationId)
    .get()
    .then((QuerySnapshot querySnapshot){
        if(querySnapshot.docs.isNotEmpty){
          
          querySnapshot.docs[0].reference.update(
            {
              'lastMessage': lastMessage,
            }
          );
        }
      }
    );
  }


  // create user started conversation 
  createUserConversation(conversationId, photoURL, displayName, lastMessage, userId){
    userCollection
    .doc(uid)
    .collection('converstions')
    .add({
        'conversationId': conversationId,
        'userId': userId,
        'fullName': displayName ?? '',
        'lastMessage': lastMessage,
        'numberOfUnseenMessages': 1,
        'profilePic': photoURL ?? '',
        'date': DateTime.now()
      }
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