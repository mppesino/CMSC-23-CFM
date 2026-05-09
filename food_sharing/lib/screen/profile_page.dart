import 'package:flutter/material.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/profile.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/models/user.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import "package:provider/provider.dart";

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override 
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
      final currentUser = context.watch<UsersProvider>().currentUser;


    return(
      Scaffold(body:
        CenteredColumn(mainAxisAlignment: MainAxisAlignment.start, children:[
        
          SectionCard(crossAxisAlignment: CrossAxisAlignment.stretch, color:BrandColors.white, children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ProfilePicture(user: currentUser,),
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
                          Row(children: 
                          [Padding(padding: EdgeInsets.all(2), child:Text("${currentUser?.firstName} ${currentUser?.lastName}", style: TextStyleTheme.subtitle_bold)),
                          Padding(padding: EdgeInsets.all(2), child:
                          
                          SizedBox(
                              width: 30,
                              height: 30,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.edit, size: 20, color: BrandColors.black),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/edit-profile');

                                },
                              ),
                            )),
                          ]
                          ),

                          Text(currentUser?.bio ?? "This is my bio!", style: TextStyleTheme.body),

                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: (currentUser?.tags ?? [])
                                .map(_buildTags)
                                .toList(),
                          ),
                          
                          const SizedBox(height: 8),


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
