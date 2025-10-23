import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/colors.dart';
import 'package:sourceyangu/app/data/models/product.dart';
import 'package:sourceyangu/app/features/home/views/widgets.dart';
import '../controllers/product_controller.dart';
// import '../widgets/product_card.dart';
// import '../models/product.dart';
import 'package:shimmer/shimmer.dart';

class ProductResultsView extends StatelessWidget {
  final controller = Get.put(ProductController());

  ProductResultsView({
    required List<Product> exactMatches,
    required List<Product> closeMatches,
    required List<Product> broaderMatches,
    super.key,
  }) {
    controller.loadProducts(
      exact: exactMatches,
      close: closeMatches,
      broader: broaderMatches,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: controller.setSort,
            itemBuilder:
                (context) => const [
                  PopupMenuItem(
                    value: "priceLow",
                    child: Text("Price: Low to High"),
                  ),
                  PopupMenuItem(
                    value: "priceHigh",
                    child: Text("Price: High to Low"),
                  ),
                  PopupMenuItem(value: "rating", child: Text("Top Rated")),
                ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed("/cart"),
        icon: const Icon(Icons.shopping_cart),
        label: const Text("Cart"),
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            _buildFilterChips(),
            if (controller.exactMatches.isEmpty && !controller.isLoading.value)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "We couldn’t find a perfect match, but here are some great alternatives.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            _buildSection("🎯 Perfect Picks", controller.exactMatches),
            _buildSection("✨ Closely Aligned", controller.closeMatches),
            _buildSection("🧭 Worth Exploring", controller.broaderMatches),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildFilterChips() {
    final tags = ['cotton', 'ecoFriendly', 'stripes', 'denim', 'normalDay'];
    return SliverToBoxAdapter(
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children:
                tags.map((tag) {
                  final isSelected = controller.selectedFilter.value == tag;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (_) => controller.setFilter(tag),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, RxList<Product> products) {
    return SliverToBoxAdapter(
      child: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(Get.context!).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${products.length} found",
                        style: Theme.of(Get.context!).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              if (controller.isLoading.value)
                _buildShimmerGrid(title, products)
              else if (products.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No products found in $title",
                        style: Theme.of(Get.context!).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Try adjusting your filters or explore other categories.",
                        style: Theme.of(
                          Get.context!,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => Get.offAllNamed('/home'),
                        icon: const Icon(Icons.home),
                        label: const Text("Back to Home"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blackMain,
                          foregroundColor: whiteMain,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final sortedProducts = controller.applySort(products);
                    final product = sortedProducts[index];
                    return Hero(
                      tag: product.id,
                      child: ProductCard(
                        product: product,
                        onAddToCart: () {},
                        onAddToFavorites: () {},
                        onAddToConsidering: () {},
                      ),
                    );
                  },
                ),

              // Divider between sections
              const SizedBox(height: 24),
              const Divider(thickness: 1, indent: 16, endIndent: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(String title, RxList<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            "Loading $title...",
            style: Theme.of(
              Get.context!,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
