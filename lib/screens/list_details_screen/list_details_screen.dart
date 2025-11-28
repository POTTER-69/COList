import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:colist_proj/routes/app_routs.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/widgets/spacing_widgets.dart';

class ListDetailsScreen extends StatefulWidget {
  final String listId;
  final String listName;

  const ListDetailsScreen({
    super.key,
    required this.listId,
    required this.listName,
  });

  @override
  State<ListDetailsScreen> createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {

  void _showAddItemModal(BuildContext context) {
    final TextEditingController itemController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.w,
            right: 16.w,
            top: 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add New Item", style: AppStyles.black18BoldStyle),
              SizedBox(height: 16.h),
              TextField(
                controller: itemController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Enter item name (e.g., Milk)",
                  filled: true,
                  fillColor: const Color(0xFFF7F8F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
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
                  onPressed: () async {
                    if (itemController.text.isNotEmpty) {
                      final newItem = {
                        'name': itemController.text.trim(),
                        'quantity': 1,
                        'isChecked': false,
                      };

                      await FirebaseFirestore.instance
                          .collection('lists')
                          .doc(widget.listId)
                          .update({
                        'items': FieldValue.arrayUnion([newItem]),
                        'updatedAt': FieldValue.serverTimestamp(),
                      });

                      if (context.mounted) {
                        Navigator.pop(context);
                        itemController.clear();
                      }
                    }
                  },
                  child: const Text("Add Item", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateItem(List<dynamic> currentItems, int index, Map<String, dynamic> updatedItem) async {
    currentItems[index] = updatedItem;
    await FirebaseFirestore.instance
        .collection('lists')
        .doc(widget.listId)
        .update({
      'items': currentItems,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _deleteItem(List<dynamic> currentItems, int index) async {
    currentItems.removeAt(index);
    await FirebaseFirestore.instance
        .collection('lists')
        .doc(widget.listId)
        .update({
      'items': currentItems,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(widget.listName, style: AppStyles.black18BoldStyle),
        centerTitle: true,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeightSpace(20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text('Items', style: AppStyles.black18BoldStyle),
          ),
          HeightSpace(16),
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('lists')
                  .doc(widget.listId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("List not found"));
                }

                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                List<dynamic> itemsList = data['items'] ?? [];

                if (itemsList.isEmpty) {
                  return Center(
                    child: Text("No items yet.", style: AppStyles.grey12MediumStyle),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: itemsList.length,
                  itemBuilder: (context, index) {
                    final itemData = itemsList[index];
                    Map<String, dynamic> itemMap;

                    if (itemData is String) {
                      itemMap = {'name': itemData, 'quantity': 1, 'isChecked': false};
                    } else {
                      itemMap = itemData as Map<String, dynamic>;
                    }

                    return GroceryItemWidget(
                      name: itemMap['name'],
                      quantity: itemMap['quantity'] ?? 1,
                      isChecked: itemMap['isChecked'] ?? false,
                      onChanged: (val) {
                        itemMap['isChecked'] = val;
                        _updateItem(itemsList, index, itemMap);
                      },
                      onIncrement: () {
                        int currentQty = itemMap['quantity'] ?? 1;
                        itemMap['quantity'] = currentQty + 1;
                        _updateItem(itemsList, index, itemMap);
                      },
                      onDecrement: () {
                        int currentQty = itemMap['quantity'] ?? 1;
                        if (currentQty > 1) {
                          itemMap['quantity'] = currentQty - 1;
                          _updateItem(itemsList, index, itemMap);
                        }
                      },
                      onDelete: () {
                        _deleteItem(itemsList, index);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: Container(
        width: 56.w, height: 56.h,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white, size: 28.sp),
          onPressed: () => _showAddItemModal(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.home_outlined, size: 28.sp, color: AppColors.greyColor), onPressed: () => context.go(AppRoutes.homeScreen)),
                IconButton(icon: Icon(Icons.notifications_outlined, size: 28.sp, color: AppColors.greyColor), onPressed: () => context.push(AppRoutes.notificationScreen)),
                InkWell(
                  onTap: () => context.push(AppRoutes.addToListScreen),
                  child: Container(
                    width: 56.w, height: 56.h,
                    decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]),
                    child: Center(child: Container(width: 22.w, height: 22.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6.r)), child: Icon(Icons.add, color: AppColors.primaryColor, size: 18.sp))),
                  ),
                ),
                IconButton(icon: Icon(Icons.inventory_2_outlined, size: 28.sp, color: AppColors.greyColor), onPressed: () => context.push(AppRoutes.archivedScreen)),
                IconButton(icon: Icon(Icons.settings_outlined, size: 28.sp, color: AppColors.greyColor), onPressed: () => context.push(AppRoutes.settingsScreen)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroceryItemWidget extends StatelessWidget {
  final String name;
  final int quantity;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const GroceryItemWidget({
    super.key,
    required this.name,
    required this.quantity,
    required this.isChecked,
    required this.onChanged,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24.w, height: 24.h,
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
              side: const BorderSide(color: Color(0xFFE8ECF4), width: 1.5),
              activeColor: AppColors.primaryColor,
            ),
          ),
          WidthSpace(12),

          Expanded(
            child: Text(
              name,
              style: AppStyles.black16w500Style.copyWith(
                decoration: isChecked ? TextDecoration.lineThrough : null,
                color: isChecked ? AppColors.greyColor : AppColors.blackColor,
              ),
            ),
          ),

          if (!isChecked) ...[
            Row(
              children: [
                _QuantityButton(icon: Icons.remove, onTap: onDecrement),
                SizedBox(width: 8.w),
                Text('$quantity', style: AppStyles.black16w500Style),
                SizedBox(width: 8.w),
                _QuantityButton(icon: Icons.add, onTap: onIncrement),
              ],
            ),
            WidthSpace(12),
          ],

          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 20.sp,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Icon(icon, size: 16.sp, color: AppColors.blackColor),
      ),
    );
  }
}