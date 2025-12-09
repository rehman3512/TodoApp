import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/Model/taskmodel.dart';
import 'package:todoapp/Widgets/showMessage/showMessage.dart';

class HomeController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var userId = "".obs;
  var userEmail = "".obs;

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);

  RxList<TaskModel> taskList = <TaskModel>[].obs;
  RxString searchQuery = "".obs;
  RxString selectedSort = "All".obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId.value = user.uid;
      userEmail.value = user.email ?? "";
      fetchTasks();
    }
  }

  pickDate(BuildContext context) async {
    selectedDate.value = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  pickTime(BuildContext context) async {
    selectedTime.value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  // insertTask() async {
  //   if (titleController.text.isEmpty ||
  //       descriptionController.text.isEmpty ||
  //       selectedDate.value == null ||
  //       selectedTime.value == null) {
  //     ShowMessage.errorMessage("Error", "All fields are required!");
  //     return;
  //   }
  //
  //   isLoading.value = true;
  //   try {
  //     final docRef = await FirebaseFirestore.instance.collection("UserData").add({
  //       "title": titleController.text,
  //       "description": descriptionController.text,
  //       "date": selectedDate.value!.toIso8601String(),
  //       "time": "${selectedTime.value!.hour}:${selectedTime.value!.minute}",
  //       "userId": userId.value,
  //       "status": "Pending",
  //     });
  //
  //     taskList.add(TaskModel(
  //       id: docRef.id,
  //       title: titleController.text,
  //       description: descriptionController.text,
  //       date: selectedDate.value!,
  //       time: selectedTime.value!,
  //       status: "Pending",
  //     ));
  //
  //     clearFields();
  //     ShowMessage.successMessage("Success", "Task added successfully");
  //     Get.back();
  //   } catch (e) {
  //     ShowMessage.errorMessage("Error", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  insertTask() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedDate.value == null ||
        selectedTime.value == null) {
      ShowMessage.errorMessage("Error", "All fields are required!");
      return;
    }

    // ✅ Duplicate title check
    bool isDuplicate = taskList.any(
            (task) => task.title.trim().toLowerCase() == titleController.text.trim().toLowerCase()
    );

    if (isDuplicate) {
      ShowMessage.errorMessage("Error", "A task with this title already exists!");
      return;
    }

    isLoading.value = true;
    try {
      final docRef = await FirebaseFirestore.instance.collection("UserData").add({
        "title": titleController.text,
        "description": descriptionController.text,
        "date": selectedDate.value!.toIso8601String(),
        "time": "${selectedTime.value!.hour}:${selectedTime.value!.minute}",
        "userId": userId.value,
        "status": "Pending",
      });

      taskList.add(TaskModel(
        id: docRef.id,
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate.value!,
        time: selectedTime.value!,
        status: "Pending",
      ));

      clearFields();
      ShowMessage.successMessage("Success", "Task added successfully");
      Get.back();
    } catch (e) {
      ShowMessage.errorMessage("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  fetchTasks() async {
    if (userId.value.isEmpty) return;

    taskList.clear();
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("UserData")
          .where("userId", isEqualTo: userId.value)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final timeParts = (data["time"] as String).split(":");
        taskList.add(TaskModel(
          id: doc.id,
          title: data["title"] ?? "",
          description: data["description"] ?? "",
          date: DateTime.parse(data["date"]),
          time: TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          ),
          status: data["status"] ?? "Pending",
        ));
      }
    } catch (e) {
      ShowMessage.errorMessage("Error", e.toString());
    }
  }

  deleteTask(String id) async {
    try {
      await FirebaseFirestore.instance.collection("UserData").doc(id).delete();
      taskList.removeWhere((task) => task.id == id);
      ShowMessage.successMessage("Deleted", "Task deleted successfully");
    } catch (e) {
      ShowMessage.errorMessage("Error", e.toString());
    }
  }

  updateTask(TaskModel task) async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedDate.value == null ||
        selectedTime.value == null) {
      ShowMessage.errorMessage("Error", "All fields are required!");
      return;
    }

    isLoading.value = true;
    try {
      await FirebaseFirestore.instance.collection("UserData").doc(task.id).update({
        "title": titleController.text,
        "description": descriptionController.text,
        "date": selectedDate.value!.toIso8601String(),
        "time": "${selectedTime.value!.hour}:${selectedTime.value!.minute}",
      });

      int index = taskList.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        taskList[index] = TaskModel(
          id: task.id,
          title: titleController.text,
          description: descriptionController.text,
          date: selectedDate.value!,
          time: selectedTime.value!,
          status: task.status,
        );
      }
      ShowMessage.successMessage("Updated", "Task updated successfully");
    } catch (e) {
      ShowMessage.errorMessage("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  changeStatus(TaskModel task, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection("UserData").doc(task.id).update({
        "status": newStatus,
      });

      int index = taskList.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        taskList[index].status = newStatus;
        taskList.refresh();
      }
    } catch (e) {
      ShowMessage.errorMessage("Error", e.toString());
    }
  }

  changeSort(String value) {
    selectedSort.value = value;
  }

  List<TaskModel> get filteredTasks {
    var tasks = taskList.toList();

    if (searchQuery.value.isNotEmpty) {
      tasks = tasks.where((t) => t.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }

    if (selectedSort.value == "Complete") {
      tasks = tasks.where((t) => t.status == "Complete").toList();
    } else if (selectedSort.value == "Incomplete") {
      tasks = tasks.where((t) => t.status == "Pending").toList();
    }

    return tasks;
  }

  void clearFields() {
    titleController.clear();
    descriptionController.clear();
    selectedDate.value = null;
    selectedTime.value = null;
  }


}