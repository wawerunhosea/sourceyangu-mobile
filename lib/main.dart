import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/theme/theme.dart';
import 'package:sourceyangu/app/routes/app_pages.dart';
import 'package:sourceyangu/app/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SourceYangu',
      initialRoute: AppRoutes.HOME,
      getPages: appPages,
      theme: AppTheme.lightTheme, // Optional
    );
  }
}
