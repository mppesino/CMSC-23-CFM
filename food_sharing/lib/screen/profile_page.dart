import 'package:flutter/material.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/profile.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/models/user.dart';
import 'package:food_sharing/theme/app_theme.dart';

class ProfilePage extends StatefulWidget {

  final User? user;

  ProfilePage({super.key, required this.user});

  @override 
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return(
      Scaffold(body:
        CenteredColumn(mainAxisAlignment: MainAxisAlignment.start, children:[
        
          SectionCard(crossAxisAlignment: CrossAxisAlignment.stretch, color:BrandColors.white, children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ProfilePicture(userID: widget.user?.userId ?? ""),
                        Text(
                          "@${widget.user?.userName ?? "user"}",
                          style: TextStyleTheme.body,
                        ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${widget.user?.firstName} ${widget.user?.lastName}", style: TextStyleTheme.subtitle_bold),

                          Text("This is my bio!", style: TextStyleTheme.body),

                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: (widget.user?.tags ?? [])
                                .map(_buildTags)
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
      ])
      ]))
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
