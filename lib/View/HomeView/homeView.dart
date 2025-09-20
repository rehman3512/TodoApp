import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/View/HomeView/HomeBar/homebar.dart';
import 'package:todoapp/View/HomeView/ProfileBar/profileBar.dart';
import 'package:todoapp/View/HomeView/SettingBar/settingbar.dart';
import 'package:todoapp/View/HomeView/TaskBar/taskbar.dart';
import 'package:todoapp/Widgets/BottombarWidget/BottombarWidget.dart';


class HomeView extends StatelessWidget {
  HomeView({super.key});

  final RxInt selectedIndex = 0.obs;
  final List<Widget> pages = [
    HomeBar(),
    TaskBar(),
    ProfileBar(),
    SettingBar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=> pages[selectedIndex.value]),
      bottomNavigationBar: BottombarWidget(
          selectedIndex: selectedIndex,
          items: [
            BottombarItem(icon: Icons.home, label: "Home"),
            BottombarItem(icon: Icons.list, label: "Task"),
            BottombarItem(icon: Icons.calendar_month, label: "Manage"),
            BottombarItem(icon: Icons.settings, label: "Setting"),
          ], onTap: (index){
            selectedIndex.value = index;
      }),
    );
  }
}
