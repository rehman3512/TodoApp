import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/homeController.dart';
import 'package:todoapp/constants/appAssets/appAssets.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';
import 'package:todoapp/routes/approutes.dart';
import 'package:todoapp/Widgets/gradiantcolor/gradiantcolor.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';

class HomeBar extends StatelessWidget {
  HomeBar({super.key});
  final HomeController controller = Get.find<HomeController>();

  void navigateToDetails(task) {
    controller.titleController.text = task.title;
    controller.descriptionController.text = task.description;
    controller.selectedDate.value = task.date;
    controller.selectedTime.value = task.time;

    Get.toNamed(AppRoutes.taskDetailsScreen, arguments: task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GradiantColor(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // 🔝 Top Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(AppAssets.mainLogoImage),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: "REHMAN kHAN",
                                color: AppColors.whiteColor,
                                fontsize: 18,
                                fontweight: FontWeight.w600,
                              ),
                              TextWidget(
                                text: "rehman113@gmial.com",
                                color: Colors.grey,
                                fontsize: 14,
                                fontweight: FontWeight.w500,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(Icons.notifications,
                              color: AppColors.whiteColor, size: 30),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🧑‍🤝‍🧑 Group Tasks
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextWidget(
                        text: "Group task",
                        color: AppColors.whiteColor,
                        fontsize: 16,
                        fontweight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildGroupCard("Design Meeting", "Tomorrow | 10:30pm"),
                          _buildGroupCard("Project Meeting", "Thursday | 10:30pm"),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔴 Incomplete Tasks
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextWidget(
                        text: "Incomplete Tasks",
                        color: AppColors.whiteColor,
                        fontsize: 14,
                        fontweight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Obx(() {
                      final incompleteTasks =
                      controller.taskList.where((t) => t.status != "Complete").toList();
                      return Column(
                        children: incompleteTasks.map((task) {
                          return GestureDetector(
                            onTap: () => navigateToDetails(task), // 👈 Navigate on tap
                            child: _buildTaskContainer(
                              title: task.title,
                              subtitle:
                              "${task.date.day}-${task.date.month} | ${task.time.format(context)}",
                              showCheck: false,
                            ),
                          );
                        }).toList(),
                      );
                    }),

                    const SizedBox(height: 20),

                    // ✅ Complete Tasks
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextWidget(
                        text: "Complete Tasks",
                        color: AppColors.whiteColor,
                        fontsize: 14,
                        fontweight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Obx(() {
                      final completeTasks =
                      controller.taskList.where((t) => t.status == "Complete").toList();
                      return Column(
                        children: completeTasks.map((task) {
                          return GestureDetector(
                            onTap: () => navigateToDetails(task), // 👈 Navigate on tap
                            child: _buildTaskContainer(
                              title: task.title,
                              subtitle:
                              "${task.date.day}-${task.date.month} | ${task.time.format(context)}",
                              showCheck: true,
                            ),
                          );
                        }).toList(),
                      );
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔧 Helper widget for group task card
  Widget _buildGroupCard(String title, String subtitle) {
    return Container(
      height: 110,
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: title,
              color: AppColors.blackColor,
              fontsize: 14,
              fontweight: FontWeight.w500,
            ),
            TextWidget(
              text: subtitle,
              color: Colors.grey,
              fontsize: 10,
              fontweight: FontWeight.w400,
            ),
            const Spacer(),
            Image.asset(AppAssets.groupCircleImage),
          ],
        ),
      ),
    );
  }

  /// 🔧 Helper widget for task container
  Widget _buildTaskContainer({
    required String title,
    required String subtitle,
    required bool showCheck,
  }) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            if (showCheck) ...[
              Image.asset(AppAssets.iconCheckMarkImage),
              const SizedBox(width: 10),
            ],
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: title,
                  color: AppColors.blackColor,
                  fontsize: 14,
                  fontweight: FontWeight.w500,
                ),
                TextWidget(
                  text: subtitle,
                  color: Colors.grey,
                  fontsize: 10,
                  fontweight: FontWeight.w400,
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: AppColors.turquoiseColor),
          ],
        ),
      ),
    );
  }
}
