import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/constants/appAssets/appAssets.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';
import 'package:todoapp/Widgets/gradiantcolor/gradiantcolor.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';
import 'package:todoapp/View/HomeView/homeView.dart';
import 'package:todoapp/View/StartView/onboardingView/onboardingView.dart';
import 'package:todoapp/routes/approutes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 15),(){
    islogin();
    //   isChecked();
      Get.offAndToNamed(AppRoutes.onboardingScreen);
    });
  }

  islogin() async{
    User? user=await FirebaseAuth.instance.currentUser;
    if(user==null)
      {
        Get.off(()=>OnboardingView());
      }
    else
      {
        Get.off(()=>HomeView());
      }
  }
  // isChecked()
  // {
  //   if(FirebaseAuth.instance.currentUser!=null){
  //     Get.to(()=>HomeView());
  //   }
  //   else
  //   {
  //     Get.to(()=>SignUpView());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GradiantColor(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 120,),
            Image.asset(AppAssets.whiteCheckMarkImage),
            SizedBox(height: 30,),
            Text("DO IT",style: GoogleFonts.darumadropOne(
              fontSize: 36,fontWeight: FontWeight.w400,
              color: AppColors.whiteColor
            ),),
            Spacer(),
            TextWidget(text: "v 1.0.0", color: AppColors.whiteColor, fontsize: 20,
                fontweight: FontWeight.w500),
            SizedBox(height: 100,),
        ],))
      ],)
    );
  }
}
