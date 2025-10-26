import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/colors.dart';
import 'package:sourceyangu/app/common/constants/resources.dart';
import 'package:sourceyangu/app/common/constants/sizes.dart';
import 'package:sourceyangu/app/common/constants/strings.dart';
import 'package:sourceyangu/app/data/models/product.dart';
import 'package:sourceyangu/app/features/auth/controllers/login_controller.dart';
import 'package:sourceyangu/app/features/auth/controllers/signup_controller.dart';
import 'package:sourceyangu/app/features/home/controllers/home_controllers.dart';
import 'package:sourceyangu/app/features/home/views/widgets_layer2.dart';
import 'package:sourceyangu/app/features/products/controllers/product_controller.dart';
import 'package:sourceyangu/app/features/products/views/products_helper_functions.dart';
import 'package:sourceyangu/app/features/products/views/search_results_grid.dart';
import 'package:sourceyangu/app/utils/device_utils/camera/camera_display.dart';

class TopBanner extends StatelessWidget {
  const TopBanner({super.key, this.hasShadow = true});
  final bool hasShadow;


  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController());
    }
    if (!Get.isRegistered<SignupController>()) {
      Get.lazyPut<SignupController>(() => SignupController());
    }
    final AuthController auth = Get.find<AuthController>();
    final SignupController auth2 = Get.find<SignupController>();

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: whiteMain,
        boxShadow:
            hasShadow
                ? [
          BoxShadow(
            color: darkThemeGreylight, // Shadow color
            spreadRadius: 0, // How wide the shadow spreads
            blurRadius: 6, // Softness of the shadow
            offset: Offset(0, 6), // Position: x, y
          ),
                ]
                : [],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          MenuButton(),

          SizedBox(width: 10),
          Text('Source', style: TextStyle(color: blackMain, fontSize: 18)),
          Text('Yangu', style: TextStyle(color: orangeMain, fontSize: 18)),
          Spacer(),
          Obx(
            () => TextButton(
              onPressed: () {
                Get.toNamed('/login');
              },
              child:
                  auth.isLoggedIn.value | auth2.isLoggedIn.value
                      ? AccountMenu()
                      : Text(
                        'Login',
                        style: TextStyle(color: darkThemeGreydark),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------

// Menu Items

class MenuButton extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {"id": 1, "title": "Solutions", "link": "/solutions"},
    {"id": 2, "title": "Products", "link": "/products"},
    {"id": 3, "title": "Services", "link": "/services"},
    {"id": 4, "title": "Partners", "link": "/partners"},
    {"id": 5, "title": "Support", "link": "/support"},
    {"id": 6, "title": "Learn", "link": "/learn"},
  ];

  MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white, // background color
          elevation: 0, // removes shadow
        ),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(Icons.menu, color: darkThemeGreydark),
        offset: Offset(-20, 50), // top-left-ish anchor
        onSelected: (route) {
          Navigator.pushNamed(context, route);
        },
        itemBuilder:
            (context) =>
                menuItems
                    .map(
                      (item) => PopupMenuItem<String>(
                        value: item['link'],
                        child: Text(item['title']),
                      ),
                    )
                    .toList(),
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Hero Section with Search Bar

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width
      height: 400, // Fixed height
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(imageUrl: heroImageLink, fit: BoxFit.cover),
          Container(
            color: const Color.fromARGB(
              255,
              0,
              0,
              0,
            ).withAlpha(120), // Blue overlay filter
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(12.0), // Add padding around the child
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    welcomeText,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  Text(
                    heroText,
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  CameraSearchBar(), // Custom search bar widget
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Search Bar with Camera Icon

class CameraSearchBar extends StatelessWidget {
  const CameraSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Camera(),
        SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by camera or text...',
                  hintStyle: TextStyle(color: whiteMain),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: whiteMain),
                    onPressed: () {
                      // Trigger text-based search
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: whiteMain),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onSubmitted: (value) {
                  // Optional: handle keyboard submit
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Shop by Category Section

class ShopByCategory extends StatelessWidget {
  ShopByCategory({super.key});

  final categories = [
    'Tops',
    'Bottom',
    'Dresses',
    'Shirts',
    'Shorts',
    'Accessories',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Shop by Category'),
        SizedBox(
          height: 400,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (_, i) => CategoryCard(title: categories[i]),
          ),
        ),
      ],
    );
  }
}
//---------------------------------------------------------------------------------------------------------------------------------------------------
// Category Card Widget

class CategoryCard extends StatelessWidget {
  final String title;
  const CategoryCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.fromLTRB(8, 20, 8, 20),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Product Card Widget

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const ProductCard({
    required this.product,
    required this.onTap,
    required this.onFavorite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final rawUrl = product.images[0];
    final variant = ProductVariantImage.fromRaw(rawUrl);
    final imageUrl = variant.imageUrl;
    print(imageUrl);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(
                        180,
                      ), // semi-transparent white
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.redAccent,
                        size: 15,
                      ),
                      onPressed: onFavorite,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.design,
                    style: TextTheme.of(
                      context,
                    ).titleMedium?.copyWith(color: darkThemeGreydark),
                    //Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ksh ${extractPrice(product)}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: orangeMain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Product Detail View

class ProductDetailView extends StatelessWidget {
  final Product product;

  const ProductDetailView({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final rawUrl = product.images[0];
    final variant = ProductVariantImage.fromRaw(rawUrl);

    try {
      final imageUrl = variant.imageUrl;

      return Scaffold(
        appBar: AppBar(title: Text(product.design)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Hero(
              tag: product.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 280,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => Image.network(
                        'https://i.pinimg.com/736x/4a/e3/22/4ae322bf6dac581b4d0f50954e63b62f.jpg',
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Ksh ${extractPrice(product)}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children:
                  product.tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Added to cart")));
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text("Add to Cart"),
            ),
          ],
        ),
      );
    } catch (e) {
      return Text(e.toString());
    }
  }
}


//---------------------------------------------------------------------------------------------------------------------------------------------------
// Featured Products Section

class FeaturedProducts extends StatelessWidget {
  final HomeController homeController = Get.find();
  final ProductController productController = Get.find();

  FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle('Featured Products'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.6,
            children: List.generate(homeController.featuredProducts.length, (
              i,
            ) {
              final product = homeController.featuredProducts[i];
              return Hero(
                tag: product.id,
                child: ProductCard(
                  product: product,
                  onTap:
                      () => Get.to(() => ProductDetailView(product: product)),
                  onFavorite: () => productController.toggleFavorite(product),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 1, indent: 16, endIndent: 16),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Featured product by Season Section

class FeaturedSeason extends StatelessWidget {
  const FeaturedSeason({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle('Seasonal Picks'),
        Container(
          height: 150,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text('Autumn Collection')),
        ),
      ],
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Footer Section

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      color: Colors.black87,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Subscribe to our newsletter',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(Icons.send),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Terms of Service',
                  style: TextStyle(color: Colors.amberAccent),
                ),
              ),
              Text(' | ', style: TextStyle(color: Colors.white)),
              Text('© 2025 SourceYangu', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------
// Section Title Widget

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
