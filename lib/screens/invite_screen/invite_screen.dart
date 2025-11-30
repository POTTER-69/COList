import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:colist_proj/routes/app_routs.dart';
import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import 'package:colist_proj/widgets/spacing_widgets.dart';

class InviteCollaboratorsScreen extends StatelessWidget {
  final String listId;
  final String listName;

  const InviteCollaboratorsScreen({
    super.key,
    required this.listId,
    required this.listName,
  });

  void _shareListLink(BuildContext context) {
    final String inviteLink = "https://colist.app/listDetailsScreen?id=$listId&name=$listName";

    final String message = "Join my list '$listName' on CoList app:\n$inviteLink";

    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(
          'Invite Collaborators',
          style: AppStyles.black18BoldStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: AppColors.greyColor),
            onPressed: () {
              },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeightSpace(20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Suggested',
              style: AppStyles.black18BoldStyle,
            ),
          ),

          HeightSpace(16),

          const SuggestedPersonItem(
            name: 'Ibrahim Ahmed',
            email: 'Ibrahim@gmail.com',
            imageColor: Color(0xFFE8F4F8),
          ),
          const SuggestedPersonItem(
            name: 'Ahmed Ibrahim',
            email: 'Ahmed@gmail.com',
            imageColor: Color(0xFFFFF0E6),
          ),
          const SuggestedPersonItem(
            name: 'Wadah Mohamed',
            email: 'Wadah@gmail.com',
            imageColor: Color(0xFFE6E6E6),
          ),
          const SuggestedPersonItem(
            name: 'Samir Mohamed',
            email: 'Samir@gmail.com',
            imageColor: Color(0xFFFFF8E1),
          ),

          HeightSpace(32),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Shareable Link',
              style: AppStyles.black18BoldStyle,
            ),
          ),

          HeightSpace(16),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: InkWell(
              onTap: () => _shareListLink(context),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE8ECF4), width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.link,
                      color: AppColors.blackColor,
                      size: 24.sp,
                    ),
                    WidthSpace(12),
                    Text(
                      'Generate Link',
                      style: AppStyles.black16w500Style,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.home_outlined, size: 28.sp, color: AppColors.greyColor),
                  onPressed: () => context.go(AppRoutes.homeScreen),
                ),
                IconButton(
                  icon: Icon(Icons.notifications_outlined, size: 28.sp, color: AppColors.greyColor),
                  onPressed: () => context.push(AppRoutes.notificationScreen),
                ),
                InkWell(
                  onTap: () => context.push(AppRoutes.addToListScreen),
                  child: Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 22.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(Icons.add, color: AppColors.primaryColor, size: 18.sp),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.inventory_2_outlined, size: 28.sp, color: AppColors.greyColor),
                  onPressed: () => context.push(AppRoutes.archivedScreen),
                ),
                IconButton(
                  icon: Icon(Icons.settings_outlined, size: 28.sp, color: AppColors.greyColor),
                  onPressed: () => context.push(AppRoutes.settingsScreen),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SuggestedPersonItem extends StatelessWidget {
  final String name;
  final String email;
  final Color imageColor;

  const SuggestedPersonItem({
    super.key,
    required this.name,
    required this.email,
    required this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: imageColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            WidthSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppStyles.black16w500Style.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  HeightSpace(4),
                  Text(
                    email,
                    style: AppStyles.grey12MediumStyle.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}