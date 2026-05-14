import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/screen/component/profile.dart';
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

              GestureDetector(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => PostDetailPage(post: post),
                  ));
              },  
              child:Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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

              
              ],))


            ]        
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


}

  Widget _imagePlaceholder() => Container(
        color: const Color(0xFFEEEEEE),
        child: const Center(
          child: Icon(Icons.image_outlined, color: Colors.grey, size: 30),
        ),
      );

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
              return;
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
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const PostFeed({
    super.key,
    required this.stream,
    required this.type,
    this.header,
    this.shrinkWrap = false,
    this.physics,
  });


  @override
  Widget build(BuildContext context) {
  String  emptyText = "Hmm.. it's empty here.";
    return StreamBuilder(
      stream: stream,
      
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: BrandColors.green));
        }

        final posts = snapshot.data!.docs;
        if (posts.isEmpty) {
          return Column(
            children: [
              if (header != null) header!,
              const SizedBox(height: 20),
              Center(
                  child: Text(
                    emptyText,
                    style: TextStyleTheme.body,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
        }

        return ListView.separated(
          shrinkWrap: shrinkWrap,
          physics: physics,
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

class RequestFeed extends StatelessWidget {
  final Stream<List<QueryDocumentSnapshot>> stream;
  final Widget? header;
  final bool shrinkWrap;
  final User user;
  final ScrollPhysics? physics;

  const RequestFeed({
    super.key,
    required this.stream,
    required this.user,
    this.header,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    const emptyText = "Hmm.. it's empty here.";
    final usersProvider = context.read<UsersProvider>();

    return StreamBuilder<List<QueryDocumentSnapshot>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: BrandColors.green),
          );
        }

        final requests = snapshot.data!;

        if (requests.isEmpty) {
          return Column(
            children: [
              if (header != null) header!,
              const SizedBox(height: 20),
              Center(
                child: Text(
                  emptyText,
                  style: TextStyleTheme.body,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }

        return ListView.separated(
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: requests.length + (header != null ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (header != null && index == 0) return header!;

            final requestIndex = header != null ? index - 1 : index;

            final data = requests[requestIndex].data() as Map<String, dynamic>;
            final post = Post.fromJson(data);

            return FutureBuilder<User?>(
              future: post.userId != null
                  ? usersProvider.getUserById(post.userId!)
                  : Future.value(null),
              builder: (context, userSnapshot) {
                final user = userSnapshot.data;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailPage(post: post),
                      ),
                    );
                  },
                  child: Card(
                    color: BrandColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Section
                          SizedBox(
                            width: 90,
                            height: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: (post.foodPicture != null && post.foodPicture!.isNotEmpty)
                                  ? Image.memory(
                                      base64Decode(post.foodPicture!),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _imagePlaceholder(),
                                    )
                                  : _imagePlaceholder(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title,
                                  style: TextStyleTheme.subtitle_bold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Posted by: @${user?.userName ?? 'loading...'}",
                                  style: TextStyleTheme.body.copyWith(color: Colors.grey.shade600, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                
                                // --- ITEM DESCRIPTION ---
                                Text(
                                  post.description,
                                  style: TextStyleTheme.body.copyWith(color: Colors.grey.shade700, fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),

                                // --- DYNAMIC STATUS TAGS ---
                              ],
                            ),
                            this.user.userId == usersProvider.currentUser?.userId ?
                            _buildRequestStatusTag(data, this.user.userId ?? "", context): const SizedBox.shrink(),]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, 
            ); 
          },  
        );
      }, 
    ); 
  }

  // Included just in case it is defined elsewhere in your file
  Widget _imagePlaceholder() {
    return Container(color: Colors.grey.shade300, child: const Icon(Icons.fastfood, color: Colors.white));
  }

  Widget _buildRequestStatusTag(Map<String, dynamic> data, String currentUid, BuildContext context) {
  final bool isRequestedByMe = data['requesterIds'].contains(currentUid); 
  final bool isReservedForMe = data['reservedForId'] == currentUid;

  String tagLabel = "";
  Color backgroundColor = Colors.transparent;
  Color textColor = Colors.transparent;

  if (isRequestedByMe) {
    tagLabel = "Pending Request";
    textColor = BrandColors.green;
    backgroundColor = BrandColors.green; 
  } else if (isReservedForMe) {
    tagLabel = "Reserved For you";
    textColor = BrandColors.yellow;
    backgroundColor = BrandColors.yellow;
  } else {
    return const SizedBox.shrink();
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: backgroundColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      tagLabel,
      maxLines: 2,
      style: TextStyleTheme.body.copyWith(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
}
