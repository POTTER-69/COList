import 'package:colist_proj/routes/app_routs.dart';
import 'package:colist_proj/routes/router_generation_config.dart';
import 'package:colist_proj/utils/constants/app_assets.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/widgets/notification_section_widgets.dart';
import 'package:colist_proj/widgets/primay_button_widget.dart';
import 'package:colist_proj/widgets/settings_widgets_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isNotificationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Settings",
          style: AppStyles.black18BoldStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Account",
                style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 22),
              ),
              SizedBox(height: 12.h),
              SettingsWidgetsAccount(
                title: "Profile",
                iconPath: AppAssets.profile,
                subTitle: "Manage your profile information",
              ),
              SizedBox(height: 5.h),
              SettingsWidgetsAccount(
                title: "Password",
                iconPath: AppAssets.lock,
                subTitle: "Change your password",
              ),
          
              SizedBox(height: 16.h),
          
              Text(
                "Preferences",
                style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 22),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(AppAssets.theme),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Theme",
                            style: AppStyles.black15BoldStyle
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Choose your preferred theme",
                            style: AppStyles.grey12MediumStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Light",
                    style: AppStyles.black16w500Style
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
          
              SizedBox(height: 16.h),
          
              Text(
                "Notifications",
                style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 22),
              ),
              SizedBox(height: 8.h),
              NotificationSectionWidget(title: "Push Notifications", iconPath: AppAssets.notif, subTitle: "Enable or disable push \nnotifications"),
              NotificationSectionWidget(title: "Email Notifications", iconPath: AppAssets.email, subTitle: "Manage email notifications"),
              SizedBox(height: 16.h),
              Text(
                "Privcy",
                style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 22),
              ),
              SettingsWidgetsAccount(title: "Privacy Settings", iconPath: AppAssets.privcy, subTitle: "Review and update your privacy settings"),
              SettingsWidgetsAccount(title: "Terms of Service", iconPath: AppAssets.file, subTitle: "Read our terms of service"),
              SettingsWidgetsAccount(title: "Privacy Policy", iconPath: AppAssets.file, subTitle: "View our privacy policy"),
              SizedBox(height: 16,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8)
                    ),
                    
                    backgroundColor: AppColors.primaryColor
                  ),
                  onPressed: () {
                    GoRouter.of(context).pushNamed(AppRoutes.loginScreen);

              }, child: Center(child: Text("LogOut",style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor
              ),)))
            ],
          ),
        ),
      ),
    );
  }
}
