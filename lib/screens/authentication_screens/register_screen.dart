import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routs.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_text_styles.dart';
import '../../widgets/back_button_widget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primay_button_widget.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BackButtonWidget(),
                          SizedBox(height: 24.h),
                          Text(
                            'Hello! Register to get\nstarted',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6C7CE7),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 40.h),

                          // Username Field
                          CustomTextField(
                            controller: _usernameController,
                            hintText: 'Username',

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Email Field
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (!value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Password Field
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Password',

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          // Confirm Password Field
                          CustomTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm password',

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 32.h),

                          // Register Button
                          PrimaryButtonWidget(
                            buttonText: "Register",
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                print(
                                  'Register data: ${_usernameController.text}, ${_emailController.text}',
                                );
                              }
                            },
                          ),
                          SizedBox(height: 32.h),


                          SizedBox(height: 24.h),



                          SizedBox(height: 32.h),
                          Center(child: _buildLoginLink()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }




  Widget _buildLoginLink() {
    return RichText(
      text: TextSpan(
        text: "Already have an account? ",
        style: AppStyles.black16w500Style.copyWith(
          color: AppColors.primaryColor,
        ),
        children: [
          TextSpan(
            text: "Login Now",
            style: AppStyles.black15BoldStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.pushNamed(AppRoutes.loginScreen);
              },
          ),
        ],
      ),
    );
  }
}




