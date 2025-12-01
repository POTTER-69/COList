import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routs.dart';
import '../../widgets/primay_button_widget.dart';
import '../../widgets/spacing_widgets.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/sticker.svg',
                  height: 100.sp,
                  width: 100.sp,
                ),
                HeightSpace(32.h),
                Text(
                  "Password Changed!",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF617AFD),
                  ),
                ),
                HeightSpace(12.h),
                Text(
                  "Your password has been successfully changed.\nYou can now log in with your new password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF838BA1),
                  ),
                ),
                HeightSpace(40.h),
                PrimaryButtonWidget(
                  buttonText: "Back to Login",
                  onPress: () {
                    context.goNamed(AppRoutes.loginScreen);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
