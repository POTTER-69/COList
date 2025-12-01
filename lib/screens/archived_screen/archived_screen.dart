import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_text_styles.dart';
import '../../widgets/spacing_widgets.dart';
import 'archiverd_list_card.dart';

class ArchivedScreen extends StatefulWidget {
  const ArchivedScreen({super.key});

  @override
  State<ArchivedScreen> createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text('Archived Lists', style: AppStyles.black18BoldStyle),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lists')
            .where('archived', isEqualTo: true)
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No archived lists",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: docs.length,
            separatorBuilder: (_, __) => HeightSpace(12),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final Timestamp? timestamp = data['updatedAt'];
              final String date = timestamp != null
                  ? "Archived on ${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}"
                  : "Archived";

              return ArchivedListCard(
                date: date,
                listName: data['name'] ?? '',
                itemCount: data['itemsCount'] ?? 0,
                image: Colors.grey.shade200,
                onMoreTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return SizedBox(
                        height: 170,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.unarchive_outlined),
                              title: const Text("Unarchive"),
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('lists')
                                    .doc(doc.id)
                                    .update({"archived": false});

                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete_outline),
                              title: const Text("Delete"),
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('lists')
                                    .doc(doc.id)
                                    .delete();

                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
