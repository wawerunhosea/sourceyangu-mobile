import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/colors.dart';
import 'package:sourceyangu/app/data/models/product.dart';
import 'package:sourceyangu/app/features/home/views/widgets.dart';
import '../controllers/product_controller.dart';
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
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed("/cart"),
          icon: const Icon(Icons.shopping_cart),
          label: const Text("Cart"),
        ),
        body: Obx(
          () => CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: PinnedBannerDelegate(child: TopBanner()),
              ),
              if (controller.exactMatches.isEmpty &&
                  !controller.isLoading.value &&
                  (controller.closeMatches.isNotEmpty ||
                      controller.broaderMatches.isNotEmpty))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "0 exact matches. Check out alternatives",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              if (controller.exactMatches.isNotEmpty &&
                  !controller.isLoading.value)
                _buildSection("🎯 Perfect Picks", controller.exactMatches),
              if (controller.closeMatches.isNotEmpty &&
                  !controller.isLoading.value)
                _buildSection("✨ Closely Aligned", controller.closeMatches),
              if (controller.broaderMatches.isNotEmpty &&
                  !controller.isLoading.value)
                _buildSection("🧭 Worth Exploring", controller.broaderMatches),
              SliverToBoxAdapter(
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed('/home'),
                  icon: const Icon(Icons.home),
                  label: const Text("Back to Home"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blackMain,
                    foregroundColor: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: FooterSection()),
            ],
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
                    childAspectRatio: 0.53,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final sortedProducts = controller.applySort(products);
                    final product = sortedProducts[index];
                    // Buidng each product card
                    return Hero(
                      tag: product.id,
                      child: ProductCard(
                        product: product,
                        onTap:
                            () => Get.to(
                              () => ProductDetailView(product: product),
                              opaque: false,
                              fullscreenDialog: true,

                            ),
                        onFavorite: () => controller.toggleFavorite(product),
                      ),
                    );
                  },
                ),

              // Divider between sections
              const SizedBox(height: 24),
              // const Divider(thickness: 1, indent: 16, endIndent: 16),
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

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Pinned Banner Delegate

class PinnedBannerDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  PinnedBannerDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 100; // Adjust to your banner height
  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
