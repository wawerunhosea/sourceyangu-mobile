// Capturing, storing, advanced settings

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sourceyangu/app/utils/device_utils/permission_manager.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> captureImage() async {
    final granted = await AppPermission.accessCamera();

    if (!granted) return null;
    return await _picker.pickImage(source: ImageSource.camera);
  }

  Future<XFile?> pickFromGallery(BuildContext context) async {
    await AppPermission.accessGallery();

    try {
      return await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      return await showDialog<XFile?>(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text('Gallery Error'),
              content: Text(
                'Something went wrong while accessing the gallery.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }
}

// QR Scanner

class ScannerService {
  final MobileScannerController controller = MobileScannerController();

  Future<bool> ensureCameraPermission() async {
    return await PermissionManager.ensure(
      Permission.camera,
      'scanner_camera_permission',
    );
  }

  void dispose() {
    controller.dispose();
  }
}


  // try {
  //     print(apiLevel);
  //     if(apiLevel > 26 && apiLevel < 29){
  //       await PermissionManager.ensure(Permission.photos, 'READ_MEDIA_IMAGES');
  //     }
    // } catch (e) {}