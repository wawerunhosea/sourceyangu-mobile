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
  const TopBanner({super.key});

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
        boxShadow: [
          BoxShadow(
            color: darkThemeGreylight, // Shadow color
            spreadRadius: 0, // How wide the shadow spreads
            blurRadius: 6, // Softness of the shadow
            offset: Offset(0, 6), // Position: x, y
          ),
        ],
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

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2,
      child: Column(
        children: [
          Expanded(
            child:
                product.imageUrl != null
                    ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                    : Icon(Icons.image, size: 64),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('\$${product.price.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
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
            (i) => ProductCard(product: controller.featuredProducts[i]),
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
