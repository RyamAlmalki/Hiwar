import 'package:chatapp/services/storage.dart';
import 'package:chatapp/shared/const.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            IconButton(
              onPressed:() async {

                // Step 1: Pick image 
                ImagePicker imagePicker =  ImagePicker();
                XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                if(file==null) {return;}

                // Step 2: generate a unique name for each image 
                String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

                // Step 3: Upload image to Firestore Storage 
                StorageService().uploadImage(uniqueFileName, file?.path);
              },
              
              icon: Icon(Icons.square, size: 100,)
            ),

            ElevatedButton(
              onPressed: (){
                Navigator.of(context).pushReplacementNamed('homeScreen');
            }, 
              child: Text('Later')
            )
          ],
        ),
      ),
    );
  }
}