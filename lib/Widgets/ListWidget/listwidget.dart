import 'package:flutter/material.dart';
import 'package:todoapp/constants/appColors/appColors.dart';
import 'package:todoapp/Widgets/textWidget/textWidget.dart';

class ListWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const ListWidget({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon,color: AppColors.whiteColor,),
          SizedBox(
            width: 10,
          ),
          TextWidget(
              text: text,
              color: AppColors.whiteColor,
              fontsize: 16,
              fontweight: FontWeight.w400),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: AppColors.turquoiseColor,
      ),
    );
  }
}
