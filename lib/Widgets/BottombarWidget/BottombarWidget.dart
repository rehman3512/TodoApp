import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';

class BottombarWidget extends StatelessWidget {
  final RxInt selectedIndex;
  final List<BottombarItem> items;
  final Function(int) onTap;
  const BottombarWidget(
      {super.key,
      required this.selectedIndex,
      required this.items,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, -2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length,(index){
              final item = items[index];
              final isSelected = selectedIndex.value == index;
              return GestureDetector(onTap: ()=> onTap(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon,
                  color: isSelected ? AppColors.blueColor : AppColors.greyColor,
                  size: isSelected ? 28 : 24,),
                  SizedBox(height: 4,),
                  TextWidget(text: item.label,
                      color: isSelected ? AppColors.blueColor : AppColors.greyColor,
                      fontsize: 12,
                      fontweight: isSelected ? FontWeight.bold : FontWeight.normal),
                ],
              ),
              );
            })
          ),
        ));
  }
}



class BottombarItem {
  final IconData icon;
  final String label;

  BottombarItem({required this.icon,required this.label});
}