import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/image_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ProfilePicProvider with ChangeNotifier {
  Uint8List? _image;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Uint8List get getImage {
    if (_image == null) {
      // Uint8List placeholder = Uint8List(3);
      // placeholder[0] = 255;
      // placeholder[1] = 255;
      // placeholder[2] = 255;
      // return placeholder;

      int width = 100; // Width of the square
      int height = 100; // Height of the square

      // Create an image with a purple square
      img.Image image = img.Image(height: height, width: width);
      img.fill(image,
          color: img.ColorFloat16(3)); // RGB for purple (255, 0, 255)

      // Encode the image to PNG format
      List<int> pngBytes = img.encodePng(image);

      // Convert the PNG bytes to Uint8List
      Uint8List result = Uint8List.fromList(pngBytes);

      return result;
    }

    // print(_image);

    return _image!;
  }

  Future<void> refreshProfilePic(UserModel user) async {
    Reference ref =
        _storage.ref().child('users/${user.uid}').child('profilePic');

    _image = await ImageService().getImageBytes(ref);

    notifyListeners();
  }
}
