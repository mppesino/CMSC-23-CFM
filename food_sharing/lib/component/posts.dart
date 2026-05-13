import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/component/profile.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/models/user.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/subpages/post_detail.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              PostCardHeader(userId: post.userId),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1.1,
                  child: (post.foodPicture!= null && post.foodPicture!.isNotEmpty)
                      ? Image.network(
                          post.foodPicture!,
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

              Padding(padding: EdgeInsets.all(6), child:_StatusBadge(status: post.status)),
            ],
          ),
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

class _StatusBadge extends StatelessWidget {
  final PostStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = BrandColors.green;
    if (status == PostStatus.reserved) color = Colors.orange;
    if (status == PostStatus.completed) color = Colors.grey;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.name.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: color, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class PostCardHeader extends StatelessWidget {
  final String? userId;
  const PostCardHeader({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: userId != null
          ? context.read<UsersProvider>().getUserById(userId!)
          : Future.value(null),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return Row(
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
        );
      },
    );
  }
}

class PostFeed extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final String emptyText;

  const PostFeed({
    super.key,
    required this.stream,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: BrandColors.green,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              emptyText,
              style: TextStyleTheme.body,
            ),
          );
        }

        final posts = snapshot.data!.docs
            .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return ListView.separated(
          itemCount: posts.length,
          padding: const EdgeInsets.all(2),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return PostCard(post: posts[index]);
          },
        );
      },
    );
  }
}