import 'package:firebase_auth/firebase_auth.dart';

// This class defines the different methods that will interact with firebase Auth service 
class AuthService{
  
  // This instance will allow us to communicat with Auth firebase in backend 
  // this will give us access to different property to the auth class 
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /* 
    When we call this method from the login screen,
    it will try to login, and if it succeeds, it will return a user object to the login widget.
  */
  Future login() async{
    try{
      // A UserCredential is returned from authentication requests such as [createUserWithEmailAndPassword].
      final UserCredential authResult = await _auth.signInWithEmailAndPassword(email: 'w', password: ';w');
      final User? user = authResult.user;
      return user;

    }catch(e){
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }


  // register with email and password 



  // sing out 
}