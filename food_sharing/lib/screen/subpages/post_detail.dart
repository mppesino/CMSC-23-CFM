import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/models/transaction.dart';
import 'package:food_sharing/models/user.dart';
import 'package:food_sharing/provider/transactions_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:food_sharing/screen/component/buttons.dart';
import 'package:food_sharing/screen/component/posts.dart';

import 'package:food_sharing/utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  final _commentController = TextEditingController();

  PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionsProvider>(); // constructor
    final usersProvider = context.watch<UsersProvider>();

    Color tagColor = BrandColors.gray;
    if(post.status == PostStatus.Available){
      tagColor = BrandColors.green;
    } else if (post.status == PostStatus.Reserved){
      tagColor = BrandColors.yellow;
    } else if (post.status == PostStatus.Unavailable){
      tagColor = BrandColors.gray;
    } 

    return Scaffold(
      backgroundColor: BrandColors.white,
      appBar: AppBar(
        backgroundColor: BrandColors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(post.title, style: TextStyleTheme.subtitle_bold,),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              width: double.infinity,
              height: 350,
              color: Colors.grey[200],
              child: post.foodPicture != null && post.foodPicture!.isNotEmpty
                  ? Image.memory(
                      base64Decode(post.foodPicture!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 100, color: Colors.grey),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  PostCardHeader(userId: post.userId,),  
                  const SizedBox(height: 12),
                  if (post.description.trim().isNotEmpty) ...[
                    Text(
                      post.description,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],


                if (post.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: post.tags
                        .map((cat) => _buildTagChip(cat, Colors.blue))
                        .toList(),
                  ),
                  const SizedBox(height: 25),
                  ],


                  const Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTagChip(post.status.name, tagColor),
                  const SizedBox(height: 25),


                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Expires: ${DateFormat('MMMM dd, yyyy').format(post.expiration)}",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 25),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRequest(
    BuildContext context,
    String? currentUserId,
  ) async {
    if (currentUserId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Item'),
        content: Text('Send a request for "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: BrandColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: BrandColors.green)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await context.read<TransactionsProvider>().addTransaction(
        PostTransaction(
          postId: post.id!,
          giverId: post.userId!,
          requesterId: currentUserId,
          status: TransactionStatus.pending,
          comment: _commentController.text,
          createdAt: DateTime.now(),
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Request sent! Status will update to Reserved once accepted.',
            ),
            backgroundColor: BrandColors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}

Widget _buildTagChip(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontWeight: FontWeight.w600),
    ),
  );
}
