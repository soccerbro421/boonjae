import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {

  Future<Uint8List?> getImageBytes(Reference ref) async {
    try {      
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await ref.getData(5 * oneMegabyte);
      return data;
      
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
    
  }
}




// Future<void> setLocalProfilePic(UserModel user, Uint8List image) async {
  //   try {
  //     final appDir = await syspaths.getApplicationDocumentsDirectory();
  //     final directoryPath = '${appDir.path}/${user.uid}';
  //     final filePath = '$directoryPath/${user.profilePicId}';

  //     // Create the directory if it doesn't exist
  //     await Directory(directoryPath).create(recursive: true);

  //     // Write the image data to the file
  //     await File(filePath).writeAsBytes(image);
  //   } catch (err) {
  //     print(err.toString());
  //   }
  // }

  // Future<void> updateLocalProfilePic(UserModel user) async {
  //   try {
  //     final appDir = await syspaths.getApplicationDocumentsDirectory();
  //     final filePath = '${appDir.path}/${user.uid}/${user.profilePicId}';
  //     final file = File(filePath);

  //     if (await file.exists()) {
  //       print('Photo already exists locally.');
  //       return; // Photo already exists, no need to save it again
  //     }

  //     Reference profilePicRef = _storage
  //         .ref()
  //         .child('users/${user.uid}')
  //         .child('profilePic')
  //         .child(user.profilePicId);

  //     final downloadTask = profilePicRef.writeToFile(file);

  //     // Check if the photo already exists locally

  //     print('Photo saved locally.');
  //   } catch (err) {
  //     print(err.toString());
  //   }
  // }

  // Future<bool> _doesPhotoExistLocally(String fileName) async {
  //   // Check if the photo exists locally in the specified directory
  //   File file = File(fileName);
  //   return await file.exists();
  // }