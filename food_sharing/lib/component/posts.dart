import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/profile.dart';
import 'package:food_sharing/screen/profile_page.dart';

import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/models/user.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/subpages/post_detail.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final FeedType type;
  const PostCard({required this.post, required this.type});

  @override
  Widget build(BuildContext context) {
    return 
     Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
                    if (type == FeedType.pantry) ...[
                PostCardHeader(userId: post.userId),
                const SizedBox(height: 8),
              ],

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1.1,
                  child: (post.foodPicture!= null && post.foodPicture!.isNotEmpty)
                      ? Image.memory(
                          base64Decode(post.foodPicture!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _imagePlaceholder(),
                        )
                      : _imagePlaceholder(),
                ),
              ),
              Padding(padding: EdgeInsets.all(6), child:Text(
                post.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              Padding(padding: EdgeInsets.all(6), child:Text(
                'Expires: ${DateFormat('MM/dd').format(post.expiration)}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              )),

              Padding(
                padding: const EdgeInsets.all(6),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 10,
                  children: post.tags.map((tag) => _smallTag(tag)).toList(),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: _PostActionButton(post: post),
                ),
              )   
         ],
          ),
        ),
      );
  }

  Widget _smallTag(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: BrandColors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: BrandColors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
        color: const Color(0xFFEEEEEE),
        child: const Center(
          child: Icon(Icons.image_outlined, color: Colors.grey, size: 30),
        ),
      );
}

class _PostActionButton extends StatelessWidget {
  final Post post;

  const _PostActionButton({required this.post});

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.read<UsersProvider>();

    bool posterIsUser = post.userId == usersProvider.currentUser?.userId!;
    String style;
    String buttonText;

    if(posterIsUser){
      buttonText = "Edit";
      style = "yellow";
    }else{
      if(post.status==PostStatus.available){
        buttonText = "Request";
        style = "green";
      }else if(post.status==PostStatus.reserved){
        buttonText = "Reserved";
        style = "gray";
      }else{
        buttonText = "Unavailable";
        style = "gray";
      }
    }

    return PrimaryButton(
      text: buttonText,
      style: style,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostDetailPage(post: post),
          ),
        );
      },
    );
  }
}

class PostCardHeader extends StatelessWidget {
  final String? userId;
  const PostCardHeader({required this.userId});

  @override
  Widget build(BuildContext context) {

    final usersProvider = context.read<UsersProvider>();

    return FutureBuilder<User?>(
      future: userId != null
          ? usersProvider.getUserById(userId!)
          : Future.value(null),
      builder: (context, snapshot) {
        final user = snapshot.data;
      return GestureDetector(
                onTap: () {
          if (user == null) return;

          if (usersProvider.currentUser != null &&
              user.userId == usersProvider.currentUser?.userId) {
            return; // don't navigate to self
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(user: user, showAppBar: true,), // or UserProfilePage(userId: user.userId)
            ),
          );
        },
        child: Row(
          children: [
            ProfilePicture(user: user, size: 56,),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                user != null ? '@${user.userName}' : '...',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        );
      },
    );
  }
}

enum FeedType{
  profile,
  pantry
}

class PostFeed extends StatelessWidget {
  final Stream stream;
  final FeedType type;
  final Widget? header;

  const PostFeed({
    super.key,
    required this.stream,
    required this.type,
    this.header,
  });


  @override
  Widget build(BuildContext context) {
  String emptyText;

    if(type==FeedType.profile){
       emptyText = "User has no posts yet.";

    }else if (type==FeedType.pantry){
       emptyText = "No items in the pantry yet.";
    }else {
      emptyText = "No items in the pantry yet.";
    }

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!.docs;
        if (posts.isEmpty) {
          return Column(
            children: [
              if (header != null) header!,
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Text(
                    emptyText,
                    style: TextStyleTheme.body,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        }

        return ListView.separated(
          itemCount: posts.length + (header != null ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (header != null && index == 0) return header!;

            final postIndex = header != null ? index - 1 : index;

            return PostCard(
              post: Post.fromJson(
                posts[postIndex].data() as Map<String, dynamic>,
              ),
              type:type
            );
          },
        );
      },
    );
  }
}