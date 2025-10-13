import 'package:get/get.dart';
import 'package:sourceyangu/app/bindings/auth_binding.dart';
import 'package:sourceyangu/app/bindings/home_binding.dart';
import 'package:sourceyangu/app/features/auth/views/sign_in.dart';
import 'package:sourceyangu/app/features/auth/views/sign_up.dart';
import 'package:sourceyangu/app/features/home/views/home_view.dart';
import 'package:sourceyangu/app/features/products/views/search_result.dart';
import 'package:sourceyangu/app/routes/app_routes.dart';

final List<GetPage> appPages = [
  GetPage(name: AppRoutes.HOME, page: () => HomeView(), binding: HomeBinding()),

  GetPage(
    name: AppRoutes.SIGNIN,
    page: () => const SignInView(),
    binding: AuthBinding(),
  ),

  GetPage(
    name: AppRoutes.SIGNUP,
    page: () => const SignUpView(),
    binding: AuthBinding(),
  ),

  GetPage(name: '/RESULTS', page: () => ResultsScreen()),
];
