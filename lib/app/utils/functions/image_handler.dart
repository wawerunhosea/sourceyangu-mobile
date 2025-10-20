import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:sourceyangu/app/common/constants/api_endpoints.dart';
import 'package:sourceyangu/app/utils/device_utils/permission_manager.dart';
import 'package:sourceyangu/app/core/session/session_manager.dart';

// Cropping Image
Future<File?> imageCropper(XFile imageFile) async {
  try {
    final hasPhotos = await AppPermission.accessGallery();
    await AppPermission.accessGallery();
    if (!hasPhotos) {
      throw Exception(
        "Permission denied: READ_MEDIA_IMAGES or READ_EXTERNAL_STORAGE not granted.",
      );
    }

    if (imageFile.path.trim().isEmpty) {
      throw Exception("A fatal error has occured");
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Edit Photo',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.amber,
          dimmedLayerColor: Colors.black54,
          cropFrameColor: Colors.white,
          cropGridColor: Colors.grey,
          backgroundColor: Colors.black,
          showCropGrid: false,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );
    if (croppedFile == null) {
      return null;
    }

    return File(croppedFile.path);
  } catch (e) {
    return null;
  }
}

// Converting and Compressing Image
Future<Uint8List?> compressToWebP(File inputFile) async {
  final compressedImage = await FlutterImageCompress.compressWithFile(
    inputFile.absolute.path,
    format: CompressFormat.webp,
    quality: 85, // visually lossless range: 80–90
    minWidth: 1024, // optional resize
    keepExif: false, // strip metadata unless needed
  );
  return compressedImage;
}

// Uploading Image
Future<Map<String, dynamic>?> uploadWebPImage(Uint8List imageBytes) async {
  try {
    // 🔐 Load session from storage
    final session =
        await SessionManager.load(); // assumes this returns a FirebaseAuthSession or similar

    if (session == null || session.uid == '') {
      // 🚫 Session missing — show login prompt
      Get.snackbar(
        'Authentication Required',
        'Please log in to use image search.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () {
            Get.offAllNamed('/login'); // Redirect to login page
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        icon: GestureDetector(
          onTap: () {
            Get.closeCurrentSnackbar(); // Manually close the snackbar
          },
          child: Icon(Icons.close, color: Colors.white),
        ),
      );
      return {'success': false, 'error': 'User not logged in'};
    }

    try {
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse(imageSearch),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${session.uid}', // Adding the uid to the header
        },
        body: jsonEncode({'base64': base64Image}),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 && json['metadata'] != null) {
        return {'success': true, 'metadata': json['metadata']};
      } else {
        return {'success': false, 'error': json['error'] ?? 'Unknown error'};
        //Results returned to Search Button on WidgetLayer2
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  } catch (e) {
    print('Some auth related error occured');
  }
  return null;
}

// DownLoading Image
