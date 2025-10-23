import 'package:get/get.dart';
import 'package:sourceyangu/app/features/products/controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
