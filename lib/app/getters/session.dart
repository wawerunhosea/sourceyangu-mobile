import 'package:get/get.dart';
import 'package:sourceyangu/app/data/models/user.dart';
import 'package:sourceyangu/app/features/auth/controllers/login_controller.dart';

class Session {
  static final AuthController _auth = Get.find<AuthController>();

  // Reactive access to the current session
  static Rx<UserSession?> get _session => _auth.currentUser;

  // 🔹 Reactive login status
  static bool get isLoggedIn => _auth.isLoggedIn.value;

  // 🔹 Getters for session fields
  static String get uid => _session.value?.uid ?? '';
  static String get email => _session.value?.email ?? '';
  static String get displayName => _session.value?.displayName ?? '';
  static String get photoUrl => _session.value?.photoUrl ?? '';
  static String get googleId => _session.value?.googleId ?? '';
}
