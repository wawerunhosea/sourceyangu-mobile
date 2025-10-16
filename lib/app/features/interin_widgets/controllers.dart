import 'dart:async';
import 'package:get/get.dart';
import 'package:sourceyangu/app/routes/app_routes.dart';
import 'package:sourceyangu/app/utils/functions/image_handler.dart';

class UploadController extends GetxController {
  final statusIndex = 0.obs;
  final showFallback = false.obs;
  final isUploading = true.obs;

  final List<String> statusMessages = [
    "Analyzing image…",
    "Extracting metadata…",
    "Matching results…",
    "Finalizing upload…",
  ];

  late Timer _statusTimer;
  late Timer _fallbackTimer;

  void startStatusCycle() {
    _statusTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (statusIndex.value < statusMessages.length - 1) {
        statusIndex.value++;
      }
    });
  }

  void startFallbackTimer() {
    _fallbackTimer = Timer(const Duration(seconds: 13), () {
      showFallback.value = true;
    });
  }

  Future<void> beginUpload(imageBytes) async {
    final result = await uploadWebPImage(imageBytes);
    _statusTimer.cancel();
    _fallbackTimer.cancel();
    isUploading.value = false;

    if (result != null && result['success'] == true) {
      final metadata = result['metadata'] as String;
      Get.offAllNamed(AppRoutes.RESULTS, arguments: metadata);
      // ✅ replaces stack
    } else {
      Get.back();
      Get.snackbar(
        "Upload Failed",
        result?['error'] ?? "Could not upload image",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  @override
  void onClose() {
    _statusTimer.cancel();
    _fallbackTimer.cancel();
    super.onClose();
  }
}
