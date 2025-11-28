import 'dart:io';
import 'package:colist_proj/routes/app_routs.dart';
import 'package:colist_proj/utils/constants/app_assets.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/widgets/custom_text_field_add_to_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _isLoading = false;

  int _itemQuantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text("Add List", style: AppStyles.black18BoldStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFieldAddToList(
                listNameController: listNameController,
                title: "List Name",
              ),
              SizedBox(height: 32.h),
              Text(
                "Add image",
                style: AppStyles.black18BoldStyle.copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.h),

              Center(
                child: InkWell(
                  onTap: _showImagePickerOptions,
                  borderRadius: BorderRadius.circular(8.r),
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
                style: AppStyles.black18BoldStyle.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomTextFieldAddToList(
                      listNameController: itemController,
                      title: "Add Item",
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8F9),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFE8ECF4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 20.sp),
                          color: AppColors.primaryColor,
                          onPressed: () {
                            if (_itemQuantity > 1) {
                              setState(() {
                                _itemQuantity--;
                              });
                            }
                          },
                        ),
                        Text(
                          '$_itemQuantity',
                          style: AppStyles.black16w500Style.copyWith(fontSize: 18.sp),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, size: 20.sp),
                          color: AppColors.primaryColor,
                          onPressed: () {
                            setState(() {
                              _itemQuantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 48.h),

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
                  onPressed: _isLoading ? null : _createList,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Create",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
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
    if (mounted) Navigator.pop(context);
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance.ref().child('list_images/$fileName.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _createList() async {
    if (listNameController.text.isEmpty || itemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter list name and at least one item")),
      );
      return;
    }

    setState(() => _isLoading = true);

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
    }

    final firstItem = {
      'name': itemController.text.trim(),
      'quantity': _itemQuantity,
      'isChecked': false,
    };

    await FirebaseFirestore.instance.collection('lists').add({
      'name': listNameController.text.trim(),
      'items': [firstItem],
      'imageUrl': imageUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'members': [],
    });

    if (mounted) {
      setState(() => _isLoading = false);
      GoRouter.of(context).go(AppRoutes.homeScreen);
    }
  }
}