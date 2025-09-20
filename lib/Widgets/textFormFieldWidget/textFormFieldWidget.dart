import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/constants/appColors/AppColors.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final Widget icon;
  final bool obsecure;
  const TextFormFieldWidget({super.key,required this.icon,
  required this.text,required this.controller,this.obsecure=false});

  @override
  Widget build(BuildContext context) {
    return Container(height: 40,
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(5)
    ),
    child: TextFormField(
      controller: controller,
      obscureText: obsecure,
      style: TextStyle(
        color: AppColors.blackColor,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: icon,
        hintText: text,
        hintStyle: GoogleFonts.poppins(
          color: Colors.blueGrey,
          fontSize: 15,
          fontWeight: FontWeight.w400
        ),
      ),
    ),);
  }
}
