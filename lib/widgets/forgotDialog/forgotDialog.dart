import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/authController.dart';
import 'package:todoapp/constants/appColors/appColors.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';

class ForgotPasswordDialog extends StatelessWidget {
  ForgotPasswordDialog({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.navyBlueColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: TextWidget(
        text: "Check Your Email",
        color: AppColors.whiteColor,
        fontsize: 18,
        fontweight: FontWeight.bold,
      ),
      content: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextWidget(
            text: "A password reset link has been sent to your email address.",
            color: AppColors.whiteColor.withOpacity(0.8),
            fontsize: 14,
            fontweight: FontWeight.w400,
          ),
          SizedBox(height: 20),
          authController.canResendEmail.value
              ? GestureDetector(
            onTap: () {
              authController.resendForgotPassword();
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.blueColor,
                    AppColors.navyBlueColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: TextWidget(
                  text: "Resend Email",
                  color: AppColors.whiteColor,
                  fontsize: 14,
                  fontweight: FontWeight.w500,
                ),
              ),
            ),
          )
              : TextWidget(
            text: "You can resend in ${authController.timerCount.value}s",
            color: Colors.grey,
            fontsize: 14,
            fontweight: FontWeight.w400,
          ),
        ],
      )),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: TextWidget(
            text: "Close",
            color: AppColors.whiteColor,
            fontsize: 14,
            fontweight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}