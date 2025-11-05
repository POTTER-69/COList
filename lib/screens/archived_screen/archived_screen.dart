
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_text_styles.dart';
import '../../widgets/spacing_widgets.dart';
import 'archiverd_list_card.dart';

class ArchivedScreen extends StatefulWidget {
  const ArchivedScreen({super.key});

  @override
  State<ArchivedScreen> createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text('Archived', style: AppStyles.black18BoldStyle),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: const [
          ArchivedListCard(
            date: 'Archived on 12/12/2023',
            listName: 'Grocery Shopping',
            itemCount: 12,
            image: Color(0xFFFFF8E1),
          ),
          HeightSpace(12),
          ArchivedListCard(
            date: 'Archived on 11/20/2023',
            listName: 'Home Supplies',
            itemCount: 8,
            image: Color(0xFFE8F5E9),
          ),
          HeightSpace(12),
          ArchivedListCard(
            date: 'Archived on 10/5/2023',
            listName: 'Party Supplies',
            itemCount: 15,
            image: Color(0xFFE1F5FE),
          ),
        ],
      ),
    );
  }
}
