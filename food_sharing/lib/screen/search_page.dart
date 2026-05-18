import 'dart:convert';
import 'package:food_sharing/screen/subpages/post_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:food_sharing/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}         


class _SearchPageState extends State<SearchPage> {
  // controller for text input
  final TextEditingController _searchController = TextEditingController();
  // storage for selected tags
  final Set<String> _selectedTags = {};

final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // changes the ui per change in the test input // new state
    _searchController.addListener(() => setState(() {}));
  }

  // clean up
  @override
  void dispose() {
      _searchFocusNode.dispose();
  _searchController.dispose();
    super.dispose();
  }

  // toggle for tags // triggers the ui refresh
  void _toggleKeyword(String keyword) {
    setState(() {
      _selectedTags.contains(keyword)
          ? _selectedTags.remove(keyword) // if selected, deselect
          : _selectedTags.add(keyword); // if not selected, select
    });
  }

  // CONCEPT --------------------------------------------
  // the filtering uses score system
  // the product / post with the most score comes first in the search
  int _scorePost(Post post) {
    int score = 0;
    final query = _searchController.text.trim().toLowerCase();

    // + 10 per selected tag
    for (final kw in _selectedTags) {
      if (post.tags.contains(kw)) score += 10;
    }

    // if ther is something in the search box
    if (query.isNotEmpty) {
      if (post.title.toLowerCase().contains(query)) score += 50; // + 50 if the post title contains the query, must always comes first
      if (post.tags.any((t) => t.toLowerCase().contains(query))) score += 5; // if typed is in the tag
    }

    return score;
  }

  // helper func to determine is user is active in the ui
  bool get _isFiltering =>
      _searchController.text.trim().isNotEmpty || _selectedTags.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // watch for changes
    final postsProvider = context.watch<PostsProvider>();

    return Scaffold(
      body: Column(
        children: [
          // header for search bar
          Container(
            width: double.infinity,
            color: BrandColors.mediumGreen,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: _buildSearchBar(),
          ),
          // area for results and filters
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // tags container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildSection('Dietary Restrictions', FoodTags.dietaryTags),
                        _buildSection('Food Categories', FoodTags.categoryTags),
                      ],
                    ),
                  ),
                  // if user is actively using the screen, only then the results wiill show
                  if (_isFiltering) ...[
                    const SizedBox(height: 24),
                    _buildResults(postsProvider),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // search bar container
  // the tags selected will also show here!!!

Widget _buildSearchBar() {
  return GestureDetector(
    onTap: () {
      _searchFocusNode.requestFocus();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromRGBO(59, 109, 17, 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 80),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    cursorColor: BrandColors.black,
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                          ..._selectedTags.map((tag) => Chip(
                label: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: const Color.fromRGBO(59, 109, 17, 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onDeleted: () => _toggleKeyword(tag),
                deleteIconColor: Colors.white,
              )),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  // ui for tags section
  Widget _buildSection(String title, List<String> tags) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return GestureDetector(
                onTap: () => _toggleKeyword(tag),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? BrandColors.mediumGreen : Colors.transparent,
                    border: Border.all(color: BrandColors.mediumGreen),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white : BrandColors.mediumGreen,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // connect to the firebase
  Widget _buildResults(PostsProvider postsProvider) {
    return StreamBuilder<QuerySnapshot>(
      stream: postsProvider.getAllPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        // parse all docs into post objects
        final allPosts = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Post.fromJson(data);
        }).toList();

        // depending on the scoring system, filter it, 0 wont show
        final ranked = allPosts
            .map((post) => (post: post, score: _scorePost(post)))
            .where((e) => e.score > 0)
            .toList()
          ..sort((a, b) => b.score.compareTo(a.score));

        // empty state if none is selected
        if (ranked.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No posts match your search.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          );
        }

        // render the list
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${ranked.length} result${ranked.length == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ranked.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _SearchPostCard(post: ranked[index].post),
            ),
          ],
        );
      },
    );
  }
}

// UI FOR SEARCHED PRODUCTS
class _SearchPostCard extends StatelessWidget {
  final Post post;
  const _SearchPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    switch (post.status) {
      case PostStatus.available:
        statusColor = BrandColors.green;
        statusLabel = 'Available';
        break;
      case PostStatus.reserved:
        statusColor = BrandColors.yellow;
        statusLabel = 'Reserved';
        break;
      case PostStatus.completed:
        statusColor = BrandColors.gray;
        statusLabel = 'Completed';
        break;
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Food image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 90,
                height: 90,
                child: post.foodPicture != null && post.foodPicture!.isNotEmpty
                    ? Image.memory(
                        base64Decode(post.foodPicture!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const ColoredBox(
                          color: Color(0xFFEEEEEE),
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      )
                    : const ColoredBox(
                        color: Color(0xFFEEEEEE),
                        child: Icon(Icons.fastfood, color: Colors.grey),
                      ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            post.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: statusColor),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (post.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        post.description,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.event, size: 12, color: Colors.black45),
                        const SizedBox(width: 4),
                        Text(
                          'Expires ${DateFormat('MMM dd').format(post.expiration)}',
                          style: const TextStyle(fontSize: 11, color: Colors.black45),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.location_on, size: 12, color: Colors.black45),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            post.pickupAddress,
                            style: const TextStyle(fontSize: 11, color: Colors.black45),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}