import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/posts.dart';
import 'package:food_sharing/component/profile.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UsersProvider>().currentUser;
    final postsProvider = context.watch<PostsProvider>();

    return Scaffold(
      body: Column(
        children: [
          SectionCard(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            color: BrandColors.white,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ProfilePicture(
                        user: currentUser,
                      ),
                      Text(
                        "@${currentUser?.userName ?? "user"}",
                        style: TextStyleTheme.body,
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                "${currentUser?.firstName} ${currentUser?.lastName}",
                                style: TextStyleTheme.subtitle_bold,
                              ),
                            ),
                            
                          ],
                        ),

                        Text(
                          currentUser?.bio ?? "This is my bio!",
                          style: TextStyleTheme.body,
                        ),

                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: (currentUser?.tags ?? [])
                              .map(_buildTags)
                              .toList(),
                        ),


                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          Expanded(child: PostFeed(stream: postsProvider.userPost(currentUser?.userId ?? ""), emptyText: "User doesn't have any posts."))


        ],
      ),
    );
  }

  Widget _buildTags(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),

      backgroundColor: BrandColors.green,

      shape: const StadiumBorder(),

      side: BorderSide.none,

      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
    );
  }
}
