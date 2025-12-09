import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/profilecontroller.dart';
import 'package:todoapp/Controller/authController.dart';
import 'package:todoapp/Widgets/ListWidget/listwidget.dart';
import 'package:todoapp/constants/appColors/appColors.dart';
import 'package:todoapp/Widgets/gradiantcolor/gradiantcolor.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';
import 'package:todoapp/routes/approutes.dart';


class SettingBar extends StatelessWidget {
  const SettingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GradiantColor(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SafeArea( 
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            GestureDetector( onTap: (){
                              Get.back();
                            },
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: AppColors.turquoiseColor,
                                ),
                              ),
                            ), SizedBox(width: 80,),
                            TextWidget(text: "Setting", color: AppColors.whiteColor, fontsize: 28, fontweight: FontWeight.w400)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 75,
                      ),
                      GestureDetector(onTap: (){
                        if (!Get.isRegistered<ProfileController>()) {
                          Get.put(ProfileController());
                        }
                        Get.toNamed(AppRoutes.profileBar);
                      },child: ListWidget(icon: Icons.person, text: "Profile")),
                      Divider(),
                      ListWidget(icon: Icons.message, text: "Conversation"),
                      Divider(),
                      ListWidget(icon: Icons.lightbulb_outline, text: "Projects"),
                      Divider(),
                      ListWidget(
                          icon: Icons.document_scanner, text: "Terms & Policies"),
                      Divider(),
                      SizedBox(
                        height: 140,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector( onTap: (){
                          Get.find<AuthController>().signout();
                        },
                          child: Container(
                            height: 60,
                            width: 280,
                            decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.login_outlined,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                    text: "Logout",
                                    color: Colors.red,
                                    fontsize: 16,
                                    fontweight: FontWeight.w400)
                              ],
                            ),
                          ),
                        ),
                      ),
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