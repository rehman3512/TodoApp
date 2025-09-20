import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/authController.dart';
import 'package:todoapp/Widgets/alternativeButton/alternativeButton.dart';
import 'package:todoapp/constants/appAssets/appAssets.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';
import 'package:todoapp/Widgets/gradiantcolor/gradiantcolor.dart';
import 'package:todoapp/Widgets/isLoading/isLoading.dart';
import 'package:todoapp/Widgets/textFormFieldWidget/textFormFieldWidget.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';
import 'package:todoapp/routes/approutes.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});
  final AuthController signupController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GradiantColor(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(AppAssets.whiteCheckMarkImage),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextWidget(
                            text: "Welcome to Do It",
                            color: AppColors.whiteColor,
                            fontsize: 25,
                            fontweight: FontWeight.w500),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextWidget(
                            text: "create an account and join us now!",
                            color: AppColors.whiteColor,
                            fontsize: 18,
                            fontweight: FontWeight.w500),
                      ),
                      SizedBox(height: 30),

                      // Full Name Field
                      TextFormFieldWidget(
                        controller: signupController.userController,
                        icon: Icon(Icons.person, color: AppColors.blackColor),
                        text: "Full Name",
                      ),
                      SizedBox(height: 30),

                      // Email Field
                      TextFormFieldWidget(
                        controller: signupController.emailController,
                        icon: Icon(Icons.email, color: AppColors.blackColor),
                        text: "E-mail",
                      ),
                      SizedBox(height: 30),

                      // Password Field
                      TextFormFieldWidget(
                        controller: signupController.passwordController,
                        icon: Icon(Icons.lock, color: AppColors.blackColor),
                        text: "Password",
                        obsecure: true,
                      ),
                      SizedBox(height: 40),

                      // Sign Up Button with manual validation
                      Obx(() {
                        return signupController.isLoading.value
                            ? Center(child: IsLoading())
                            : GestureDetector(
                          onTap: () {
                            if (signupController.userController.text.isEmpty) {
                              Get.snackbar("Error", "Full Name cannot be empty",
                                  backgroundColor: Colors.red, colorText: Colors.white);
                            } else if (signupController.emailController.text.isEmpty) {
                              Get.snackbar("Error", "Email cannot be empty",
                                  backgroundColor: Colors.red, colorText: Colors.white);
                            } else if (!GetUtils.isEmail(signupController.emailController.text)) {
                              Get.snackbar("Error", "Enter a valid email",
                                  backgroundColor: Colors.red, colorText: Colors.white);
                            } else if (signupController.passwordController.text.isEmpty) {
                              Get.snackbar("Error", "Password cannot be empty",
                                  backgroundColor: Colors.red, colorText: Colors.white);
                            } else if (signupController.passwordController.text.length < 6) {
                              Get.snackbar("Error", "Password must be at least 6 characters",
                                  backgroundColor: Colors.red, colorText: Colors.white);
                            } else {
                              signupController.signup();
                            }
                          },
                          child: Alternativebutton(text: "Sign up"),
                        );
                      }),
                      SizedBox(height: 15),

                      // Sign in option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                              text: "Already have an account?",
                              color: AppColors.whiteColor,
                              fontsize: 14,
                              fontweight: FontWeight.w500),
                          SizedBox(width: 5),
                          TextButton(
                            onPressed: () {
                              signupController.emailController.clear();
                              signupController.passwordController.clear();
                              signupController.userController.clear();
                              Get.toNamed(AppRoutes.signinScreen);
                            },
                            child: TextWidget(
                                text: "sign in",
                                color: AppColors.turquoiseColor,
                                fontsize: 14,
                                fontweight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Social signup
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            TextWidget(
                                text: "sign up with:",
                                color: AppColors.whiteColor,
                                fontsize: 14,
                                fontweight: FontWeight.w400),
                            SizedBox(width: 10),
                            Image.asset(AppAssets.googleButtonImage),
                            SizedBox(width: 10),
                            Image.asset(AppAssets.iphoneButtonImage),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
