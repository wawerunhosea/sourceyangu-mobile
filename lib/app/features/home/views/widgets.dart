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
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white, // semi-transparent white
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
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
    final controller = Get.put(ProductDetailController(product));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: darkThemeGreydark,
            onPressed: () => Get.back(),
          ),
          title: Text(
            product.design,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: blackMain),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              color: Colors.redAccent,
              onPressed: () {
                // TODO: Handle favorite toggle
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              color: darkThemeGreydark,
              onPressed: () {
                // TODO: Navigate to cart
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 16.0, 10, 16.0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with overlayed thumbnails
                  Stack(
                    children: [
                      Hero(
                        tag: product.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: CachedNetworkImage(
                              key: ValueKey(
                                controller.selectedVariant.value.imageUrl,
                              ),
                              imageUrl:
                                  controller.selectedVariant.value.imageUrl,
                              height: 550,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget:
                                  (context, url, error) => Image.network(
                                    'https://i.pinimg.com/736x/4a/e3/22/4ae322bf6dac581b4d0f50954e63b62f.jpg',
                                    height: 280,
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              controller.variants.map((v) {
                                final isSelected =
                                    v.imageUrl ==
                                    controller.selectedVariant.value.imageUrl;
                                return GestureDetector(
                                  onTap: () => controller.selectVariant(v),
                                  child: AnimatedScale(
                                    scale: isSelected ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(220),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Colors.blue
                                                  : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(100),
                                            blurRadius: 4,
                                            offset: const Offset(1, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: CachedNetworkImage(
                                          imageUrl: v.imageUrl,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  DropdownButton<String>(
                    value:
                        controller.selectedSize.value.isNotEmpty &&
                                controller.availableSizes.contains(
                                  controller.selectedSize.value,
                                )
                            ? controller.selectedSize.value
                            : null,
                    hint: const Text("Select Size"),
                    items:
                        controller.availableSizes.map((size) {
                          return DropdownMenuItem<String>(
                            value: size,
                            child: Text("Size $size"),
                          );
                        }).toList(),
                    onChanged: controller.selectSize,
                  ),
                  const SizedBox(height: 16),
          
                  // Rating + Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 4),
                          Text("5.0"),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Quantity: "),
                          DropdownButton<int>(
                            value: controller.quantity.value,
                            items:
                                List.generate(10, (i) => i + 1)
                                    .map(
                                      (q) => DropdownMenuItem(
                                        value: q,
                                        child: Text("$q"),
                                      ),
                                    )
                                    .toList(),
                            onChanged: controller.setQuantity,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      "Ksh ${controller.price}",
                      key: ValueKey(controller.price),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum.",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class ProductDetailView extends StatelessWidget {
//   final Product product;

//   const ProductDetailView({required this.product, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProductDetailController(product));

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             color: darkThemeGreydark,
//             onPressed: () => Get.back(),
//           ),
//           title: Text(
//             product.design,
//             style: Theme.of(
//               context,
//             ).textTheme.headlineSmall?.copyWith(color: blackMain),
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.favorite_border),
//               color: Colors.redAccent,
//               onPressed: () {
//                 // TODO: Handle favorite toggle
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.shopping_cart_outlined),
//               color: darkThemeGreydark,
//               onPressed: () {
//                 // TODO: Navigate to cart
//               },
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.fromLTRB(10, 16.0, 10, 16.0),
//           child: Obx(
//             () => Column(
//               children: [
//                 // Top section: Variants + Image
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Left column: Variants + Size selector
//                     Column(
//                       children: [
//                         // Variant thumbnails
//                         SizedBox(
//                           width: 60,
//                           child: Column(
//                             children:
//                                 controller.variants.map((v) {
//                                   final isSelected =
//                                       v.imageUrl ==
//                                       controller.selectedVariant.value.imageUrl;
//                                   return GestureDetector(
//                                     onTap: () => controller.selectVariant(v),
//                                     child: Container(
//                                       margin: const EdgeInsets.symmetric(
//                                         vertical: 4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                           color:
//                                               isSelected
//                                                   ? Colors.blue
//                                                   : Colors.grey.shade300,
//                                           width: 2,
//                                         ),
//                                         borderRadius: BorderRadius.circular(6),
//                                       ),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(6),
//                                         child: CachedNetworkImage(
//                                           imageUrl: v.imageUrl,
//                                           width: 60,
//                                           height: 60,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                           ),
//                         ),
//                         const SizedBox(height: 12),

//                         // Size selector
//                         DropdownButton<String>(
//                           value:
//                               controller.selectedSize.value.isNotEmpty &&
//                                       product.sizes.contains(
//                                         controller.selectedSize.value,
//                                       )
//                                   ? controller.selectedSize.value
//                                   : null,
//                           items:
//                               product.sizes
//                                   .toSet() // removes duplicates
//                                   .map(
//                                     (size) => DropdownMenuItem<String>(
//                                       value: size,
//                                       child: Text(size),
//                                     ),
//                                   )
//                                   .toList(),
//                           onChanged: controller.selectSize,
//                         ),
//                       ],
//                     ),
//                     //const SizedBox(width: 16),
//                     // Right column: Main image
//                     Expanded(
//                       child: Hero(
//                         tag: product.id,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: AnimatedSwitcher(
//                             duration: const Duration(milliseconds: 300),
//                             child: CachedNetworkImage(
//                               key: ValueKey(
//                                 controller.selectedVariant.value.imageUrl,
//                               ),
//                               imageUrl:
//                                   controller.selectedVariant.value.imageUrl,
//                               height: 550,
//                               fit: BoxFit.cover,
//                               placeholder:
//                                   (context, url) => const Center(
//                                     child: CircularProgressIndicator(),
//                                   ),
//                               errorWidget:
//                                   (context, url, error) => Image.network(
//                                     'https://i.pinimg.com/736x/4a/e3/22/4ae322bf6dac581b4d0f50954e63b62f.jpg',
//                                     height: 280,
//                                     fit: BoxFit.cover,
//                                   ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // Rating + Quantity row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: const [
//                         Icon(Icons.star, color: Colors.amber),
//                         SizedBox(width: 4),
//                         Text("5.0"),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         const Text("Quantity: "),
//                         DropdownButton<int>(
//                           value: controller.quantity.value,
//                           items:
//                               List.generate(10, (i) => i + 1)
//                                   .map(
//                                     (q) => DropdownMenuItem(
//                                       value: q,
//                                       child: Text("$q"),
//                                     ),
//                                   )
//                                   .toList(),
//                           onChanged: controller.setQuantity,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 // Price
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 300),
//                     child: Text(
//                       "Ksh ${controller.price}",
//                       key: ValueKey(controller.price),
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Description
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Description",
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum Lorem Ipsum.",
//                   style: TextStyle(color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


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
