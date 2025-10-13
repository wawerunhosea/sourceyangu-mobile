import 'package:get/get.dart';
import 'package:sourceyangu/app/data/models/product.dart';
import 'package:sourceyangu/app/data/services/fetch_data_service.dart';

class HomeController extends GetxController {
  //final AuthController auth = Get.find<AuthController>();
  final ProductService _productService;

  HomeController(this._productService);

  RxList<String> categories = <String>[].obs;
  RxList<Product> featuredProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedProducts();
    fetchCategories();
  }

  void fetchFeaturedProducts() async {
    try {
      final products = await _productService.getFeaturedProducts();
      featuredProducts.assignAll(products);
    } catch (e) {
      Get.snackbar('Error', 'Could not fetch products');
    }
  }

  void fetchCategories() async {
    try {
      final fetchedCategories = await _productService.getCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      Get.snackbar('Error', 'Could not fetch categories');
    }
  }
}
