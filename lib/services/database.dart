import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String? uid;
  DatabaseService({this.uid});

  // refrence for our collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference conversationsCollection = FirebaseFirestore.instance.collection('conversations');

  // updating the userdata 
  Future updateUserData(String fullName, String email) async{
    return await userCollection.doc(uid).set(
      {
        "fullName": fullName,
        "email": email,
        "profilePic": "",
        "uid": uid,
      }
    );
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // create a conversation 
  Future createConveration() async {
    return await conversationsCollection.add(
      {
        "members": [],
        "messages": [],
      }
    );
  }

  // add a message to conversation 
  sendMessage() async {
    
  }

}