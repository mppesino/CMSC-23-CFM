import 'package:flutter/material.dart';
import 'package:food_sharing/screen/component/posts.dart';
import 'package:food_sharing/screen/component/profile.dart';
import 'package:food_sharing/screen/component/sections.dart';
import 'package:food_sharing/models/user.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final bool showAppBar;

  const ProfilePage({super.key, required this.user, required this.showAppBar});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0; // Local state to switch between views

  @override
  Widget build(BuildContext context) {
    final postsProvider = context.watch<PostsProvider>();

    return Scaffold(
      appBar: widget.showAppBar 
          ? AppBar(
              title: Text("@${widget.user.userName}", style: TextStyleTheme.subtitle_bold), 
              backgroundColor: BrandColors.white,
              elevation: 0,
            ) 
          : null,
      backgroundColor: widget.showAppBar ? BrandColors.white : BrandColors.cream,
      body: 
      SingleChildScrollView(child: 
            Container(
      color: widget.showAppBar ? BrandColors.white : BrandColors.cream,
      child: Column(
        children: [
          _buildProfileHeader(),
          Row(
            children: [
              _buildTabButton(Icons.fastfood, 0),
              _buildTabButton(Icons.list, 1),
            ],
          ),
          const Divider(height: 1, thickness: 1),

        if (_selectedTab == 0)
          PostFeed(
            stream: postsProvider.getPostsByUser(widget.user.userId ?? ""),
            type: FeedType.profile,
            shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(), 
          )
        else
          Text("Requests")

        ],
      )),
      )
    );
      }

  Widget _buildTabButton(IconData iconData, int index) {
  bool isSelected = _selectedTab == index;
  
  return Expanded(
    child: InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              // Shows the green line only when selected
              color: isSelected ? BrandColors.green : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Icon(
          iconData, // Pass the IconData directly here
          color: isSelected ? BrandColors.green : Colors.grey,
          size: 24, // Adjust size as needed
        ),
      ),
    ),
  );
}

  Widget _buildProfileHeader() {
    return SectionCard(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      color: BrandColors.white,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [ProfilePicture(user: widget.user)]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.user.firstName} ${widget.user.lastName}",
                      style: TextStyleTheme.subtitle_bold),
                  Text(widget.user.bio ?? "This is my bio!", style: TextStyleTheme.body),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: (widget.user.tags ?? []).map(_buildTags).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTags(String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      backgroundColor: BrandColors.green,
      shape: const StadiumBorder(),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}