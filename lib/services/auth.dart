import 'package:chatapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


// This class defines the different methods that will interact with firebase Auth service 
class AuthService{
  
  // This instance will allow us to communicat with Auth firebase in backend 
  // this will give us access to different property to the auth class 
  final FirebaseAuth _auth = FirebaseAuth.instance;



  // When we call this method from the login screen,
  // it will try to login, and if it succeeds, it will return a user object to the login widget.
  Future login(final usernameForm, final passwordForm) async{
  
    try{
      // Before we can login we must first check that username that the user provided exist
      String? isExist = await DatabaseService().usernameAvailable(usernameForm.text);

      // if the username exist we will retrive the email with that username
      if(isExist != null){
         String email = await DatabaseService().getUserEmail(isExist);

        // A UserCredential is returned from authentication requests such as [createUserWithEmailAndPassword].
        final UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, 
          password: passwordForm.text.trim()
        );

        final User? user = authResult.user;
        return user;
      }
      return null;
    }catch(e){
      return null;
    }
  }
 
  deleteAccount() async{
    final user = FirebaseAuth.instance.currentUser;
    user?.delete();
  }


  // register with email and password 
  Future register(final email, final password, final username) async{
    try{
      // create a user object with given email and password 
      final UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());
      final User? user = authResult.user;
      
      if(user!=null){
        // Before we can register we must first check that username that the user provided exist
        String? isExist = await DatabaseService().usernameAvailable(username.text);

        // if no one has this username then add this user
        if(isExist == null){
          // create a new document for the user with the uid 
          DatabaseService(uid: user.uid).updateUserData(email.text, username.text);

          return user.uid;
        }else{
          // if username is taken remove the user created 
          user.delete();
          return 'usernameTaken';
        }
      }

    }catch(e){
      // return null if anything happens with _auth.createUserWithEmailAndPassword
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
