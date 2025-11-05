import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/constants/app_assets.dart';
import '../utils/constants/app_text_styles.dart';

class SettingsWidgetsAccount extends StatelessWidget {
  const SettingsWidgetsAccount({super.key, required this.title, required this.iconPath, required this.subTitle});
final  String title ;
final  String iconPath ;
final  String subTitle ;



  @override
  Widget build(BuildContext context) {
    return   Row(
      children: [
        SvgPicture.asset(iconPath),
        SizedBox(height: 16.h,),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$title",style: AppStyles.black15BoldStyle.copyWith(fontWeight: FontWeight.w500),),
              Text("$subTitle",style: AppStyles.grey12MediumStyle,),

            ],
          ),
        )
      ],
    );
  }
}
