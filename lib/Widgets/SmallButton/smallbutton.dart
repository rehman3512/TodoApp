import 'package:flutter/material.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';

class SmallButton extends StatelessWidget {
  final Widget icon;
  final String text;
  const SmallButton(
      {super.key, required this.icon, required this.text,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 85,
      decoration: BoxDecoration(
          color: AppColors.navyBlueColor,
          border: Border.all(color: AppColors.navyBlueColor),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            Spacer(),
            TextWidget(text: text,
                color: AppColors.whiteColor,
                fontsize: 12, fontweight: FontWeight.w400),
          ],
        ),
      ),
    );
  }
}
