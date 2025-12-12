import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/constants/appAssets/appAssets.dart';
import 'package:todoapp/constants/appColors/appColors.dart';
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
    Future.delayed(Duration(seconds: 2),(){
    islogin();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GradiantColor(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70,),
              Image.asset(AppAssets.whiteCheckMarkImage),
              SizedBox(height: 30,),
              Text("DO IT",style: GoogleFonts.darumadropOne(
                fontSize: 36,fontWeight: FontWeight.w400,
                color: AppColors.whiteColor
              ),),
              Spacer(),
              TextWidget(text: "v 1.0.0", color: AppColors.whiteColor, fontsize: 20,
                  fontweight: FontWeight.w500),
          ],),
        ))
      ],)
    );
  }
}
