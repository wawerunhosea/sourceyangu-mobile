// Cropping Image

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sourceyangu/app/utils/device_utils/permission_manager.dart';

Future<File?> imageCropper(XFile imageFile) async {
  try {
    final hasPhotos = await PermissionManager.ensure(
      Permission.photos,
      'READ_MEDIA_IMAGES',
    );
    await PermissionManager.ensure(Permission.photos, 'READ_MEDIA_IMAGES');
    if (!hasPhotos) {
      throw Exception("Missing media image permission for cropping.");
    }

    if (imageFile.path.trim().isNotEmpty) {}

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

// Compressing Image
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
    final base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse(
        'https://backend-sourceyangu-phi.vercel.app/api/ai_endpoint.ts',
      ),
      headers: {'Content-Type': 'application/json'},
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
}

// DownLoading Image
