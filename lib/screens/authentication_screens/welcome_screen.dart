import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routs.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_text_styles.dart';
import '../../widgets/primary_outlined_button_widget.dart';
import '../../widgets/primay_button_widget.dart';
import '../../widgets/spacing_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            AppAssets.welcomeScreen,
            width: double.infinity,
            height: 362.h,
            fit: BoxFit.fitWidth,
          ),
          const HeightSpace(6),
          Text(
            "Welcome to CoList",
            style: AppStyles.primaryHeadLinesStyle,
          ),
          const HeightSpace(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // 8 من الشمال واليمين
            child: Text(
              "Create and share shopping lists with your friends & family in real-time.",
              textAlign: TextAlign.center,
              style: AppStyles.subtitlesStyles,
            ),
          ),

          const HeightSpace(100),
          PrimaryButtonWidget(
            width: 318.w,
            height: 53.h,
            onPress: () {
              GoRouter.of(context).pushNamed(AppRoutes.loginScreen);
            },
            buttonText: "Login",
          ),
          const HeightSpace(20),
          PrimaryOutlinedButtonWidget(
            width: 318.w,
            height: 53.h,
            onPress: () {
              GoRouter.of(context).pushNamed(AppRoutes.registerScreen);
            },
            buttonText: "Register",
          ),

        ],
      ),
    );
  }
}