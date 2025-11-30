import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import 'package:colist_proj/routes/app_routs.dart';
import 'package:colist_proj/utils/constants/app_assets.dart';
import 'package:colist_proj/utils/constants/app_text_styles.dart';
import 'package:colist_proj/utils/constants/app_colors.dart';
import '../widgets/list_card_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,

        leading: IconButton(
          icon: SvgPicture.asset(AppAssets.personn),
          onPressed: () {
            context.push(AppRoutes.profileScreen);
          },
        ),

        centerTitle: true,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search lists...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: AppStyles.black18BoldStyle,
          onChanged: (val) {
            setState(() {
              _searchQuery = val.toLowerCase();
            });
          },
        )
            : null,


        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = "";
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isSearching)
              Text(
                "Your Lists",
                style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 20),
              ),

            SizedBox(height: 16.h),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('lists')
                    .where('members', arrayContains: user?.uid)
                    .orderBy('updatedAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var docs = snapshot.data?.docs ?? [];
                  if (_searchQuery.isNotEmpty) {
                    docs = docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final name = (data['name'] ?? '').toString().toLowerCase();
                      return name.contains(_searchQuery);
                    }).toList();
                  }

                  if (docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.format_list_bulleted, size: 60.sp, color: Colors.grey[300]),
                          SizedBox(height: 10.h),
                          Text(
                            _searchQuery.isEmpty ? 'No lists yet. Create one!' : 'No results found',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final Timestamp? timeStamp = data['updatedAt'] ?? data['createdAt'];
                      final String timeAgo = _formatTimeAgo(timeStamp);
                      final List membersList = (data['members'] is List) ? data['members'] : [];
                      final int membersCount = membersList.length;

                      return Dismissible(
                        key: Key(doc.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.w),
                          child: const Icon(Icons.delete_forever, color: Colors.white, size: 30),
                        ),
                        confirmDismiss: (direction) async {
                          if (data['ownerId'] != user?.uid) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Only owner can delete")));
                            return false;
                          }
                          return true;
                        },
                        onDismissed: (direction) {
                          FirebaseFirestore.instance.collection('lists').doc(doc.id).delete();
                        },
                        child: GestureDetector(
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
                            lastUpdated: 'Updated $timeAgo',
                            onDelete: () {},
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.home, size: 28.sp, color: AppColors.primaryColor), onPressed: () {}),
                IconButton(icon: Icon(Icons.notifications_outlined, size: 28.sp, color: AppColors.greyColor), onPressed: () => context.push(AppRoutes.notificationScreen)),
                InkWell(
                  onTap: () => context.push(AppRoutes.addToListScreen),
                  child: Container(
                    width: 56.w, height: 56.h,
                    decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]),
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

  String _formatTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final diff = DateTime.now().difference(timestamp.toDate());
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}