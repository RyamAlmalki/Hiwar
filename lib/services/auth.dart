import 'package:chatapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// This class defines the different methods that will interact with firebase Auth service 
class AuthService{
  
  // This instance will allow us to communicat with Auth firebase in backend 
  // this will give us access to different property to the auth class 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final user = FirebaseAuth.instance.currentUser;
  //late final ChatUser chatUser;


  // create user object based on FirebaseUser but with only specific fileds 
  // ChatUser? _userFromFirebaseUser(User userAuth){
  //   return userAuth != null ? ChatUser(
  //     uid: userAuth.uid,
  //     displayName: userAuth.displayName,
  //     ) : null;
  //   }

  
  // When we call this method from the login screen,
  // it will try to login, and if it succeeds, it will return a user object to the login widget.
  Future login(final usernameForm, final passwordForm) async{
  
    try{

      print(usernameForm.text);

      String? isExist = await DatabaseService().checkUsername(usernameForm.text);

      print(isExist);

      if(isExist != null){
         String email = await DatabaseService().getEmail(isExist);

        // A UserCredential is returned from authentication requests such as [createUserWithEmailAndPassword].
        final UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: passwordForm.text.trim()
        );

        final User? user = authResult.user;
        // chatUser = _userFromFirebaseUser(user!)!;
        // print(chatUser.displayName);

        return user;
      }
    
      return null;
      
    }catch(e){
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
 
  deleteAccount() async{
    final user = FirebaseAuth.instance.currentUser;
    user?.delete();
  }


  // register with email and password 
  Future register(final email, final password, final fullName) async{
    try{
      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());
      final User? user = authResult.user;
      
      if(user!=null){
        String? isExist = await DatabaseService().checkUsername(fullName.text);
    
        if(isExist == null){
          // create a new document for the user with the uid 
          DatabaseService(uid: user.uid).updateUserData(email.text, fullName.text);

          return user.uid;
        }else{
          user.delete();
          return 'usernameTaken';
        }
      }

    }catch(e){
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }


  Future fetchUser(final email) async {
    try{
      return await _auth.fetchSignInMethodsForEmail(email);
    // ignore: empty_catches
    }catch(e){
    }   
  }

  // make sure that owner is the one changing the passowrd 
  Future<bool> reauthenticatePassword(password ) async {
    final user = FirebaseAuth.instance.currentUser;
    // you should check here that email is not empty
    final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password
    );

    try {
      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  // sing out
  Future signout() async {
    try{
       _auth.signOut();
    // ignore: empty_catches
    }catch(e){
      
    }
  }


  // change password 
  Future<bool> changePassword(password) async {
     //Create an instance of the current user. 
    final user = FirebaseAuth.instance.currentUser;
   
    try {
      await user?.updatePassword(password);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  // change name 
  Future<bool> changeName(name) async {
    // user must login again to update email
    final User? user = FirebaseAuth.instance.currentUser;

    try {
      await user?.updateDisplayName(name);
      DatabaseService(uid: user?.uid).updateName(name);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }
}
