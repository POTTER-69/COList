
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

  const ArchivedListCard({
    super.key,
    required this.date,
    required this.listName,
    required this.itemCount,
    required this.image,
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
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: image,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 32.sp,
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
