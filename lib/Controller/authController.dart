import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/homeController.dart';
import 'package:todoapp/Widgets/showMessage/showMessage.dart';
import 'package:todoapp/routes/approutes.dart';

class AuthController extends GetxController{
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var isLoading=false.obs;

  signup()async{
    try{
      isLoading.value=true;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);
      emailController.clear();
      passwordController.clear();
      ShowMessage.successMessage("Congratulations", "Your account has been created");
      Get.offAndToNamed(AppRoutes.signinScreen);
    }catch(error){
      ShowMessage.errorMessage("Error", "Error:${error.toString()}");
    }finally{
      isLoading.value=false;
    }
  }


  signin()async{
    try{
      isLoading.value=true;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text);
      Get.find<HomeController>().fetchTasks();
      Get.offAndToNamed(AppRoutes.homeScreen);
      ShowMessage.successMessage("Welcome", "Login Successful");
    }catch(error){
      ShowMessage.errorMessage("Error", "Error:${error.toString()}");
    }finally{
      isLoading.value=false;
    }
  }


  signout()async{
    await FirebaseAuth.instance.signOut();
    Get.toNamed(AppRoutes.signinScreen);
  }


}