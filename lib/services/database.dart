import 'package:chatapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // conversation List from a snapshot 
  

  // Search List fron snapshot 
  List<ChatUser>? _searchListFromSnapshot(QuerySnapshot snapshot){
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
  Stream<List<ChatUser>?> get users{
    return userCollection.snapshots()
    .map((snapshot){
      return _searchListFromSnapshot(snapshot);
    });
  }


  // get conversation from a stream
  Stream<QuerySnapshot> get conversations{
    return conversationsCollection.snapshots();
  }

  // getting user data
  Future<QueryDocumentSnapshot<Object?>?> gettingUserData(String email) async {
    QueryDocumentSnapshot<Object?>? user;

    await userCollection
    .get()
    .then((QuerySnapshot querySnapshot) {
        for(var snapshot in querySnapshot.docs){
          if(snapshot["email"] == email){
            //user = ChatUser(uid: snapshot["uid"], displayName: snapshot["fullName"], email: snapshot["email"], profilePic: snapshot["profilePic"]);
            user = snapshot;
          }
        }
      }
    );

    return user;
  }

  Future<QueryDocumentSnapshot<Object?>?> gettingConversation(String reciverUid, String uid) async{
    QueryDocumentSnapshot<Object?>? conversation;
    bool member1 = false ;
    bool member2 = false;

    await conversationsCollection
    .get()
    .then((QuerySnapshot querySnapshot) {
        for(var snapshot in querySnapshot.docs){

          for(var member in snapshot.get('members')){
            
            if(member == uid){ // if the user is part of a conversation then 
              member1 = true;
            }
            if(member == reciverUid){
              member2 = true;
            }
          }

          if(member1 == true && member2 == true){
            conversation = snapshot;
          }
        }
      }
    );
    
    return conversation;
  }


  // create a conversation 
  Future createConveration(String reciverUid, String uid) async {
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
      } 
    );
  }

  // add a message to conversation 
  sendMessage() async {
    
  }

}