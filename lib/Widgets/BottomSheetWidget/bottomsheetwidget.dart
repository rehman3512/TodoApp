import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/Controller/homeController.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';
import 'package:todoapp/Widgets/showMessage/showMessage.dart';

class BottomSheetWidget extends StatelessWidget {
  BottomSheetWidget({super.key});

  final HomeController taskController = Get.put(HomeController());


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.9,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),

              // ✅ TITLE FIELD
              Container(
                height: 45,
                width: 360,
                decoration: BoxDecoration(
                  color: AppColors.navyBlueColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: taskController.titleController,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.title, color: AppColors.whiteColor),
                    hintText: "Enter Title",
                    hintStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ DESCRIPTION FIELD
              Container(
                height: 160,
                width: 360,
                decoration: BoxDecoration(
                  color: AppColors.navyBlueColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: taskController.descriptionController,
                  maxLines: null,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.sort, color: AppColors.whiteColor),
                    hintText: "Description",
                    hintStyle: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ DATE & TIME
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => taskController.pickDate(context),
                    child: Container(
                      height: 45,
                      width: 155,
                      decoration: BoxDecoration(
                        color: AppColors.navyBlueColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month, color: AppColors.whiteColor),
                            const SizedBox(width: 10),
                            Obx(() => TextWidget(
                              text: taskController.selectedDate.value == null
                                  ? "Date"
                                  : "${taskController.selectedDate.value!.day}-${taskController.selectedDate.value!.month}-${taskController.selectedDate.value!.year}",
                              color: AppColors.whiteColor,
                              fontsize: 16,
                              fontweight: FontWeight.w400,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => taskController.pickTime(context),
                    child: Container(
                      height: 45,
                      width: 155,
                      decoration: BoxDecoration(
                        color: AppColors.navyBlueColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.watch_later_outlined, color: AppColors.whiteColor),
                            const SizedBox(width: 10),
                            Obx(() => TextWidget(
                              text: taskController.selectedTime.value == null
                                  ? "Time"
                                  : taskController.selectedTime.value!.format(context),
                              color: AppColors.whiteColor,
                              fontsize: 16,
                              fontweight: FontWeight.w400,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ BUTTONS WITH LOADING
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CANCEL BUTTON
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.skyBlueColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: "Cancel",
                          color: AppColors.blackColor,
                          fontsize: 16,
                          fontweight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  // CREATE BUTTON OR LOADING
                  taskController.isLoading.value
                      ? Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: AppColors.skyBlueColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.skyBlueColor),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  )
                      : InkWell(
                    onTap: () async {
                      // ✅ Validation
                      if (taskController.titleController.text.isEmpty) {
                        ShowMessage.errorMessage("Error", "Please enter a title");
                        return;
                      }
                      if (taskController.descriptionController.text.isEmpty) {
                        ShowMessage.errorMessage("Error", "Please enter a description");
                        return;
                      }
                      if (taskController.selectedDate.value == null) {
                        ShowMessage.errorMessage("Error", "Please select a date");
                        return;
                      }
                      if (taskController.selectedTime.value == null) {
                        ShowMessage.errorMessage("Error", "Please select a time");
                        return;
                      }

                      // ✅ All fields filled
                      await taskController.insertTask();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: AppColors.skyBlueColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.skyBlueColor),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: "Create",
                          color: AppColors.whiteColor,
                          fontsize: 16,
                          fontweight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
