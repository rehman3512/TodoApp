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

class SignInView extends StatelessWidget {
  SignInView({super.key});

  final AuthController signinController = Get.put(AuthController());

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
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Image.asset(AppAssets.whiteCheckMarkImage)),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextWidget(
                            text: "Welcome Back to DO IT ",
                            color: AppColors.whiteColor,
                            fontsize: 25,
                            fontweight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextWidget(
                            text: "Have an other productive day !",
                            color: AppColors.whiteColor,
                            fontsize: 18,
                            fontweight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormFieldWidget(
                        icon: Icon(
                          Icons.email,
                          color: AppColors.blackColor,
                        ),
                        text: "E-mail",
                        controller: signinController.emailController,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormFieldWidget(
                        icon: Icon(
                          Icons.lock,
                          color: AppColors.blackColor,
                        ),
                        text: "Password",
                        obsecure: true,
                        controller: signinController.passwordController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        trailing: TextButton(
                          onPressed: () {},
                          child: TextWidget(
                              text: "Forgot Password",
                              color: AppColors.whiteColor,
                              fontsize: 14,
                              fontweight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Obx(() {
                        return signinController.isLoading.value
                            ? Center(
                                child: IsLoading(),
                              )
                            : GestureDetector(
                                onTap: () {
                                  signinController.signin();
                                },
                                child: Alternativebutton(text: "sign in"),
                              );
                      }),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                              text: "Don't have an account?",
                              color: AppColors.whiteColor,
                              fontsize: 14,
                              fontweight: FontWeight.w500),
                          SizedBox(
                            width: 5,
                          ),
                          TextButton(
                            onPressed: () {
                              signinController.emailController.clear();
                              signinController.passwordController.clear();
                              Get.offNamed(AppRoutes.signupScreen, );
                            },
                            child: TextWidget(
                                text: "sign up",
                                color: AppColors.turquoiseColor,
                                fontsize: 14,
                                fontweight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            TextWidget(
                                text: "sign in with:",
                                color: AppColors.whiteColor,
                                fontsize: 14,
                                fontweight: FontWeight.w400),
                            SizedBox(width: 10),
                            Image.asset(AppAssets.googleButtonImage),
                            SizedBox(
                              width: 10,
                            ),
                            Image.asset(AppAssets.iphoneButtonImage),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
