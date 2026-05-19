// PANTRY_PAGE.DART

// IMPORTS ---------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/screen/component/posts.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';
// ---------------------------------------------------------------------------------------

// PANTRY PAGE ---------------------------------------------------------------------------------------
class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // connects the page to the data feed for posts and user info
    final postsProvider = context.watch<PostsProvider>();
    final authProvider = context.watch<AppAuthProvider>();

    // gets the user interests (dietary and category)
    final userInterests = authProvider.customUserData?.tags ?? [];

    // tabs in the panry page
    return DefaultTabController(
      initialIndex: 1, // starts on the second tab
      length: 2, // no of tabs
      child: Scaffold(
        backgroundColor: BrandColors.cream,
        appBar: AppBar(
          backgroundColor: BrandColors.cream,
          elevation: 0,
          toolbarHeight: 10, 
          // allows the user to switch between different views
          bottom: TabBar(
            labelColor: BrandColors.darkGreen,
            unselectedLabelColor: BrandColors.gray,
            indicatorColor: BrandColors.darkGreen, 
            labelStyle: TextStyleTheme.subtitle_bold_sm, 
            tabs: const [
              Tab(text: "Discovery",), // all posts
              Tab(text: "For You"), // posts filtered to user's interest
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            // displays different content per tab
            child: TabBarView(
              children: [
                // DISCOVERY
                // shows all posts in the database
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
                // FOR YOU
                // sends the user's interest and filters it from the database
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
// ---------------------------------------------------------------------------------------
