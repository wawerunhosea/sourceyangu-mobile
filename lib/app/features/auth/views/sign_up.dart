import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/colors.dart';
import 'package:sourceyangu/app/features/auth/controllers/signup_controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SignupController>()) {
      Get.lazyPut<SignupController>(() => SignupController());
    }

    final controller = Get.find<SignupController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.person_add, size: 48),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Join us at ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Source',
                              style: TextStyle(
                                color: blackMain,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Yangu',
                              style: TextStyle(
                                color: orangeMain,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Email and password Signup
                  TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      errorText: controller.nameError.value,
                    ),
                  ),
                  SizedBox(height: 16),

                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: controller.emailError.value,
                    ),
                  ),
                  SizedBox(height: 16),

                  Obx(
                    () => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        errorText: controller.passwordError.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => controller.isPasswordHidden.toggle(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  Obx(
                    () => TextField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        errorText: controller.confirmPasswordError.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => controller.isConfirmPasswordHidden.toggle(),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Loading indicator
                  ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.signUp,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(48),
                    ),
                    child:
                        controller.isLoading.value
                            ? CircularProgressIndicator()
                            : Text(
                              'Sign up',
                              style: TextStyle(
                                color: blackMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),

                  if (controller.generalError.value != null) ...[
                    SizedBox(height: 12),
                    Text(
                      controller.generalError.value!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],

                  SizedBox(height: 24),
                  Center(child: Text('or')),
                  SizedBox(height: 16),

                  // Sign up with Google
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.handleGoogleSignIn,
                      icon: SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset('assets/images/google-logo.png'),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Continue with Google',
                          style: TextStyle(color: blackMain),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),

                  // Apple sign up
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        () => controller.handleAppleSignIn;
                      },
                      icon: Icon(Icons.apple, size: 32),
                      label: const Text(
                        'Continue with Apple',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  Center(
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Already have an account?'),
                        ),
                        TextButton(
                          onPressed: () => {Get.toNamed('/login')},
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              color: orangeMain,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
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
