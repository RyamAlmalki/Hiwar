import 'dart:io';
import 'package:chatapp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  // Reference to storage root 
  Reference storageRef = FirebaseStorage.instance.ref();

  uploadImage(uniqueName, path) async {
    // get Reference to storage root 
    Reference referenceDirImages = storageRef.child('images');

    // Create a reference for image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueName);

    // error/success of upload?
    try{
      // Store the file 
      await referenceImageToUpload.putFile(File(path));

      // get the imageUrl
      String imageUrl = await referenceImageToUpload.getDownloadURL();

      // Store the image URL inside the crrespopnding document of the database.
      FirebaseAuth.instance.currentUser?.updatePhotoURL(imageUrl);
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).updateUserProfileImage(imageUrl);

    }catch(e){
      // ignore: avoid_print
      print(e);
    }
  }

}
