import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/component/profile.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:food_sharing/screen/component/buttons.dart';
import 'package:food_sharing/screen/component/posts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  final _commentController = TextEditingController();

  PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final postsProvider = context.watch<PostsProvider>();
    final usersProvider = context.watch<UsersProvider>();

    Color tagColor = BrandColors.gray;
    if(post.status == PostStatus.available){
      tagColor = BrandColors.green;
    } else if (post.status == PostStatus.reserved){
      tagColor = BrandColors.yellow;
    } else if (post.status == PostStatus.completed){
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
                  _buildTagChip(post.status == PostStatus.available ? "Available" 
                                : post.status == PostStatus.reserved ? "Reserved"
                                : post.status == PostStatus.completed ? "Completed" : "Error", tagColor),
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

                post.userId == usersProvider.currentUser?.userId ?
                _buildGiverView(context, post)
                :_buildRequesterView(context, post, usersProvider.currentUser?.userId ?? "")

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildGiverView(BuildContext context, Post post) {
  final requesterIds = post.requesterIds ?? [];

  if (requesterIds.isEmpty) {
    return const Center(child: Text("No requests yet"));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Requests",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Optional: Show the count
            Text(
              "${requesterIds.length}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),

      SizedBox(height: 10,),

      // --- THE LIST ---
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: requesterIds.length,
        itemBuilder: (context, index) {
          final requesterId = requesterIds[index];

          return FutureBuilder(
            future: context.read<UsersProvider>().getUserById(requesterId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const ListTile(title: Text("Loading..."));
              }

              final user = snapshot.data!;

              return Card(
                color: BrandColors.white,
                child: ListTile(
                  leading: SizedBox(
                    width: 40, 
                    height: 40, 
                    child: ProfilePicture(user: user),
                  ),
                  title: Text("@${user.userName}"),
                  subtitle: Text(
                    (post.requesterAppeals?[requesterId]?.trim().isNotEmpty ?? false)
                        ? post.requesterAppeals![requesterId]!
                        : "Requested this item",
                  ),
                  trailing: PrimaryButton(icon: Icons.check, onPressed: () {print("Request accepted!");}, style: "green", size: Size(50,50))
                ),
              );
            },
          );
        },
      ),
    ],
  );
}

  Widget _buildRequesterView(BuildContext context, Post post, String currentUid){

    bool alreadyRequested = (post.requesterIds ?? []).contains(currentUid);
  
    return(
      Column(children: [
       !alreadyRequested ? TextField(
          controller: _commentController,
          maxLines: 1,
          cursorColor: BrandColors.darkGreen,
          decoration: InputDecoration(
            hintText: 'Why do you need this item?',
            filled: true,
            fillColor: Colors.grey.shade100,
            label: Text("Appeal"),
            labelStyle: TextStyle(color: BrandColors.darkGreen),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ) : const SizedBox.shrink(),
        const SizedBox(height: 15),
        Center(child: _buildRequestButton(context, post, currentUid, alreadyRequested))
      ],)
    );
  }

Widget _buildRequestButton(BuildContext context, Post post, String currentUid,  bool alreadyRequested) {


  final bool disabled =
      post.status == PostStatus.reserved || alreadyRequested;

  return PrimaryButton(
    text:  !disabled? "Request Item" : alreadyRequested? "Requested" : "Reserved",
    onPressed: disabled ? null : () {
      _handleRequest(context, currentUid, post);
    },
    style: disabled ? "gray" : "green",
  );
}

Future<void> _handleRequest(
    BuildContext context,
    String? currentUid,
    Post post
  ) async {
    if (currentUid == null) return;

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
      await context.read<PostsProvider>().editPost(
        post.id!,
        {
        'requesterIds': FieldValue.arrayUnion([currentUid]),
        'requesterAppeals.$currentUid': _commentController.text,
        }
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
