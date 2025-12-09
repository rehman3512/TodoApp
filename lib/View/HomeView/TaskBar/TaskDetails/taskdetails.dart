import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/homeController.dart';
import 'package:todoapp/Model/taskmodel.dart';
import 'package:todoapp/Widgets/SmallButton/smallbutton.dart';
import 'package:todoapp/constants/appColors/appColors.dart';
import 'package:todoapp/Widgets/gradiantcolor/gradiantcolor.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';
import 'package:todoapp/Widgets/IsLoading/isLoading.dart';
import 'package:todoapp/routes/approutes.dart';

class TaskDetailsView extends StatelessWidget {
  TaskDetailsView({super.key});

  final HomeController taskController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {

    final TaskModel? task =
    Get.arguments is TaskModel ? Get.arguments as TaskModel : null;

    if (task == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "No task data found!",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (taskController.titleController.text.isEmpty) {
        taskController.titleController.text = task.title;
        taskController.descriptionController.text = task.description;
        taskController.selectedDate.value = task.date;
        taskController.selectedTime.value = task.time;
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          GradiantColor(
            child: Obx(() {
              if (taskController.isLoading.value) {
                return Center(child: IsLoading());
              }

              final currentTask = taskController.taskList.firstWhere(
                    (t) => t.id == task.id,
                orElse: () => task, // fallback if not found
              );

              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(Icons.arrow_back_ios_new,
                                color: AppColors.turquoiseColor),
                          ),
                          SizedBox(width: 10),
                          TextWidget(
                            text: "Task Details",
                            color: AppColors.whiteColor,
                            fontsize: 18,
                            fontweight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: TextWidget(
                              text: currentTask.title,
                              color: AppColors.whiteColor,
                              fontsize: 20,
                              fontweight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit_note, color: AppColors.whiteColor),
                            onPressed: () {
                              Get.bottomSheet(
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.navyBlueColor,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        offset: Offset(0, -5),
                                      ),
                                    ],
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.65,
                                  child: SingleChildScrollView(
                                    child: Obx(() {
                                      if (taskController.isLoading.value) {
                                        return Center(child: IsLoading());
                                      }
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 50,
                                              height: 5,
                                              decoration: BoxDecoration(
                                                color: Colors.white54,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          TextWidget(
                                            text: "Edit Task",
                                            color: AppColors.whiteColor,
                                            fontsize: 20,
                                            fontweight: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 25),
                                          TextField(
                                            controller: taskController.titleController,
                                            style: TextStyle(color: AppColors.whiteColor),
                                            decoration: InputDecoration(
                                              labelText: "Title",
                                              labelStyle: TextStyle(color: Colors.white70),
                                              filled: true,
                                              fillColor: AppColors.blueGrayColor,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          TextField(
                                            controller: taskController.descriptionController,
                                            maxLines: 5,
                                            style: TextStyle(color: AppColors.whiteColor),
                                            decoration: InputDecoration(
                                              labelText: "Description",
                                              labelStyle: TextStyle(color: Colors.white70),
                                              filled: true,
                                              fillColor: AppColors.blueGrayColor,
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () => taskController.pickDate(context),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12, vertical: 14),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.blueGrayColor,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Obx(
                                                        () => Text(
                                                      taskController.selectedDate.value == null
                                                          ? "Select Date"
                                                          : "${taskController.selectedDate.value!.day}-${taskController.selectedDate.value!.month}-${taskController.selectedDate.value!.year}",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => taskController.pickTime(context),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12, vertical: 14),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.blueGrayColor,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Obx(
                                                        () => Text(
                                                      taskController.selectedTime.value == null
                                                          ? "Select Time"
                                                          : taskController.selectedTime.value!
                                                          .format(context),
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 25),
                                          GestureDetector(
                                            onTap: () async {
                                              await taskController.updateTask(currentTask);
                                              Get.back();
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.turquoiseColor,
                                                    AppColors.skyBlueColor
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextWidget(
                                                  text: "Update Task",
                                                  color: AppColors.whiteColor,
                                                  fontsize: 18,
                                                  fontweight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                                isScrollControlled: true,
                              );
                            },
                          )

                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.today,
                              size: 16, color: AppColors.whiteColor),
                          SizedBox(width: 4),
                          TextWidget(
                            text:
                            "${currentTask.date.day}-${currentTask.date.month}-${currentTask.date.year}",
                            color: AppColors.whiteColor,
                            fontsize: 16,
                            fontweight: FontWeight.w400,
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.watch_later_outlined,
                              size: 16, color: AppColors.whiteColor),
                          SizedBox(width: 4),
                          TextWidget(
                            text: currentTask.time.format(context),
                            color: AppColors.whiteColor,
                            fontsize: 16,
                            fontweight: FontWeight.w400,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(color: AppColors.whiteColor),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: "Status",
                            color: AppColors.whiteColor,
                            fontsize: 16,
                            fontweight: FontWeight.w400,
                          ),
                          Switch(
                            value: currentTask.status == "Complete",
                            onChanged: (value) async {
                              taskController.isLoading.value = true;
                              await taskController.changeStatus(
                                currentTask,
                                value ? "Complete" : "Pending",
                              );
                              taskController.isLoading.value = false;
                              Get.back();
                            },
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(color: AppColors.whiteColor),
                      SizedBox(height: 20),
                      TextWidget(
                        text: currentTask.description,
                        color: AppColors.whiteColor,
                        fontsize: 16,
                        fontweight: FontWeight.w400,
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: SmallButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              text: "Done",
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              taskController.isLoading.value = true;
                              await taskController.deleteTask(currentTask.id);
                              taskController.isLoading.value = false;
                              Get.toNamed(AppRoutes.taskBar);
                            },
                            child: SmallButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              text: "Delete",
                            ),
                          ),
                          SmallButton(
                            icon: Icon(Icons.push_pin, color: Colors.yellow),
                            text: "Pin",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
