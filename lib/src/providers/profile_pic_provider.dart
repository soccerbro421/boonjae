import 'package:boonjae/src/models/user_model.dart';
import 'package:boonjae/src/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ProfilePicProvider with ChangeNotifier {
  Uint8List? _image;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Uint8List get getImage {
    if (_image == null) {
      return Uint8List(1);
    }

    return _image!;
  }

  Future<void> refreshProfilePic(UserModel user) async {
    Reference ref = _storage
              .ref()
              .child('users/${user.uid}')
              .child('profilePic');

    _image = await UserService().getImageBytes(ref);

    notifyListeners();
  }

}