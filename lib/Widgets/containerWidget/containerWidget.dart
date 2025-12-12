import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/homeController.dart';
import 'package:todoapp/constants/appColors/appColors.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';
import 'package:todoapp/routes/approutes.dart';

class ContainerWidget extends StatelessWidget {
  final int index;
  ContainerWidget({super.key, required this.index});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final task = controller.filteredTasks[index];

    return InkWell(
      onTap: () {
        controller.titleController.text = task.title;
        controller.descriptionController.text = task.description;
        controller.selectedDate.value = task.date;
        controller.selectedTime.value = task.time;

        Get.toNamed(AppRoutes.taskDetailsScreen, arguments: task);
      },
      child: Container(
        height: 70,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: task.status == "Complete" ? Colors.green : Colors.orange,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: task.title,
                    color: AppColors.blackColor,
                    fontsize: 14,
                    fontweight: FontWeight.w500,
                  ),
                  SizedBox(height: 4),
                  TextWidget(
                    text:
                    "${task.date.day}-${task.date.month}-${task.date.year} | ${task.time.format(context)}",
                    color: Colors.grey,
                    fontsize: 10,
                    fontweight: FontWeight.w400,
                  ),
                  SizedBox(height: 4),
                  TextWidget(
                    text: task.status,
                    color: task.status == "Complete" ? Colors.green : Colors.orange,
                    fontsize: 10,
                    fontweight: FontWeight.w500,
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.turquoiseColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
