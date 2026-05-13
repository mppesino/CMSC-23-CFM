import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/profile.dart';
import 'package:food_sharing/component/sections.dart';
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

    return Scaffold(
      body: CenteredColumn(
        mainAxisAlignment: MainAxisAlignment.start,
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
                        userID: currentUser?.userId ?? "",
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

                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: BrandColors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-profile',
                                    );
                                  },
                                ),
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

                        const SizedBox(height: 20),

                        // LOGOUT BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            icon: const Icon(Icons.logout),

                            label: const Text(
                              "Logout",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                    'Are you sure you want to logout?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),

                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await FirebaseAuth.instance.signOut();

                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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