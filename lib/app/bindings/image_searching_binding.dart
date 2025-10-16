import 'package:get/get.dart';
import 'package:sourceyangu/app/features/interin_widgets/controllers.dart';

class ImageSeachingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadController>(() => UploadController());
  }
}
