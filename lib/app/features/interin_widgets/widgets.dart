import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:sourceyangu/app/features/interin_widgets/controllers.dart';

class UploadProgressOverlay extends StatelessWidget {
  const UploadProgressOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UploadController>();

    // Extract arguments passed via Get.toNamed
    final Uint8List imageBytes = Get.arguments['imageBytes'];

    // Start upload logic
    controller.startStatusCycle();
    controller.startFallbackTimer();
    controller.beginUpload(imageBytes);

    return Scaffold(
      backgroundColor: Colors.black.withAlpha(216),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Scanning Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.orangeAccent, blurRadius: 12),
                ],
              ),
              child: const LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Colors.black26,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),

            // Status Text
            Obx(
              () => Text(
                controller.statusMessages[controller.statusIndex.value],
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ),

            const SizedBox(height: 30),

            // Image Preview with Overlay
            Obx(
              () => Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(imageBytes, width: 200),
                  ),
                  if (controller.isUploading.value)
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Processing...",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Fallback Easter Egg
            Obx(
              () =>
                  controller.showFallback.value
                      ? Text(
                        "Still working… good things take time 🧠",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      )
                      : const SizedBox.shrink(),
            ),

            const SizedBox(height: 40),

            // Cancel Button
            TextButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.cancel, color: Colors.white),
              label: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
