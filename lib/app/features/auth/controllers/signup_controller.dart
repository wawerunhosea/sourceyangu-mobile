import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/api_endpoints.dart';
import 'package:sourceyangu/app/core/session/session_manager.dart';
import 'package:sourceyangu/app/data/models/user.dart';
import 'package:sourceyangu/app/service/authentification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupController extends GetxController {
  // Form fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // Reactive state
  var nameError = RxnString();
  var emailError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();
  var generalError = RxnString();
  var isLoading = false.obs;

  // Initializing controllers
  @override
  void onInit() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.onInit();
    hydrateSession();
  }

  // Visibility toggles
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  // Outcomes
  final Rx<UserSession?> currentUser = Rx(null);
  final RxBool isLoggedIn = false.obs;

  // Internal validators
  String? _validateName(String? name) {
    if (name == null || name.trim().isEmpty) return 'Name is required';
    if (name.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? _validateEmail(String? email) {
    final regex = RegExp(
      r"^[\w.-]+@([\w-]+\.)+(com|org|net|edu|gov|mil|int|co|io|ai|biz|info|me|us|uk|ca|de|fr|au)$",
    );
    if (email == null || email.trim().isEmpty) return 'Email is required';
    if (!regex.hasMatch(email.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? password) {
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$',
    );
    if (password == null || password.trim().isEmpty) {
      return 'Password is required';
    }
    if (!regex.hasMatch(password.trim())) {
      return 'Password must be 8–16 characters, include uppercase, lowercase, a number, and a special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }

  // Initializing Secure Storage

  Future<void> hydrateSession() async {
    final session = await SessionManager.load();
    if (session != null) {
      currentUser.value = session;
      isLoggedIn.value = true;
    }
  }

  // Unified form validator
  bool validateForm({bool isSignUp = false}) {
    emailError.value = _validateEmail(emailController.text);
    passwordError.value = _validatePassword(passwordController.text);
    generalError.value = null;

    if (isSignUp) {
      nameError.value = _validateName(nameController.text);
      confirmPasswordError.value = _validateConfirmPassword(
        passwordController.text,
        confirmPasswordController.text,
      );
      return nameError.value == null &&
          emailError.value == null &&
          passwordError.value == null &&
          confirmPasswordError.value == null;
    }

    return emailError.value == null && passwordError.value == null;
  }

  // Google Sign-UP logic

  Future<void> handleGoogleSignIn() async {
    isLoading.value = true;

    try {
      final result = await AuthService().signInWithGoogle();
      isLoading.value = false;

      if (!result.isSuccess) {
        generalError.value = result.error;
      } else {
        currentUser.value = result.session;
        isLoggedIn.value = true;
        await SessionManager.save(result.session!);
        Get.offAllNamed('/home');
      }
    } catch (e) {
      isLoading.value = false; // ✅ ensure loading stops even on error
      generalError.value = 'Unexpected error: $e';
    }
  }

  ///TODO: Implement Apple Sign-In
  Future<void> handleAppleSignIn() async {
    isLoading.value = true;
    final result = await AuthService().signInWithApple();
    isLoading.value = false;
    // Capture session
    // Save Session
    // await SessionManager.save(result.session!);

    if (result != null) {
      generalError.value = result;
    } else {
      // Navigate to home or onboarding
    }
  }

  // Sign up logic
  Future<void> signUp() async {
    if (!validateForm(isSignUp: true)) return;

    isLoading.value = true;
    final result = await AuthService().signUp(
      emailController.text,
      passwordController.text,
    );
    isLoading.value = false;

    if (!result.isSuccess) {
      generalError.value = result.error;
    } else {
      currentUser.value = result.session;

      isLoggedIn.value = true;
      Get.offAllNamed('/home');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Saving user on backend

  Future<String> registerUserOnBackend({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    final url = Uri.parse(createUser); // Replace with your actual endpoint

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Optional: include Firebase ID token for verification
        // 'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'uid': uid,
        'email': email,
        'displayName': displayName,
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Some error occured';
    }
  }

  Future<Map<String, dynamic>?> updateProfilePicture(
    Uint8List imageBytes,
    String uid,
  ) async {
    final base64Image = base64Encode(imageBytes);

    Future<http.Response> _attemptUpload() {
      return http.post(
        Uri.parse(imageSearch),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'base64': base64Image, 'uid': uid}),
      );
    }

    try {
      http.Response response = await _attemptUpload();

      if (response.statusCode != 200 || response.body.isEmpty) {
        response = await _attemptUpload(); // Silent retry
      }

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 && json['metadata'] != null) {
        return {'error': null, 'image': json['metadata']['url']};
      }
    } catch (e) {
      return {'error': e.toString(), 'image': null};
    }

    return {'error': 'Upload failed silently', 'image': null};
  }
}
