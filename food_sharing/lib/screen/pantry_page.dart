import 'package:flutter/material.dart';
import 'package:food_sharing/screen/component/posts.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';

class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postsProvider = context.watch<PostsProvider>();
    final authProvider = context.watch<AppAuthProvider>();

    final userInterests = authProvider.customUserData?.tags ?? [];

    return Scaffold(
      backgroundColor: BrandColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  userInterests.isEmpty ? "All Items" : "Items for Your Interests",
                  style: TextStyleTheme.subtitle_bold,
                ),
              ),
              Expanded(
                child: PostFeed(
                  stream: postsProvider.getPostsByInterests(userInterests), 
                  type: FeedType.pantry,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}