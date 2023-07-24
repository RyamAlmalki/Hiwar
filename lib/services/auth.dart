import 'package:chatapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This class defines the different methods that will interact with firebase Auth service 
class AuthService{
  
  // This instance will allow us to communicat with Auth firebase in backend 
  // this will give us access to different property to the auth class 
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
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
  Future login(final emailForm, final passwordForm) async{
    try{
      // A UserCredential is returned from authentication requests such as [createUserWithEmailAndPassword].
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(
      email: emailForm.text.trim(), 
      password: passwordForm.text.trim()
      );

      final User? user = authResult.user;
      // chatUser = _userFromFirebaseUser(user!)!;
      // print(chatUser.displayName);
      return user;
      
    }catch(e){
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }
 

  // register with email and password 
  Future register(final email, final password, final fullName) async{
    try{
      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());
      final User? user = authResult.user;
      
      // create a new document for the user with the uid 
      if(user!=null){
        DatabaseService(uid: user.uid).updateUserData(fullName.text, email.text);
      }

      return user!;
    }catch(e){
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  Future fetchUser(final email) async {
    try{
      return await _auth.fetchSignInMethodsForEmail(email);
    }catch(e){
      print(e);
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
