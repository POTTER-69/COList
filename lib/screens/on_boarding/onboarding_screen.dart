import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routs.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_text_styles.dart';
import '../../widgets/primay_button_widget.dart';
import '../../widgets/spacing_widgets.dart';
import 'on_boarding_services/on_boarding_services.dart';
import '../../utils/constants/app_assets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;


  final CarouselSliderController carouselController = CarouselSliderController();

  List<String> images = [
    AppAssets.onBoarding1,
    AppAssets.onBoarding2,
    AppAssets.onBoarding3,
  ];

  List<String> titles = [
    "Simplify Your Shopping",
    "Shop Together, Stay Organized",
    "Real-time Updates, Always Synced",
  ];

  List<String> descriptions = [
    "Collaborate on shopping lists with ease, ensuring everyone stays on the same page.",
    "Collaborate with friends and family on shared shopping lists. Never miss an item again.",
    "Experience seamless collaboration with instant updates to your shared shopping lists. Never miss an item again.",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool isFirstTime = OnBoardingServices.isFirstTime();
      if (!isFirstTime) {
        GoRouter.of(context).pushReplacementNamed(AppRoutes.welcomeScreen);
      }
        var setFirstTimeWithFalse = OnBoardingServices.setFirstTimeWithFalse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: CarouselSlider.builder(
              carouselController: carouselController,
              itemCount: titles.length,
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIdx) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      images[index],
                      height: 812.h * 0.5,
                      width: double.infinity,
                      fit: BoxFit.cover,

                    ),
                    HeightSpace(20.h),
                    Text(
                      titles[index],
                      style: AppStyles.primaryHeadLinesStyle,
                      textAlign: TextAlign.center,
                    ),
                    HeightSpace(12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        descriptions[index],
                        style: AppStyles.subtitlesStyles,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(titles.length, (index) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      width: currentIndex == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? AppColors.primaryColor
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                ),
                HeightSpace(50.h),
                PrimaryButtonWidget(
                    buttonText: currentIndex == titles.length - 1
                        ? "Get Started"
                        : "Next",
                  onPress: () {
                    if (currentIndex == titles.length - 1) {
                      GoRouter.of(context).pushReplacementNamed(AppRoutes.welcomeScreen);
                    } else {
                      carouselController.nextPage();
                    }
                  },
                ),


              ],
            ),
          )
        ],
      ),
    );
  }
}
