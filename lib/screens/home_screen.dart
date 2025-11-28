import 'package:colist_proj/routes/app_routs.dart';
import 'package:colist_proj/utils/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../utils/constants/app_text_styles.dart';
import '../widgets/list_card_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: SvgPicture.asset(AppAssets.personn),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(AppAssets.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Lists",
              style: AppStyles.primaryHeadLinesStyle.copyWith(fontSize: 20),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('lists')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No lists found.'));
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

                      final List membersList = data['members'] is List ? data['members'] : [];
                      final int membersCount = membersList.isEmpty ? 1 : membersList.length;

                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(
                            AppRoutes.ListDetailsScreen,
                            extra: {
                              'id': doc.id,
                              'name': data['name'],
                            },
                          );
                        },
                        child: ListCard(
                          imagePath: data['imageUrl'] ?? '',
                          title: data['name'] ?? '',

                          members: '$membersCount members',

                          lastUpdated: 'Last updated $timeAgo',

                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Delete List?'),
                                content: const Text(
                                    'Are you sure you want to delete this list?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection('lists')
                                  .doc(doc.id)
                                  .delete();
                            }
                          },
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
    );
  }

  String _formatTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';

    final DateTime date = timestamp.toDate();
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(date);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()}y ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else if (diff.inDays > 7) {
      return '${(diff.inDays / 7).floor()}w ago';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}