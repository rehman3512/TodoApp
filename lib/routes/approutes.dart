import 'package:get/get.dart';
import 'package:todoapp/View/AuthView/signInView/signInView.dart';
import 'package:todoapp/View/AuthView/signUpView/signUpView.dart';
import 'package:todoapp/View/HomeView/HomeBar/homebar.dart';
import 'package:todoapp/View/HomeView/ProfileBar/profileBar.dart';
import 'package:todoapp/View/HomeView/SettingBar/settingbar.dart';
import 'package:todoapp/View/HomeView/TaskBar/TaskDetails/taskdetails.dart';
import 'package:todoapp/View/HomeView/TaskBar/taskbar.dart';
import 'package:todoapp/View/HomeView/homeView.dart';
import 'package:todoapp/View/StartView/onboardingView/onboardingView.dart';
import 'package:todoapp/View/StartView/splashView/splashView.dart';

class AppRoutes{
  static String splashScreen = "/";
  static String onboardingScreen = "/OnboardingView";
  static String signupScreen = "/SignupView";
  static String signinScreen = "/SigninView";
  static String homeScreen = "/HomeView";
  static String homeBar = "/HomeBar";
  static String taskBar = "/TaskBar";
  static String settingBar  = "/SettingBar";
  static String taskDetailsScreen  = "/TaskDetailsView";
  static String profileBar  = "/ProfileBar";

  static final routes = [
    GetPage(name: splashScreen, page: ()=> SplashView()),
    GetPage(name: onboardingScreen, page: ()=> OnboardingView()),
    GetPage(name: signupScreen, page: ()=> SignUpView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),),
    GetPage(name: signinScreen, page: ()=> SignInView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 150),),
    GetPage(name: homeScreen, page: ()=> HomeView()),
    GetPage(name: homeBar, page: ()=> HomeBar()),
    GetPage(name: taskBar, page: ()=> TaskBar()),
    GetPage(name: profileBar, page: ()=> ProfileBar()),
    GetPage(name: settingBar, page: ()=> SettingBar()),
    GetPage(name: taskDetailsScreen, page: ()=> TaskDetailsView(),),
  ];

}