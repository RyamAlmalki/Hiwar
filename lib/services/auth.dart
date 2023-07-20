import 'package:chatapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This class defines the different methods that will interact with firebase Auth service 
class AuthService{
  
  // This instance will allow us to communicat with Auth firebase in backend 
  // this will give us access to different property to the auth class 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;



  // create user object based on FirebaseUser but with only specific fileds 
  ChatUser? _userFromFirebaseUser(User userAuth){
    return userAuth != null ? ChatUser(
      uid: userAuth.uid,
      displayName: ''
      ) : null;
  }

  /* 
    When we call this method from the login screen,
    it will try to login, and if it succeeds, it will return a user object to the login widget.
  */
  Future login(final emailForm, final passwordForm) async{
    try{
      // A UserCredential is returned from authentication requests such as [createUserWithEmailAndPassword].
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
      email: emailForm.text.trim(), 
      password: passwordForm.text.trim()
      );

      final User? user = authResult.user;
      return user;
      
    }catch(e){
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
 

  // register with email and password 
  Future register(final emailForm, final passwordForm, final fullNameForm) async{
    try{
      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: emailForm.text.trim(), password: passwordForm.text.trim());
      final User? user = authResult.user;
      user?.updateDisplayName(fullNameForm.text);

      return user!;
    
    }catch(e){
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }


  // sing out
  Future signout() async {
    try{
       _auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }

}