import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/homeController.dart';
import 'package:todoapp/Widgets/forgotDialog/forgotDialog.dart';
import 'package:todoapp/Widgets/showMessage/showMessage.dart';
import 'package:todoapp/routes/approutes.dart';

class AuthController extends GetxController {
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  var isForgot = false.obs;

  // Timer for resend email
  var canResendEmail = false.obs;
  var timerCount = 60.obs;
  Timer? resendTimer;

  @override
  void onInit() {
    super.onInit();
    // Timer dispose ke liye
    ever(canResendEmail, (_) {
      if (!canResendEmail.value && resendTimer != null) {
        resendTimer?.cancel();
        resendTimer = null;
      }
    });
  }

  @override
  void onClose() {
    userController.dispose();
    emailController.dispose();
    passwordController.dispose();
    resendTimer?.cancel();
    super.onClose();
  }

  // Timer start karna
  void startResendTimer() {
    canResendEmail.value = false;
    timerCount.value = 60;

    resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerCount.value > 0) {
        timerCount.value--;
      } else {
        canResendEmail.value = true;
        timer.cancel();
      }
    });
  }

  ForgotPassword() async {
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      ShowMessage.errorMessage("Error", "Please enter a valid email");
      return;
    }

    try {
      isForgot.value = true;

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      startResendTimer(); // Start timer when email is sent

      Get.dialog(
        ForgotPasswordDialog(),
        barrierDismissible: false,
      );
    } catch (e) {
      ShowMessage.errorMessage("Error", "Error: ${e.toString()}");
    } finally {
      isForgot.value = false;
    }
  }

  resendForgotPassword() async {
    if (!canResendEmail.value) return;

    try {
      isForgot.value = true;

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      startResendTimer(); // Restart timer

      ShowMessage.successMessage(
          "Email Resent",
          "Password reset email sent again"
      );
    } catch (e) {
      ShowMessage.errorMessage("Error", "Error: ${e.toString()}");
    } finally {
      isForgot.value = false;
    }
  }

  // ✅ Signup function (with validation)
  // signup() async {
  //   try {
  //     isLoading.value = true;
  //
  //     // ✅ Validation (same as your example)
  //     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
  //       ShowMessage.errorMessage("Error", "All fields are required");
  //     } else if (!GetUtils.isEmail(emailController.text)) {
  //       ShowMessage.errorMessage("Error", "Enter a valid email address");
  //     } else if (passwordController.text.length < 6) {
  //       ShowMessage.errorMessage(
  //           "Error",
  //           "Password must be at least 6 characters"
  //       );
  //     } else {
  //       final UserCredential userCredential =
  //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailController.text.trim(),
  //         password: passwordController.text,
  //       );
  //
  //       await userCredential.user!.sendEmailVerification();
  //
  //       emailController.clear();
  //       passwordController.clear();
  //       userController.clear();
  //
  //       ShowMessage.successMessage(
  //           "Account Created",
  //           "Verification email sent. Please verify your email."
  //       );
  //
  //       Get.offAndToNamed(AppRoutes.signinScreen);
  //     }
  //   } catch (error) {
  //     ShowMessage.errorMessage("Error", "Error: ${error.toString()}");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // ✅ Signin function (with validation)
  signup() async {
    try {
      isLoading.value = true;

      // ✅ Validation
      if (userController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
        ShowMessage.errorMessage("Error", "All fields are required");
        return;
      } else if (!GetUtils.isEmail(emailController.text)) {
        ShowMessage.errorMessage("Error", "Enter a valid email address");
        return;
      } else if (passwordController.text.length < 6) {
        ShowMessage.errorMessage("Error", "Password must be at least 6 characters");
        return;
      }

      // ✅ Create user with Firebase Auth
      final UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // ✅ Save user info in Firestore
      await FirebaseFirestore.instance
          .collection('Users') // collection name same jaisa profile me hai
          .doc(userCredential.user!.uid)
          .set({
        'name': userController.text.trim(),
        'email': emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ✅ Send email verification
      await userCredential.user!.sendEmailVerification();

      // ✅ Clear fields
      userController.clear();
      emailController.clear();
      passwordController.clear();

      // ✅ Show success message
      ShowMessage.successMessage(
          "Account Created",
          "Verification email sent. Please verify your email."
      );

      // ✅ Navigate to signin screen
      Get.offAndToNamed(AppRoutes.signinScreen);

    } catch (error) {
      ShowMessage.errorMessage("Error", "Error: ${error.toString()}");
    } finally {
      isLoading.value = false;
    }
  }



  signin() async {
    try {
      isLoading.value = true;

      // ✅ Validation (same as your example)
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ShowMessage.errorMessage("Error", "All fields are required");
      } else if (!GetUtils.isEmail(emailController.text)) {
        ShowMessage.errorMessage("Error", "Enter a valid email address");
      } else if (passwordController.text.length < 6) {
        ShowMessage.errorMessage(
            "Error",
            "Password must be at least 6 characters"
        );
      } else {
        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        final User? user = userCredential.user;

        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();

          ShowMessage.successMessage(
              "Email Verification",
              "Verification email sent. Please check your email"
          );

          await FirebaseAuth.instance.signOut();
        } else {
          Get.find<HomeController>().fetchTasks();
          Get.offAndToNamed(AppRoutes.homeScreen);
          ShowMessage.successMessage("Welcome", "Login Successful");
        }
      }
    } catch (error) {
      ShowMessage.errorMessage("Error", "Error: ${error.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Clear fields function
  void clearFields() {
    emailController.clear();
    passwordController.clear();
    userController.clear();
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(AppRoutes.signinScreen);
  }
}