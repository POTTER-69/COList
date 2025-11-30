import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../routes/app_routs.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_text_styles.dart';
import '../../widgets/back_button_widget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primay_button_widget.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // 1. المتغير المسؤول عن حالة الظهور (false = مخفي في البداية)
  bool _isPasswordVisible = false;

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  const BackButtonWidget(),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: 280.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back!",
                          style: AppStyles.primaryHeadLinesStyle,
                        ),
                        Text(
                          "Again!",
                          style: AppStyles.primaryHeadLinesStyle,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // حقل الإيميل
                  CustomTextField(
                    controller: emailController,
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

                  SizedBox(height: 15.h),

                  // حقل الباسورد (تم التعديل هنا)
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Enter your password",

                    // ✅ التعديل المهم: ربط الخاصية بالمتغير وعكسه
                    // لو _isPasswordVisible = false (مخفي)، يبقى obscureText لازم تكون true والعكس
                    obscureText: !_isPasswordVisible,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          // عكس الحالة عند الضغط
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      // تغيير الأيقونة
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility // عين مفتوحة
                            : Icons.visibility_off, // عين مقفولة
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // زر نسيت كلمة المرور
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.pushNamed(AppRoutes.forgetPasswordScreen);
                      },
                      child: Text(
                        "Forget Password?",
                        style: AppStyles.black16w500Style.copyWith(
                          color: const Color(0xff6A707C),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // زر تسجيل الدخول
                  PrimaryButtonWidget(
                    buttonText: _isLoading ? "Loading..." : "Login",
                    onPress: _isLoading
                        ? () {}
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          await _authService.signInWithEmailPassword(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                          if (mounted) {
                            // الانتقال للهوم سكرين
                            GoRouter.of(context).go(AppRoutes.homeScreen);
                          }
                        } on FirebaseAuthException catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.message ?? "Login failed"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      }
                    },
                  ),

                  SizedBox(height: 30.h),
                  SizedBox(height: 190.h),

                  // زر التسجيل الجديد
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppStyles.black16w500Style.copyWith(
                          color: AppColors.primaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: "Register Now",
                            style: AppStyles.black15BoldStyle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(AppRoutes.registerScreen);
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
      ),
    );
  }
}