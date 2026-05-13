// --------------- IMPORTS ---------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/models/user.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/subpages/add_post.dart';
import 'package:food_sharing/screen/subpages/post_detail.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// ------------------------------------------------------------

// --------------- PANTRY PAGE ---------------
class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.cream,
      floatingActionButton: FloatingActionButton(
        backgroundColor: BrandColors.green,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddPostPage()),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text('ElBi Pantry!', style: TextStyleTheme.titleXs),
              const SizedBox(height: 16),
              const Expanded(child: _PostsFeed()),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostsFeed extends StatelessWidget {
  const _PostsFeed();

  @override
  Widget build(BuildContext context) {
    final postsProvider = context.watch<PostsProvider>();

    return StreamBuilder<QuerySnapshot>(
      stream: postsProvider.post,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: BrandColors.green));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No items in the pantry yet.',
                  style: TextStyleTheme.body));
        }

        final posts = snapshot.data!.docs
            .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return GridView.builder(
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.55,
          ),
          itemBuilder: (context, index) => _PostCard(post: posts[index]),
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;
  const _PostCard({required this.post});

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
            children: [
              _PostCardHeader(userId: post.userId),
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
              const SizedBox(height: 8),
              Text(
                post.title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Expires: ${DateFormat('MM/dd').format(post.expiration)}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),

              const SizedBox(height: 6),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...post.tags.map((tag) => _smallTag(tag)),
                  ],
                ),
              ),

              const Spacer(),
              _StatusBadge(status: post.status),
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
          fontSize: 8,
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
            color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _PostCardHeader extends StatelessWidget {
  final String? userId;
  const _PostCardHeader({required this.userId});

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
            CircleAvatar(
              radius: 10,
              backgroundColor: BrandColors.gray,
              backgroundImage: user?.profilePicture != null
                  ? NetworkImage(user!.profilePicture!)
                  : null,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                user != null ? '${user.firstName}' : '...',
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}