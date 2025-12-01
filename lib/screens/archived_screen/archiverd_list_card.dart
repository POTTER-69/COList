import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_text_styles.dart';
import '../../widgets/spacing_widgets.dart';

class ArchivedListCard extends StatelessWidget {
  final String date;
  final String listName;
  final int itemCount;
  final Color image;
  final VoidCallback onMoreTap;

  const ArchivedListCard({
    super.key,
    required this.date,
    required this.listName,
    required this.itemCount,
    required this.image,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date, style: AppStyles.grey12MediumStyle),
                  const HeightSpace(6),
                  Text(
                    listName,
                    style: AppStyles.black16w500Style.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const HeightSpace(4),
                  Text(
                    '$itemCount items',
                    style: AppStyles.grey12MediumStyle.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),

            // More Button
            GestureDetector(
              onTap: onMoreTap,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black12,
                child: Icon(Icons.more_vert, color: Colors.black),
              ),
            ),

            WidthSpace(10),

            Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: image,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 30.sp,
                  color: AppColors.greyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
