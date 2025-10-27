import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/data/models/product.dart';
import 'package:sourceyangu/app/features/products/views/products_helper_functions.dart';

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

  void toggleFavorite(Product product) {
    final toggle = (RxList<Product> list) {
      final index = list.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        list[index].isFavorite = !list[index].isFavorite;
        list.refresh(); // triggers UI update
      }
    };

    toggle(exactMatches);
    toggle(closeMatches);
    toggle(broaderMatches);
  }
}


// Controller for Product Detail View

class ProductDetailController extends GetxController {
  final Product product;

  late Rx<ProductVariantImage> selectedVariant;
  late RxString selectedSize;
  final RxInt quantity = 1.obs;

  ProductDetailController(this.product) {
    selectedVariant = ProductVariantImage.fromRaw(product.images.first).obs;
    selectedSize = ''.obs;
  }

  // Select a variant and reset size
  void selectVariant(ProductVariantImage variant) {
    selectedVariant.value = variant;
    selectedSize.value = '';
  }

  // Select a size and show feedback
  void selectSize(String? size) {
    if (size == null) return;
    selectedSize.value = size;
    Get.snackbar(
      "Size Selected",
      "You selected size $size",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }

  // Set quantity
  void setQuantity(int? q) {
    if (q == null) return;
    quantity.value = q;
  }

  // Get price based on selected size
  String get price {
    final raw = product.price.firstWhere(
      (p) => p.contains(selectedSize.value),
      orElse: () => '',
    );
    final parts = raw.split('.');
    return parts.length >= 3 ? parts[3] : '—';
  }

  // Parse all variants from raw image strings
  List<ProductVariantImage> get variants =>
      product.images.map(ProductVariantImage.fromRaw).toList();

  // Map of colorKey → available sizes
  Map<String, List<String>> get variantSizeMap {
    final map = <String, List<String>>{};
    for (var raw in product.sizes) {
      final parts = raw.split('.');
      final colorKey = '${parts[0]}.${parts[1]}';
      final size = parts[2];
      map.putIfAbsent(colorKey, () => []).add(size);
    }
    return map;
  }

  // Sizes available for the selected variant
  List<String> get availableSizes {
    return variantSizeMap[selectedVariant.value.colorKey] ?? [];
  }

  // Optional: parsed size labels for display
  List<Map<String, String>> get parsedSizes {
    return availableSizes.map((size) {
      final parts = selectedVariant.value.colorKey.split('.');
      return {
        'size': size,
        'label': 'Size $size (${parts[0]}/${parts[1]})',
        'raw': size,
      };
    }).toList();
  }
}

// class ProductDetailController extends GetxController {
//   final Product product;

//   late Rx<ProductVariantImage> selectedVariant;
//   late RxString selectedSize;
//   final RxInt quantity = 1.obs;

//   ProductDetailController(this.product) {
//     selectedVariant = ProductVariantImage.fromRaw(product.images.first).obs;
//     selectedSize = selectedVariant.value.size.obs;
//   }

//   void selectVariant(ProductVariantImage variant) {
//     selectedVariant.value = variant;
//     selectedSize.value = variant.size;
//   }

//   void selectSize(String? size) {
//     if (size == null) return;
//     selectedSize.value = size;
//     Get.snackbar(
//       "Size Selected",
//       "You selected size $size",
//       snackPosition: SnackPosition.BOTTOM,
//       duration: const Duration(seconds: 1),
//       backgroundColor: Colors.black87,
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(12),
//     );
//   }

//   void setQuantity(int? q) {
//     if (q == null) return;
//     quantity.value = q;
//   }

//   String get price {
//     final raw = product.price.firstWhere(
//       (p) => p.contains(selectedSize.value),
//       orElse: () => '',
//     );
//     final parts = raw.split('.');
//     return parts.length >= 3 ? parts[3] : '—';
//   }

//   List<Map<String, String>> get parsedSizes {
//     return product.sizes.map((raw) {
//       final parts = raw.split('.');
//       return {
//         'color': '${parts[0]}.${parts[1]}',
//         'size': parts[2],
//         'label': 'Size ${parts[2]} (${parts[0]}/${parts[1]})',
//         'raw': raw,
//       };
//     }).toList();
//   }

//   List<ProductVariantImage> get variants =>
//       product.images.map(ProductVariantImage.fromRaw).toList();
// }
