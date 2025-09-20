// import 'package:flutter/material.dart';
// import 'package:todoapp/Widgets/appAssets/appAssets.dart';
// import 'package:todoapp/Widgets/gradiantcolor/gradiantcolor.dart';
// import 'package:todoapp/View/StartView/onboardingView/nextView/nextView.dart';
// import 'package:todoapp/View/StartView/onboardingView/testView/testView.dart';
//
// class OnboardingView extends StatelessWidget {
//   const OnboardingView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: [
//         GradiantColor(child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: PageView(children: [
//                 TestView(img: AppAssets.clipBoardImage, text: "Plan your tasks to do, that \n"
//                     " way you’ll stay organized \n and you won’t skip any",),
//                 TestView(img: AppAssets.calenderImage, text: "Make a full schedule for \n "
//                     "the whole week and stay \n organized and productive \n all days",),
//                 TestView(img: AppAssets.settingImage, text: "create a team task, invite \n "
//                     "people and manage your \n work together",),
//                 NextView(img: AppAssets.shieldImage, text: "You informations are \n secure with us",),
//               ],),
//             )
//           ],
//         ))
//       ],),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/onboardingcontroller.dart';
import 'package:todoapp/constants/appAssets/appAssets.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';
import 'package:todoapp/routes/approutes.dart';


class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                if (controller.currentIndex.value == 3) {

                  Get.offAllNamed(AppRoutes.signupScreen);
                } else {
                  controller.nextPage();
                }
              },
              icon: Icon(
                controller.currentIndex.value == 3
                    ? Icons.check
                    : Icons.arrow_forward,
                size: 28,
                color: AppColors.navyBlueColor,
              ),
            ),
          ),
        );
      }),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.blueColor, AppColors.navyBlueColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  buildPage(
                    image: AppAssets.clipBoardImage,
                    textLines: [
                      "Plan your tasks to do, that",
                      "way you will stay organized",
                      "and you will not skip any",
                    ],
                  ),
                  buildPage(
                    image: AppAssets.calenderImage,
                    textLines: [
                      "Make a full schedule for",
                      "the whole week and stay",
                      "organized and productive",
                      "for all day",
                    ],
                  ),
                  buildPage(
                    image: AppAssets.settingImage,
                    textLines: [
                      "Create a team task, invite",
                      "people and manage your",
                      "work together",
                    ],
                  ),
                  buildPage(
                    image: AppAssets.shieldImage,
                    textLines: [
                      "Your information are",
                      "secure with us",
                    ],
                  ),
                ],
              ),

              /// ✅ Dots Indicator
              Positioned(
                bottom: 60,
                left: 0,
                right: 0,
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        height: 6,
                        width: controller.currentIndex.value == index ? 25 : 10,
                        decoration: BoxDecoration(
                          color: controller.currentIndex.value == index
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage({required String image, required List<String> textLines}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 200),
        const SizedBox(height: 30),
        ...textLines
            .map((line) => TextWidget(
          text: line,
          fontsize: 20,
          color: AppColors.whiteColor,
          fontweight: FontWeight.w400,
        ))
            .toList(),
      ],
    );
  }
}
