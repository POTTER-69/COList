import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routs.dart';
import '../../widgets/back_button_widget.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primay_button_widget.dart';
import '../../widgets/spacing_widgets.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButtonWidget(),
              HeightSpace(32.h),
              Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF617AFD),
                ),
              ),
              HeightSpace(12.h),
              Text(
                "Your new password must be different from previous used passwords.",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFF838BA1),
                  height: 1.6,
                ),
              ),
              HeightSpace(40.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _passwordController,
                      hintText: "New Password",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a new password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    HeightSpace(16.h),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    HeightSpace(32.h),
                    PrimaryButtonWidget(
                      buttonText: "Reset Password",
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          context.pushNamed(AppRoutes.passwordChangedScreen);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
