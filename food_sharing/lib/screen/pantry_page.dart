// --------------- IMPORTS ---------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/component/posts.dart';

import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';

// ------------------------------------------------------------

// --------------- PANTRY PAGE ---------------
class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  @override
  Widget build(BuildContext context) {
  final postsProvider = context.watch<PostsProvider>();

    return Scaffold(
      backgroundColor: BrandColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Expanded(child: PostFeed(stream: postsProvider.getAllPosts(), type: FeedType.pantry,)),
            ],
          ),
        ),
      ),
    );
  }
}
