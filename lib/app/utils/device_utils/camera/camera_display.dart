// // UI, preview, format output

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/colors.dart';
import 'package:sourceyangu/app/features/home/views/widgets_layer2.dart';
import 'package:sourceyangu/app/utils/device_utils/camera/camera_service.dart';
import 'package:sourceyangu/app/utils/functions/image_handler.dart';

class Camera extends StatelessWidget {
  const Camera({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.camera_alt, color: Colors.amberAccent, size: 40),
      onPressed: () async {
        final imageBytes = await Get.dialog(ImagePickerDialog());
        if (imageBytes != null) {
          // Previewing image before uploading before returning
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WebPPreviewScreen(imageBytes: imageBytes),
            ),
          );
        }
      },
    );
  }
}

class ImagePickerDialog extends StatelessWidget {
  final CameraService cameraService = CameraService();

  ImagePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Search with Image',
          style: TextStyle(
            color: darkThemeGreydark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        'Choose how you’d like to add your image.',
        style: TextStyle(color: darkThemeGreylight),
      ),
      actionsPadding: const EdgeInsets.only(bottom: 16),
      actions: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: blackMain, size: 40),
                    onPressed:
                        () => _handleImageFlow(context, fromCamera: true),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or',
                      style: TextStyle(color: darkThemeGreylight),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_library, color: blackMain, size: 40),
                    onPressed:
                        () => _handleImageFlow(context, fromCamera: false),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Handles image from capture to returning compressed image to Camera widget where preview and upload is handled by WebPreview screen
  Future<void> _handleImageFlow(
    BuildContext context, {
    required bool fromCamera,
  }) async {
    try {
      final image =
          fromCamera
              ? await cameraService.captureImage()
              : await cameraService.pickFromGallery(context);

      if (image == null) {
        _showError("Failed to get image.");
        return;
      }

      final cropped = await imageCropper(image);
      if (cropped == null) {
        _showError("Cropping cancelled or failed.");
        return;
      }

      final compressed = await compressToWebP(cropped);
      if (compressed == null || compressed.isEmpty) {
        _showError("Compression failed.");
        return;
      }
      Get.back(result: compressed);
    } catch (e, stack) {
      _showError("Unexpected error occurred. $stack");
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Image Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}
