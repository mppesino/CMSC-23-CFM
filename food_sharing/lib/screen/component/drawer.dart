import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: BrandColors.mediumGreen,
            ),
            child: Text(
              "Salo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),


          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/settings',
              );

              // navigate to profile
            },
          ),


          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/edit-profile',
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
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
                      style: TextButton.styleFrom(
                        foregroundColor: BrandColors.mediumGreen,
                      ),
                    ),

                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, true),
                      child: const Text('Logout'),
                      style: TextButton.styleFrom(
                        foregroundColor: BrandColors.mediumGreen,
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
    );
  }
}