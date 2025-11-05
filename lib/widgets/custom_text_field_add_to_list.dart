import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_text_styles.dart';

class CustomTextFieldAddToList extends StatelessWidget {
  final TextEditingController? listNameController;
 final String title;
  const CustomTextFieldAddToList({super.key, this.listNameController, required this.title});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: listNameController,
      decoration: InputDecoration(
        hintText: title,
        hintStyle: AppStyles.grey12MediumStyle,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
