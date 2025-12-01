import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                CustomTextFieldAddToList(listNameController: listNameController, title: "List Name"),
                SizedBox(height: 32.h),
                Text("Add image", style: AppStyles.black18BoldStyle.copyWith(fontWeight: FontWeight.w500)),
                SizedBox(height: 8.h),
                Center(
                  child: InkWell(
                    onTap: _showImagePickerOptions,
                    child: Container(
                      height: 175.h, width: 263.w,
                      decoration: BoxDecoration(color: const Color(0xFFE8ECF4), borderRadius: BorderRadius.circular(8.r)),
                      child: _selectedImage == null
                          ? Center(child: SvgPicture.asset(AppAssets.image))
                          : ClipRRect(borderRadius: BorderRadius.circular(8.r), child: Image.file(_selectedImage!, fit: BoxFit.cover)),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Text("First Item", style: AppStyles.black18BoldStyle.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: CustomTextFieldAddToList(listNameController: itemController, title: "Item Name")),
                    SizedBox(width: 12.w),
                    Container(
                      height: 50.h,
                      decoration: BoxDecoration(color: const Color(0xFFF7F8F9), borderRadius: BorderRadius.circular(8.r), border: Border.all(color: const Color(0xFFE8ECF4))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(Icons.remove, size: 20.sp), color: AppColors.primaryColor, onPressed: () { if (_itemQuantity > 1) setState(() => _itemQuantity--); }),
                          Text('$_itemQuantity', style: AppStyles.black16w500Style.copyWith(fontSize: 18.sp)),
                          IconButton(icon: Icon(Icons.add, size: 20.sp), color: AppColors.primaryColor, onPressed: () { setState(() => _itemQuantity++); }),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48.h),
                SizedBox(
                  width: double.infinity, height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                    onPressed: _isLoading ? null : _createList,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text("Create List", style: TextStyle(color: AppColors.whiteColor, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(context: context, builder: (_) {
      return Padding(padding: EdgeInsets.all(16.0), child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.camera_alt), title: const Text("Take Photo"), onTap: () => _pickImage(ImageSource.camera)),
        ListTile(leading: const Icon(Icons.image), title: const Text("Gallery"), onTap: () => _pickImage(ImageSource.gallery)),
      ]));
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) setState(() => _selectedImage = File(pickedFile.path));
    if (mounted) Navigator.pop(context);
  }

  Future<String?> _convertImageToBase64(File imageFile) async {
    try {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path, minWidth: 600, minHeight: 600, quality: 50,
      );
      if (compressedBytes != null) return base64Encode(compressedBytes);
      return null;
    } catch (e) { return null; }
  }

  Future<void> _createList() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Login First!")));
      return;
    }

    if (listNameController.text.isEmpty || itemController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter details")));
      return;
    }
    setState(() => _isLoading = true);

    String imageUrl = "";
    if (_selectedImage != null) {
      String? base64 = await _convertImageToBase64(_selectedImage!);
      if (base64 != null) imageUrl = base64;
    }

    final firstItem = {
      'name': itemController.text.trim(),
      'quantity': _itemQuantity,
      'isChecked': false,
    };

    try {
      await FirebaseFirestore.instance.collection('lists').add({
        'name': listNameController.text.trim(),
        'items': [firstItem],
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),

        'ownerId': user.uid,
        'members': [user.uid],
      });

      if (mounted) {
        setState(() => _isLoading = false);
        GoRouter.of(context).go(AppRoutes.homeScreen);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}