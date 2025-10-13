import 'package:get/get.dart';
import 'package:sourceyangu/app/data/services/fetch_data_service.dart';
import 'package:sourceyangu/app/features/home/controllers/home_controllers.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductService>(() => ProductService());
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<ProductService>()),
    );
  }
}
