import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/homeController.dart';
import 'package:todoapp/Widgets/BottomSheetWidget/bottomsheetwidget.dart';
import 'package:todoapp/Widgets/gradiantcolor/gradiantcolor.dart';
import 'package:todoapp/Widgets/containerWidget/containerWidget.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';

class TaskBar extends StatelessWidget {
  TaskBar({super.key});

  final HomeController controller = Get.put(HomeController());

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      isScrollControlled: true,
      builder: (context) => BottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(context),
        backgroundColor: AppColors.turquoiseColor,
        child: Icon(Icons.add, color: AppColors.whiteColor),
      ),
      body: GradiantColor(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 🔍 Search + Sort Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    /// Search
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.navyBlueColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          style: TextStyle(
                              color: AppColors.whiteColor, fontSize: 14),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search by task title",
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                          onChanged: (value) {
                            controller.searchQuery.value = value;
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Sort Dropdown
                    Expanded(
                      flex: 2,
                      child: Obx(
                            () => Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppColors.navyBlueColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: controller.selectedSort.value,
                              dropdownColor: AppColors.navyBlueColor,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey),
                              style: TextStyle(
                                  color: AppColors.whiteColor, fontSize: 14),
                              onChanged: (value) {
                                if (value != null) controller.changeSort(value);
                              },
                              items: const [
                                DropdownMenuItem(
                                    value: "All", child: Text("All")),
                                DropdownMenuItem(
                                    value: "Complete", child: Text("Complete")),
                                DropdownMenuItem(
                                    value: "Incomplete",
                                    child: Text("Incomplete")),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 📝 Tasks List
              Expanded(
                child: Obx(() {
                  final tasks = controller.filteredTasks;
                  if (tasks.isEmpty) {
                    return Center(
                      child: TextWidget(
                        text: "No Tasks Found",
                        color: AppColors.whiteColor,
                        fontsize: 14,
                        fontweight: FontWeight.w400,
                      ),
                    );
                  }
                  return ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ContainerWidget(index: index),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
