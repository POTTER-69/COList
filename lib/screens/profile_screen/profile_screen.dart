import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:colist_proj/routes/app_routs.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/widgets/spacing_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late String displayName;

  @override
  void initState() {
    super.initState();
    displayName = user?.displayName ?? "No Name Set";
  }

  Future<void> _updateNameDialog() async {
    final TextEditingController nameController = TextEditingController(text: displayName);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Name"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Enter your full name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await user?.updateDisplayName(nameController.text.trim());
                await user?.reload();

                setState(() {
                  displayName = nameController.text.trim();
                });

                if (mounted) Navigator.pop(context);
              }
            },
            child: Text("Save", style: TextStyle(color: AppColors.primaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String email = user?.email ?? "No Email";
    final String initials = displayName.isNotEmpty
        ? displayName.trim().split(' ').map((l) => l[0]).take(2).join().toUpperCase()
        : "US";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("My Profile", style: AppStyles.black18BoldStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor, size: 20.sp),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note, color: AppColors.primaryColor, size: 28.sp),
            onPressed: _updateNameDialog,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeightSpace(30),

            Center(
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            HeightSpace(40),

            Text("Full Name", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            HeightSpace(8),
            Text(
              displayName,
              style: AppStyles.black16w500Style.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Divider(height: 30.h, color: Colors.grey[200]),

            Text("Email", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            HeightSpace(8),
            Text(
              email,
              style: AppStyles.black16w500Style.copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            Divider(height: 30.h, color: Colors.grey[200]),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.home_outlined, size: 28.sp, color: AppColors.greyColor), onPressed: () => context.go(AppRoutes.homeScreen)),
                IconButton(icon: Icon(Icons.notifications_outlined, size: 28.sp, color: AppColors.greyColor), onPressed: () => context.push(AppRoutes.notificationScreen)),
                InkWell(
                  onTap: () => context.push(AppRoutes.addToListScreen),
                  child: Container(
                    width: 56.w, height: 56.h,
                    decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]),
                    child: Center(child: Container(width: 22.w, height: 22.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6.r)), child: Icon(Icons.add, color: AppColors.primaryColor, size: 18.sp))),
                  ),
                ),
                IconButton(icon: Icon(Icons.inventory_2_outlined, size: 28.sp, color: AppColors.greyColor), onPressed: () => context.push(AppRoutes.archivedScreen)),
                IconButton(icon: Icon(Icons.settings_outlined, size: 28.sp, color: AppColors.primaryColor), onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}