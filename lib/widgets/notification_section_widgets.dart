import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants/app_text_styles.dart';

class NotificationSectionWidget extends StatefulWidget {
  const NotificationSectionWidget({
    super.key,
    required this.title,
    required this.iconPath,
    required this.subTitle,
  });

  final String title;
  final String iconPath;
  final String subTitle;

  @override
  State<NotificationSectionWidget> createState() => _NotificationSectionWidgetState();
}

class _NotificationSectionWidgetState extends State<NotificationSectionWidget> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              SvgPicture.asset(widget.iconPath),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: AppStyles.black16w500Style,
                  ),
                  Text(
                    widget.subTitle,
                    style: AppStyles.grey12MediumStyle,
                  ),
                ],
              ),
            ],
          ),

          Switch(
            value: isNotificationEnabled,
            activeColor: Colors.white,
            activeTrackColor: Colors.blueAccent,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
            onChanged: (value) {
              setState(() {
                isNotificationEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
