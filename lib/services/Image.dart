
import 'package:chatapp/services/storage.dart';
import 'package:image_picker/image_picker.dart';

class Images{


  // get image 
  Future<String?> getImageFromGallery() async {
    // Step 1: Pick image 
    ImagePicker imagePicker =  ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if(file==null) {return null;}

    // Step 2: generate a unique name for each image 
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Step 3: Upload image to Firestore Storage 
    String? imageUrl = await StorageService().uploadImage(uniqueFileName, file.path);

    return imageUrl;
  }









}