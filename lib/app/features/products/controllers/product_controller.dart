import 'package:get/get.dart';
import 'package:sourceyangu/app/data/models/product.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var exactMatches = <Product>[].obs;
  var closeMatches = <Product>[].obs;
  var broaderMatches = <Product>[].obs;

  var selectedFilter = ''.obs;
  var selectedSort = 'default'.obs;

  void loadProducts({
    required List<Product> exact,
    required List<Product> close,
    required List<Product> broader,
  }) {
    exactMatches.assignAll(exact);
    closeMatches.assignAll(close);
    broaderMatches.assignAll(broader);
    isLoading.value = false;
  }

  void setFilter(String tag) {
    selectedFilter.value = selectedFilter.value == tag ? '' : tag;
  }

  void setSort(String sortKey) {
    selectedSort.value = sortKey;
  }

  int extractPrice(Product p) {
    try {
      final raw = p.price.first;
      final parts = raw.split('.');
      return int.tryParse(parts.last) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  List<Product> applySort(List<Product> products) {
    switch (selectedSort.value) {
      case 'priceLow':
        return [...products]
          ..sort((a, b) => extractPrice(a).compareTo(extractPrice(b)));
      case 'priceHigh':
        return [...products]
          ..sort((a, b) => extractPrice(b).compareTo(extractPrice(a)));
      case 'rating':
        return [...products]
          ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
      default:
        return products;
    }
  }
}
