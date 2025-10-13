import 'package:flutter/material.dart';
import 'package:sourceyangu/app/features/home/views/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBanner(), // Menu + Company Name + Login
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeroSection(),
                    ShopByCategory(),
                    //FeaturedProducts(),
                    FeaturedSeason(),
                    FooterSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
