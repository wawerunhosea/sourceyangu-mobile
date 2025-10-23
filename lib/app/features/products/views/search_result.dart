import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/features/home/views/widgets.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final metadata = Get.arguments as String?;
    final labels = [
      "Primary Color",
      "Pattern",
      "Design",
      "Material",
      "Type",
      "Season",
      "Secondary Color",
      "Occasion",
      "Brand",
      "SleeveLength",
      "Target Audience",
    ];

    final values = metadata?.split(',') ?? [];
    final formatted = List.generate(labels.length, (i) {
      final value = i < values.length ? values[i].trim() : '—';
      return "${labels[i]}: ${value == 'null' ? '—' : value}";
    });

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TopBanner(),
            SizedBox(height: 20),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "This is a preview window placed to show you characteristics of what you captured so you can see how far I am",
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemCount: formatted.length,
                  separatorBuilder: (_, __) => Divider(),
                  itemBuilder:
                      (_, i) =>
                          Text(formatted[i], style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed:
                  () => Get.offAllNamed(
                    '/home',
                  ), // Navigates to home and clears stack
              icon: Icon(Icons.home),
              label: Text("Back to Home"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                iconColor: Colors.amberAccent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
