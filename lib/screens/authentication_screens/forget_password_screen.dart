import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';


import '../../routes/app_routs.dart';
import '../../utils/constants/app_text_styles.dart';
import '../../widgets/back_button_widget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primay_button_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 زر الرجوع
                Container(
                  alignment: Alignment.topLeft,
                  child: const BackButtonWidget(),
                ),
                SizedBox(height: 32.h),

                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF617AFD),
                  ),
                ),
                SizedBox(height: 12.h),


                Text(
                  "Don't worry! It occurs. Please enter the email address linked with your account.",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF8391A1),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 32.h),


                CustomTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },


                ),
                SizedBox(height: 32.h),


                PrimaryButtonWidget(
                  buttonText: "create new password",
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      context.pushNamed(AppRoutes.createNewPasswordScreen);
                    }
                  },
                ),

                SizedBox(height: 330.h),


                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Remember Password? ",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFF617AFD),
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: "Login",
                          style: AppStyles.black15BoldStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pushNamed(AppRoutes.loginScreen);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

