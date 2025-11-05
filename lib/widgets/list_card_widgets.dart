import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';

class ListCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String members;
  final String lastUpdated;

  const ListCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.members,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            spreadRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Icon(Icons.more_vert, color: Colors.grey[600]),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              lastUpdated,
              style:  TextStyle(color: AppColors.greyColor, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style:  TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              members,
              style:  TextStyle(color: AppColors.greyColor, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
