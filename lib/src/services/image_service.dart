import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageService {
  Future<Uint8List?> getImageBytes(Reference ref) async {
    try {      
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await ref.getData(oneMegabyte);
      return data;
      
    } catch (e) {
      return null;
    }
    
  }



  Future<Uint8List> compressImage(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      quality: 5,
    );
    return result;
  }
}