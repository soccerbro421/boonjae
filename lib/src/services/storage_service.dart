
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  Future<String> uploadImageToStorageByReference(Reference ref, Uint8List file) async {
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

}