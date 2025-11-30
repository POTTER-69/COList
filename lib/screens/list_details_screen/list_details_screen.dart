import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  const ListDetailsScreen({super.key, required this.listId, required this.listName});

  @override
  State<ListDetailsScreen> createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {

  @override
  void initState() {
    super.initState();
    _joinList();
  }

  Future<void> _joinList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('lists').doc(widget.listId);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final List members = data?['members'] ?? [];

        if (!members.contains(user.uid)) {
          await docRef.update({
            'members': FieldValue.arrayUnion([user.uid])
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("You have joined this list! 🎉")),
            );
          }
        }
      }
    }
  }

  void _showAddItemModal(BuildContext context) {
    final TextEditingController itemController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, left: 16.w, right: 16.w, top: 16.h),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Add New Item", style: AppStyles.black18BoldStyle),
            SizedBox(height: 16.h),
            TextField(
              controller: itemController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Item Name (e.g., Milk)",
                filled: true,
                fillColor: const Color(0xFFF7F8F9),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity, height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                onPressed: () async {
                  if (itemController.text.isNotEmpty) {
                    final newItem = {'name': itemController.text.trim(), 'quantity': 1, 'isChecked': false};
                    await FirebaseFirestore.instance.collection('lists').doc(widget.listId).update({
                      'items': FieldValue.arrayUnion([newItem]),
                      'updatedAt': FieldValue.serverTimestamp(),
                    });
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text("Add", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20.h),
          ]),
        );
      },
    );
  }

  Future<void> _updateItem(List<dynamic> currentItems) async {
    await FirebaseFirestore.instance.collection('lists').doc(widget.listId).update({
      'items': currentItems,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor, elevation: 0, centerTitle: true,
        title: Text(widget.listName, style: AppStyles.black18BoldStyle),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor), onPressed: () => context.go(AppRoutes.homeScreen)),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: AppColors.greyColor),
            onPressed: () => context.push(AppRoutes.inviteCollaboratorsScreen, extra: {'id': widget.listId, 'name': widget.listName}),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('lists').doc(widget.listId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("List not found or access denied"));
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> items = data['items'] ?? [];

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_outlined, size: 60.sp, color: Colors.grey[300]),
                  HeightSpace(16),
                  Text("No items yet", style: TextStyle(color: Colors.grey[400], fontSize: 16.sp)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map<String, dynamic>;

              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.only(right: 20.w),
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8.r)),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (direction) {
                  final deletedItem = items[index];
                  items.removeAt(index);
                  _updateItem(items);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${deletedItem['name']} deleted'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          items.insert(index, deletedItem);
                          _updateItem(items);
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.r),
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
                          value: item['isChecked'] ?? false,
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                          side: const BorderSide(color: Color(0xFFE8ECF4), width: 1.5),
                          onChanged: (val) {
                            items[index]['isChecked'] = val;
                            _updateItem(items);
                          },
                        ),
                      ),
                      WidthSpace(12),
                      Expanded(
                        child: Text(
                          item['name'],
                          style: AppStyles.black16w500Style.copyWith(
                            decoration: (item['isChecked'] ?? false) ? TextDecoration.lineThrough : null,
                            color: (item['isChecked'] ?? false) ? AppColors.greyColor : AppColors.blackColor,
                          ),
                        ),
                      ),
                      if (!(item['isChecked'] ?? false)) ...[
                        _QuantityButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (item['quantity'] > 1) {
                              items[index]['quantity']--;
                              _updateItem(items);
                            }
                          },
                        ),
                        SizedBox(width: 8.w),
                        Text('${item['quantity']}', style: AppStyles.black16w500Style),
                        SizedBox(width: 8.w),
                        _QuantityButton(
                          icon: Icons.add,
                          onTap: () {
                            items[index]['quantity']++;
                            _updateItem(items);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        width: 56.w, height: 56.h,
        decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(16.r), boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]),
        child: IconButton(icon: Icon(Icons.add, color: Colors.white, size: 28.sp), onPressed: () => _showAddItemModal(context)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
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
        decoration: BoxDecoration(color: const Color(0xFFF7F8F9), borderRadius: BorderRadius.circular(4.r)),
        child: Icon(icon, size: 16.sp, color: AppColors.blackColor),
      ),
    );
  }
}