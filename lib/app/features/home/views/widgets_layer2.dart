// Account menu widget with profile picture and options
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/colors.dart';
import 'package:sourceyangu/app/features/auth/controllers/login_controller.dart';
import 'package:sourceyangu/app/features/auth/controllers/signup_controller.dart';
import 'package:sourceyangu/app/utils/functions/image_handler.dart';

class AccountMenu extends StatelessWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    final SignupController auth2 = Get.find<SignupController>();

    return Obx(() {
      final user = auth.currentUser.value ?? auth2.currentUser.value;
      //final userOpt2 = auth2.currentUser.value;
      if (user == null) {
        return SizedBox.shrink();
      }
      return Theme(
        data: Theme.of(context).copyWith(
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.white, // background color
            elevation: 0, // removes shadow
          ),
        ),

        child: PopupMenuButton<String>(
          offset: Offset(20, 60),
          onSelected: (value) {
            switch (value) {
              case 'change':
                // Navigate to wallet page
                // image.picker
                Get.toNamed('/wallet');
                break;
              case 'wallet':
                // Navigate to wallet page
                Get.toNamed('/wallet');
                break;
              case 'logout':
                if (auth.isLoggedIn.value) {
                  auth.logout();
                }
                break;
            }
          },
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'change',
                  child: Text(
                    user.photoUrl != null ? 'Edit image' : 'Set image',
                  ),
                ),
                PopupMenuItem(value: 'wallet', child: Text('Wallet')),
                PopupMenuItem(value: 'logout', child: Text('Logout')),
              ],
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.photoUrl ?? '',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Icon(Icons.person),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Text(
                user.displayName ?? '',
                style: TextStyle(color: darkThemeGreydark),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class WebPPreviewScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const WebPPreviewScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Image")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: InteractiveViewer(
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => const Text("Failed to load image"),
                ),
              ),
            ),
          ),
          //const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            //const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                ElevatedButton.icon(
                  onPressed: () => Get.back(result: null),
                  //icon: const Icon(Icons.close),
                  label: const Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 224, 89, 89),
                  ),
                ),

                // Search Button
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await uploadWebPImage(imageBytes);

                    if (result != null && result['success'] == true) {
                      final metadata = result['metadata'] as String;

                      Get.toNamed('/RESULTS', arguments: metadata);
                    } else {
                      Get.snackbar(
                        "Upload Failed",
                        result?['error'] ?? "Could not upload image",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                  label: const Text("Search"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 6, 231, 36),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
