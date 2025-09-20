import 'package:flutter/material.dart';

class TaskModel {
  String id;
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  String status; // "Pending" or "Complete"

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.status = "Pending",
  });
}
