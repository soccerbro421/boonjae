import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

class ImageService {
  // Future<bool> _requestPermission(Permission permission) async {
  //   if (await permission.isGranted) {
  //     return true;
  //   } else {
  //     final result = await permission.request();
  //     if (result == PermissionStatus.granted) {
  //       return true;
  //     }
  //     return false;
  //   }
  // }

  pickMedia() async {
    // final permissionStatus = await _requestPermission(Permission.photos);

    // if (!permissionStatus) {
    //   // Handle the case where permission is not granted
    //   // You can show a dialog or a snackbar to inform the user
    //   // about the required permission

    //   return "ERROR";
    // }

    const source = ImageSource.gallery;

    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) {
      return null;
    } else {
      final file = File(pickedFile.path);

      final croppedFile = await cropSquareImage(file);

      if (croppedFile == null) {
        return null;
      }

      final xfile = XFile(croppedFile.path);

      return xfile.readAsBytes();
    }
  }

  cropSquareImage(File imageFile) async => await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 1,
        // compressFormat: ImageCompressFormat.jpg,
        // androidUiSettingsLocked: androidUiSettingsLocked(),
        // iosUiSettings: iosUiSettingsLocked(),
      );

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }

    return null;
  }

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
      quality: 1,
    );
    return result;
  }
}
