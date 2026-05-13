// --------------- IMPORTS ---------------
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/models/transaction.dart';
import 'package:food_sharing/provider/transactions_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// ---------------------------------------------

class PostDetailPage extends StatelessWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.watch<UsersProvider>().currentUser?.userId; // post object
    final transactionProvider = context.watch<TransactionsProvider>(); // constructor
    final selectedDietary = post.tags
        .where((tag) => FoodTags.dietaryTags.contains(tag))
        .toList()
        ..sort((a, b) => FoodTags.dietaryTags.indexOf(a).compareTo(FoodTags.dietaryTags.indexOf(b)));
    final selectedCategories = post.tags
        .where((tag) => FoodTags.categoryTags.contains(tag))
        .toList()
        ..sort((a, b) => FoodTags.categoryTags.indexOf(a).compareTo(FoodTags.categoryTags.indexOf(b)));
    
    // UI DESIGN ---------------
    return Scaffold(
      backgroundColor: BrandColors.white,
      appBar: AppBar(
        backgroundColor: BrandColors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(post.title, style: TextStyleTheme.subtitle_bold,),
      ),
    // ------------------------------

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image container ---------------
            Container(
              width: double.infinity,
              height: 350,
              color: Colors.grey[200],
              // fetch the image url ---------------
              // NOT WORKING YET!!
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
                    // ---------------------------------------------
            ),
            // ---------------------------------------------------------------------------

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
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
                  const Divider(height: 40),

                  // description ---------------------------------------------
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // dietary tags ---------------------------------------------
                  if (selectedDietary.isNotEmpty) ...[
                    const Text(
                      "Dietary Tags",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedDietary
                          .map((tag) => _buildTagChip(tag, BrandColors.green))
                          .toList(),
                    ),
                    const SizedBox(height: 25),
                  ],

                  // food categories ---------------------------------------------
                  if (selectedCategories.isNotEmpty) ...[
                    const Text(
                      "Food Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedCategories
                          .map((cat) => _buildTagChip(cat, Colors.blue))
                          .toList(),
                    ),
                    const SizedBox(height: 40),
                  ],

                  _buildActionButton(
                    context,
                    currentUserId,
                    transactionProvider,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String? currentUserId,
    TransactionsProvider provider,
  ) {
    // if user is the owner of the post ------------------------------
    if (post.userId == currentUserId) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(children: [],)
      );
    }

    // post status ---------------------------------------------
    // transaction not working yet
    if (post.status == PostStatus.reserved) {
      return _disabledButton("Reserved", Colors.orange);
    }
    if (post.status == PostStatus.completed) {
      return _disabledButton("Completed", const Color.fromARGB(255, 18, 167, 68));
    }

    // request item ---------------------------------------------
    return PrimaryButton(
      onPressed: () => _handleRequest(context, currentUserId),
      text: 'Request Item',
      style: 'green',
      size: const Size(double.infinity, 55),
    );
  }

  Widget _disabledButton(String label, Color color) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
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
        content: Text('Send a request to the owner for "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
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
        ],
      ),
    );

    if (confirmed == true) {
      // Logic to create transaction document
      await context.read<TransactionsProvider>().addTransaction(
        PostTransaction(
          postId: post.id!,
          giverId: post.userId!,
          receiverId: currentUserId,
          status: TransactionStatus.pending,
          createdAt: DateTime.now(),
        ),
        post.userId!,
        post.id!,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Request sent! Status will update to RESERVED once the owner accepts.',
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
