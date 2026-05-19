import 'package:flutter/material.dart';
import 'package:food_sharing/screen/component/posts.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'package:food_sharing/models/post.dart';

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

                //TAB 1: SHOW ALL AVAILABLE ITEMS, SORTED BY DISTANCE:
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: StreamBuilder<List<Post>>(
                    stream: postsProvider.getNearbyPosts(
                      currentUser: authProvider.customUserData!, 
                      interests: [],
                      filterByInterests: false,
                  ), 
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                    final posts = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: posts.length, 
                      itemBuilder: (context, index) => PostCard(post: posts[index], type: FeedType.pantry,));
                  }),
                ),


                //TAB 2: SHOW ITEMS MATCHING BOTH PROXIMITY AND DIETARY TAGS (FOR YOU):
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: StreamBuilder<List<Post>>(
                    stream: postsProvider.getNearbyPosts(
                      currentUser: authProvider.customUserData!, 
                      interests: userInterests,
                      filterByInterests: true,
                  ), 
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                    final posts = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: posts.length, 
                      itemBuilder: (context, index) => PostCard(post: posts[index], type: FeedType.pantry,));
                  }),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}