
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_text_styles.dart';
import 'notifications_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text('Notifications', style: AppStyles.black18BoldStyle),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: const [
          NotificationItem(
            name: 'Youmna',
            action: "Added 3 items to 'Grocery List'",
            imageColor: Color(0xFFF5E6D3),
          ),
          NotificationItem(
            name: 'Ibrahim',
            action: "Edited 'Grocery List'",
            imageColor: Color(0xFFE8F4F8),
          ),
          NotificationItem(
            name: 'Heba',
            action: "Added 1 item to 'Grocery List'",
            imageColor: Color(0xFFFFF0E6),
          ),
          NotificationItem(
            name: 'Ahmed',
            action: "Edited 'Weekend List'",
            imageColor: Color(0xFFE6E6E6),
          ),
          NotificationItem(
            name: 'Salma',
            action: "Added 3 items to 'Grocery List'",
            imageColor: Color(0xFFFFF5E6),
          ),
          NotificationItem(
            name: 'Wadah',
            action: "Edited 'Grocery List'",
            imageColor: Color(0xFFFFE6D9),
          ),
        ],
      ),
    );
  }
}
