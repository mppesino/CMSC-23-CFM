import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/models/user.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/component/profile.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:food_sharing/screen/component/buttons.dart';
import 'package:food_sharing/screen/component/posts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  final _commentController = TextEditingController();

  PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final postsProvider = context.watch<PostsProvider>();
    final usersProvider = context.watch<UsersProvider>();

    Color tagColor = BrandColors.gray;
    if(post.status == PostStatus.available){
      tagColor = BrandColors.green;
    } else if (post.status == PostStatus.reserved){
      tagColor = BrandColors.yellow;
    } else if (post.status == PostStatus.completed){
      tagColor = BrandColors.gray;
    } 

    return Scaffold(
      backgroundColor: BrandColors.white,
      appBar: AppBar(
        backgroundColor: BrandColors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(post.title, style: TextStyleTheme.subtitle_bold,),
        actions: [
        if (post.userId == usersProvider.currentUser?.userId)
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: Colors.black),
          color: Colors.white, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          
          onSelected: (value) {
            if (value == 'delete') {
              Navigator.pop(context);
              postsProvider.deletePost(post.id ?? "");
            }
          },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'delete',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Delete Post',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
        ],
        )      
        ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              width: double.infinity,
              height: 350,
              color: Colors.grey[200],
              child: post.foodPicture != null && post.foodPicture!.isNotEmpty
                  ? Image.memory(
                      base64Decode(post.foodPicture!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 100, color: Colors.grey),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  PostCardHeader(userId: post.userId,),  
                  const SizedBox(height: 12),
                  if (post.description.trim().isNotEmpty) ...[
                    Text(
                      post.description,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],


                if (post.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: post.tags
                        .map((cat) => _buildTagChip(cat, Colors.blue))
                        .toList(),
                  ),
                  const SizedBox(height: 25),
                  ],

                  
                  Row(
                    children: [
                      const Icon(
                        Icons.event,
                        color: BrandColors.gray,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Expires: ${DateFormat('MMMM dd, yyyy').format(post.expiration)}",
                        style: const TextStyle(
                          color: BrandColors.gray,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 25),

                  const Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTagChip(post.status == PostStatus.available ? "Available" 
                                : post.status == PostStatus.reserved ? "Reserved"
                                : post.status == PostStatus.completed ? "Completed" : "Error", tagColor),
                  const SizedBox(height: 25),
                

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pickup Details",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () async {
                      final url = Uri.parse(
                        "https://www.google.com/maps/search/?api=1&query=${post.postLat},${post.postLng}",
                      );
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(
                                post.pickupAddress,
                                style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${DateFormat('MMMM dd, yyyy  h:mm a').format(post.pickupDateTime)}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ))
                            ]
                          )),
                  
                          const Padding(
                            padding: EdgeInsets.all(12.0), 
                            child: Icon(
                              Icons.location_on,
                              color: Colors.black, 
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                post.userId == usersProvider.currentUser?.userId ?
                _buildGiverView(context, post)
                :_buildRequesterView(context, post, usersProvider.currentUser?.userId ?? "")

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildGiverView(BuildContext context, Post post) {
  final requesterIds = post.requesterIds ?? [];

  return Theme(
    // This removes the default borders that ExpansionTile adds when expanded
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: 
    post.reservedForId == null ?
    ExpansionTile(
      // Keep padding consistent with your other headers
      tilePadding: EdgeInsets.zero,
      title: Text(
        "Requests (${requesterIds.length})",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      initiallyExpanded: requesterIds.isNotEmpty, 
      iconColor: BrandColors.black,
      children: [
        if (requesterIds.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text("No requests yet", style: TextStyle(fontSize: 18),)),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requesterIds.length,
            itemBuilder: (context, index) {
              final requesterId = requesterIds[index];

              return FutureBuilder(
                future: context.read<UsersProvider>().getUserById(requesterId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const ListTile(title: Text("Loading..."));
                  }

                  final user = snapshot.data!;

                  return Card(
                    elevation: 0, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    color: BrandColors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      leading: CircleAvatar(
                        radius: 20,
                        child: ProfilePicture(user: user),
                      ),
                      title: Text(
                        "@${user.userName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        (post.requesterAppeals?[requesterId]?.trim().isNotEmpty ?? false)
                            ? post.requesterAppeals![requesterId]!
                            : "Requested this item",
                      ),
                      trailing: PrimaryButton(
                        icon: Icons.check,
                        onPressed: () {_handleAccept(context, user, post);},
                        style: "green",
                        size: const Size(45, 45),
                      ),
                    ),
                  );
                },
              );
            },
          ),
      ],
    )
    :
    Column(children: [
      const Text(
        "Reserved For",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10,),
      PostCardHeader(userId: post.reservedForId),
      SizedBox(height: 25,),
      Center(child: PrimaryButton(text:"Generate QR", onPressed: () {}, style:"yellow")),],)
    );
}

  Widget _buildRequesterView(BuildContext context, Post post, String currentUid){

    bool alreadyRequested = (post.requesterIds ?? []).contains(currentUid);
    final bool disabled =
      post.status == PostStatus.reserved || alreadyRequested;

    return(
      Column(children: [
       (!disabled)? TextField(
          controller: _commentController,
          maxLines: 1,
          cursorColor: BrandColors.darkGreen,
          decoration: InputDecoration(
            hintText: 'Why do you need this item?',
            filled: true,
            fillColor: Colors.grey.shade100,
            label: Text("Request Message"),
            labelStyle: TextStyle(color: BrandColors.darkGreen),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ) : const SizedBox.shrink(),
        const SizedBox(height: 15),
        Center(child: _buildRequestButton(context, post, currentUid, alreadyRequested))
      ],)
    );
  }

Widget _buildRequestButton(BuildContext context, Post post, String currentUid,  bool alreadyRequested) {


  final bool disabled =
      post.status == PostStatus.reserved || alreadyRequested;

  return PrimaryButton(
    text: post.reservedForId == currentUid
    ? "Reserved by You"
    : alreadyRequested
        ? "Requested"
        : disabled
            ? "Reserved"
            : "Request Item",
      onPressed: disabled ? null : () {
      _handleRequest(context, currentUid, post);
    },
    style: disabled ? "gray" : "green",
  );
}

Future<void> _handleRequest(
    BuildContext context,
    String? currentUid,
    Post post
  ) async {
    if (currentUid == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Item'),
        content: Text('Send a request for "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: BrandColors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: BrandColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        ],
      ),
    );

    if (confirmed == true) {
      await context.read<PostsProvider>().editPost(
        post.id!,
        {
        'requesterIds': FieldValue.arrayUnion([currentUid]),
        'requesterAppeals.$currentUid': _commentController.text,
        }
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Request sent! Status will update to Reserved once accepted.',
            ),
            backgroundColor: BrandColors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}

Future<void> _handleAccept(
    BuildContext context,
    User user,
    Post post
  ) async {

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Item'),
        content: Text('Reserve item for ${user.userName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: BrandColors.green)),
          ),
                    TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: BrandColors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await context.read<PostsProvider>().editPost(
        post.id!,
        {
        'requesterIds': [],
        'requesterAppeals': {},
        'reservedForId': user.userId,
        'status': PostStatus.reserved.name
        }
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Reserved! Status has been updated for all users.',
            ),
            backgroundColor: BrandColors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
}


Widget _buildTagChip(String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color),
    ),
    child: Text(
      label,
      style: TextStyle(color: color, fontWeight: FontWeight.w600),
    ),
  );
}
