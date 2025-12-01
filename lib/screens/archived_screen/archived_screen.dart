import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import 'package:colist_proj/widgets/list_card_widgets.dart';
import 'package:colist_proj/routes/app_routs.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({super.key});

  void _showOptions(BuildContext context, String listId, String listName) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(listName, style: AppStyles.black18BoldStyle),
              SizedBox(height: 16.h),

              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
                  child: const Icon(Icons.unarchive_outlined, color: Colors.green),
                ),
                title: const Text("Unarchive List"),
                subtitle: const Text("Move back to home screen"),
                onTap: () async {
                  Navigator.pop(context);
                  await FirebaseFirestore.instance.collection('lists').doc(listId).update({
                    'archived': false,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List Restored to Home")));
                },
              ),

              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
                  child: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                ),
                title: const Text("Delete Permanently"),
                subtitle: const Text("This action cannot be undone"),
                onTap: () async {
                  Navigator.pop(context);
                  await FirebaseFirestore.instance.collection('lists').doc(listId).delete();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List Deleted Permanently")));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Archived Lists", style: AppStyles.black18BoldStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('lists')
              .where('members', arrayContains: user?.uid)
              .where('archived', isEqualTo: true)
              .orderBy('updatedAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 60.sp, color: Colors.grey[300]),
                    SizedBox(height: 10.h),
                    Text('No archived lists', style: TextStyle(color: Colors.grey[400])),
                  ],
                ),
              );
            }

            final lists = snapshot.data!.docs;

            return GridView.builder(
              itemCount: lists.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final doc = lists[index];
                final data = doc.data() as Map<String, dynamic>;

                final Timestamp? timeStamp = data['updatedAt'] ?? data['createdAt'];
                final String timeAgo = _formatTimeAgo(timeStamp);
                final List membersList = (data['members'] is List) ? data['members'] : [];
                final int membersCount = membersList.length;

                return GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.listDetailsScreen,
                      extra: {'id': doc.id, 'name': data['name']},
                    );
                  },
                  child: ListCard(
                    imagePath: data['imageUrl'] ?? '',
                    title: data['name'] ?? '',
                    members: '$membersCount members',
                    lastUpdated: 'Archived $timeAgo',
                    onDelete: () {
                      _showOptions(context, doc.id, data['name']);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final DateTime date = timestamp.toDate();
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(date);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 7) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}