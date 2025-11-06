import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/app_colors.dart';

class ListCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String members;
  final String lastUpdated;

  final VoidCallback? onDelete;

  const ListCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.members,
    required this.lastUpdated,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  onSelected: (value) {
                    if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imagePath.isNotEmpty
                    ? Image.network(
                  imagePath,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 90,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 40),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                lastUpdated,
                style: TextStyle(color: AppColors.greyColor, fontSize: 12),
              ),
              SizedBox(height: 4.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                members,
                style: TextStyle(color: AppColors.greyColor, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
