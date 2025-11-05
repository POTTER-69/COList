import 'dart:io';
import 'package:colist_proj/utils/constants/app_assets.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/widgets/custom_text_field_add_to_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class AddToList extends StatefulWidget {
  const AddToList({super.key});

  @override
  State<AddToList> createState() => _AddToListState();
}

class _AddToListState extends State<AddToList> {
  final TextEditingController listNameController = TextEditingController();
  final TextEditingController itemController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Add List",
          style: AppStyles.black18BoldStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List name input
            CustomTextFieldAddToList(
              listNameController: listNameController,
              title: "List Name",
            ),
            SizedBox(height: 32.h),

            Text(
              "Add image",
              style: AppStyles.black18BoldStyle.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: InkWell(
                onTap: _showImagePickerOptions,
                child: Container(
                  height: 175.h,
                  width: 263.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8ECF4),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: _selectedImage == null
                      ? Center(
                    child: IconButton(
                      onPressed: _showImagePickerOptions,
                      icon: SvgPicture.asset(AppAssets.image),
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),

            Text(
              "Items",
              style: AppStyles.black18BoldStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),

            CustomTextFieldAddToList(
              listNameController: itemController,
              title: "Add Item",
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                },
                child: Text(
                  "Create",
                  style:
                  TextStyle(color: AppColors.whiteColor, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Image", style: AppStyles.black18BoldStyle),
              SizedBox(height: 12.h),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Choose from Gallery"),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }


}
