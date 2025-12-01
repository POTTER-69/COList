import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:colist_proj/routes/app_routs.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/widgets/spacing_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Settings", style: AppStyles.black18BoldStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor, size: 20.sp),
          onPressed: () => context.go(AppRoutes.homeScreen),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Account Section ===
            _buildSectionHeader("Account"),

            _buildSettingsTile(
              icon: Icons.person_outline,
              title: "Profile",
              subtitle: "Manage your profile information",
              onTap: () => context.push(AppRoutes.profileScreen),
            ),

            _buildSettingsTile(
              icon: Icons.lock_outline,
              title: "Password",
              subtitle: "Change your password",
              onTap: () {
                context.push(AppRoutes.forgetPasswordScreen);
              },
            ),

            _buildSectionHeader("Preferences"),
            _buildSettingsTile(
              icon: Icons.wb_sunny_outlined,
              title: "Theme",
              subtitle: "Choose your preferred theme",
              trailing: Text("Light", style: TextStyle(fontSize: 14.sp, color: Colors.black)),
              onTap: () {},
            ),

            _buildSectionHeader("Notifications"),
            _buildSwitchTile(
              icon: Icons.notifications_none,
              title: "Push Notifications",
              subtitle: "Enable or disable push notifications",
              value: _pushNotifications,
              onChanged: (val) => setState(() => _pushNotifications = val),
            ),
            _buildSwitchTile(
              icon: Icons.email_outlined,
              title: "Email Notifications",
              subtitle: "Manage email notifications",
              value: _emailNotifications,
              onChanged: (val) => setState(() => _emailNotifications = val),
            ),


            _buildSectionHeader("Privacy"),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Settings",
              subtitle: "Review and update your privacy settings",
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.description_outlined,
              title: "Terms of Service",
              subtitle: "Read our terms of service",
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.policy_outlined,
              title: "Privacy Policy",
              subtitle: "View our privacy policy",
              onTap: () {},
            ),

            HeightSpace(30),

            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    context.go(AppRoutes.loginScreen);
                  }
                },
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 80.h,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Icon(Icons.add, color: Colors.white, size: 28.sp),
              ),
            ),
            IconButton(
              icon: Icon(Icons.inventory_2_outlined, size: 28.sp, color: AppColors.greyColor),
              onPressed: () => context.push(AppRoutes.archivedScreen),
            ),
            IconButton(
              icon: Icon(Icons.settings, size: 28.sp, color: AppColors.primaryColor),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: Colors.black87, size: 20.sp),
        ),
        title: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FA),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: Colors.black87, size: 20.sp),
        ),
        title: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        value: value,
        activeColor: AppColors.primaryColor,
        onChanged: onChanged,
      ),
    );
  }
}