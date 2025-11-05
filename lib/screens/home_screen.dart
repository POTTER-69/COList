import 'package:colist_proj/utils/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants/app_text_styles.dart';
import '../widgets/list_card_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading:             IconButton(
          icon: SvgPicture.asset(AppAssets.personn),
          onPressed: () {
          },
        ),

        actions: [
          IconButton(
            icon: SvgPicture.asset(AppAssets.search),
            onPressed: () {
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Your Lists",
                style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 20),
              ),
               SizedBox(height: 16.h),

              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.78,
                children: const [
                  ListCard(
                    imagePath: AppAssets.photo1,
                    title: "Grocery Shopping",
                    members: "2 members",
                    lastUpdated: "Last updated 2d ago",
                  ),
                  ListCard(
                    imagePath: AppAssets.photo2,
                    title: "Weekend Trip",
                    members: "3 members",
                    lastUpdated: "Last updated 1w ago",
                  ),
                  ListCard(
                    imagePath: AppAssets.photo3,
                    title: "Household Supplies",
                    members: "1 member",
                    lastUpdated: "Last updated 2w ago",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

