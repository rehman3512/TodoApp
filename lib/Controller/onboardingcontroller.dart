import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;

  void nextPage() {
    if (currentIndex.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
