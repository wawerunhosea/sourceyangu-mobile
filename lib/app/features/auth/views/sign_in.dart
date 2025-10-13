import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sourceyangu/app/common/constants/colors.dart';
import 'package:sourceyangu/app/features/auth/controllers/login_controller.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController());
    }

    final controller = Get.find<AuthController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle, size: 48),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome back to ',
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

                  // SIgn in with email and password
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
                          onPressed: () {
                            controller.isPasswordHidden.toggle();
                          },
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {}, // TODO: Forgot password flow
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: const Color.fromARGB(0, 51, 50, 50),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.signIn,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(48),
                    ),
                    child:
                        controller.isLoading.value
                            ? CircularProgressIndicator()
                            : Text(
                              'Sign in',
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

                  // Google Sign-In ----

                  // TODO: use this to check if new user

                  //final user = FirebaseAuth.instance.currentUser;
                  //final isNewUser = user?.metadata.creationTime == user?.metadata.lastSignInTime;
                  SizedBox(
                    width:
                        double.infinity, // Makes the button stretch full width
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

                  SizedBox(height: 16),

                  // Apple Sign-In ----
                  SizedBox(
                    width:
                        double.infinity, // Makes the button stretch full width
                    child: ElevatedButton.icon(
                      onPressed: () {
                        () => controller.handleAppleSignIn;
                      },
                      icon: Icon(
                        Icons.apple,
                        size: 32, // Increase icon size here
                      ),
                      label: const Text(
                        'Continue with Apple',
                        style: TextStyle(
                          fontSize: 16,
                        ), // Optional: adjust text size
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ), // Add padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // Optional: rounded corners
                        ),
                        elevation: 2, // Optional: subtle shadow
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text('Don\'t have an account?'),
                            ),
                            TextButton(
                              onPressed: () => {Get.toNamed('/signup')},
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color: orangeMain,
                                  fontSize:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
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
