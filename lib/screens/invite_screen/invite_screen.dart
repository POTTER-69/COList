import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import 'package:colist_proj/widgets/spacing_widgets.dart';
import 'package:colist_proj/widgets/back_button_widget.dart';

class InviteCollaboratorsScreen extends StatelessWidget {
  const InviteCollaboratorsScreen({super.key});

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
            onPressed: () => Navigator.pop(context),
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
              // Handle menu action
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeightSpace(20),

          // Suggested Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Suggested',
              style: AppStyles.black18BoldStyle,
            ),
          ),

          HeightSpace(16),

          // Suggested People List
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

          // Shareable Link Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Shareable Link',
              style: AppStyles.black18BoldStyle,
            ),
          ),

          HeightSpace(16),

          // Generate Link Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: InkWell(
              onTap: () {
                // Handle generate link
              },
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

      // Bottom Navigation Bar
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
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.notifications_outlined, size: 28.sp, color: AppColors.greyColor),
                  onPressed: () {},
                ),
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.content_paste_rounded, color: Colors.white, size: 28.sp),
                    onPressed: () {},
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined, size: 28.sp, color: AppColors.greyColor),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.settings_outlined, size: 28.sp, color: AppColors.greyColor),
                  onPressed: () {},
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
        // Handle person selection
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Row(
          children: [
            // Profile Avatar
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

            // Name and Email
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

// Helper classes (already in your project, included here for reference)
class AppColors {
  static Color primaryColor = const Color(0xff617AFD);
  static Color secondaryColor = const Color(0xff8391A1);
  static Color blackColor = const Color(0xff1F2C37);
  static Color greyColor = const Color(0xff9CA4AB);
  static Color whiteColor = Colors.white;
}

class AppFonts {
  static String mainFontName = "Urbanist";
}

class AppStyles {
  static TextStyle primaryHeadLinesStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 30.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  static TextStyle subtitlesStyles = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryColor,
  );

  static TextStyle black16w500Style = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );

  static TextStyle grey12MediumStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.greyColor,
  );

  static TextStyle black15BoldStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle black18BoldStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}

class HeightSpace extends StatelessWidget {
  final double height;
  const HeightSpace(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.h);
  }
}

class WidthSpace extends StatelessWidget {
  final double width;
  const WidthSpace(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width.w);
  }
}