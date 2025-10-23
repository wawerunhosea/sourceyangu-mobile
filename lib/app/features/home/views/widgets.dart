import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/colors.dart';
import 'package:sourceyangu/app/common/constants/resources.dart';
import 'package:sourceyangu/app/common/constants/strings.dart';
import 'package:sourceyangu/app/data/models/product.dart';
import 'package:sourceyangu/app/features/auth/controllers/login_controller.dart';
import 'package:sourceyangu/app/features/auth/controllers/signup_controller.dart';
import 'package:sourceyangu/app/features/home/controllers/home_controllers.dart';
import 'package:sourceyangu/app/features/home/views/widgets_layer2.dart';
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



class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onAddToFavorites;
  final VoidCallback onAddToConsidering;

  const ProductCard({
    required this.product,
    required this.onAddToCart,
    required this.onAddToFavorites,
    required this.onAddToConsidering,
    super.key,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String selectedVariant = "";

  @override
  void initState() {
    super.initState();
    selectedVariant =
        widget.product.sizes.isNotEmpty ? widget.product.sizes.first : "";
  }

  String extractImageUrl(String raw) {
    final parts = raw.split('.');
    return parts.length >= 4 ? parts.sublist(3).join('.') : raw;
  }

  String extractPrice(String variant) {
    final match = widget.product.price.firstWhere(
      (p) => p.startsWith(variant),
      orElse: () => "",
    );
    return match.isNotEmpty ? match.split('.').last : "N/A";
  }

  String extractStock(String variant) {
    final match = widget.product.stockQuantity.firstWhere(
      (s) => s.startsWith(variant),
      orElse: () => "",
    );
    return match.isNotEmpty ? match.split('.').last : "0";
  }

  bool hasOffer(String variant) {
    return widget.product.onOffer.any((o) => o.toString().contains(variant));
  }

  void showCareInstructions() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Care Instructions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...widget.product.careInstruction.map(
                  (c) => ListTile(title: Text(c)),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = extractImageUrl(
      widget.product.images.firstWhere(
        (img) => img.contains(selectedVariant),
        orElse: () => widget.product.images.first,
      ),
    );
    final price = extractPrice(selectedVariant);
    final stock = extractStock(selectedVariant);
    final inStock = widget.product.inStock;

    return Dismissible(
      key: Key(widget.product.id),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.visibility),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.favorite),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          widget.onAddToConsidering();
        } else {
          widget.onAddToFavorites();
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (hasOffer(selectedVariant))
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "On Offer",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (widget.product.isExactMatch)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Exact Match",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.brand,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    widget.product.design,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "KES $price",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    inStock ? "In Stock ($stock left)" : "Out of Stock",
                    style: TextStyle(
                      color: inStock ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (widget.product.rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        Text("${widget.product.rating}/5"),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children:
                        widget.product.tags
                            .map((tag) => Chip(label: Text(tag)))
                            .toList(),
                  ),
                  const SizedBox(height: 12),

                  // Variant selector
                  if (widget.product.sizes.isNotEmpty)
                    DropdownButton<String>(
                      value: selectedVariant,
                      items:
                          widget.product.sizes.map((variant) {
                            return DropdownMenuItem(
                              value: variant,
                              child: Text(variant),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedVariant = value);
                        }
                      },
                    ),

                  const SizedBox(height: 12),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: showCareInstructions,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text("Add to Cart"),
                        onPressed: widget.onAddToCart,
                      ),
                    ],
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


class FeaturedProducts extends StatelessWidget {
  final HomeController controller = Get.find();

  FeaturedProducts({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Featured Products'),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(
            4,
            (i) => ProductCard(
              //TODO: check out if correct
              product: controller.featuredProducts[i],
              onAddToCart: () {},
              onAddToFavorites: () {},
              onAddToConsidering: () {},
            ),
          ),
        ),
      ],
    );
  }
}

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
