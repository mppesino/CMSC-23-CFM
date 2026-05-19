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

    return DefaultTabController(
      initialIndex: 1,
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: BrandColors.cream,
        appBar: AppBar(
          backgroundColor: BrandColors.cream,
          elevation: 0,
          toolbarHeight: 10, 
          bottom: TabBar(
            labelColor: BrandColors.darkGreen, // Adjust based on your theme
            unselectedLabelColor: BrandColors.gray,
            indicatorColor: BrandColors.darkGreen, // Customize indicator color
            labelStyle: TextStyleTheme.subtitle_bold_sm, 
            tabs: const [
              Tab(text: "Discovery",),
              Tab(text: "For You"),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TabBarView(
              children: [
               
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: PostFeed(
                    stream: postsProvider.getPostsByInterests([]), 
                    type: FeedType.pantry,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: PostFeed(
                    stream: postsProvider.getPostsByInterests(userInterests), 
                    type: FeedType.pantry,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}