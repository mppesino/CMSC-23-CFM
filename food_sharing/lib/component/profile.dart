import 'package:flutter/material.dart';
import 'package:food_sharing/models/user.dart';
import 'package:food_sharing/theme/app_theme.dart';

import 'dart:convert';

class ProfilePicture extends StatelessWidget {
  final User? user;
  final double size;

  const ProfilePicture({
    super.key,
    this.user,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final hasPfp = user?.profilePicture != null &&
        user!.profilePicture!.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: hasPfp
              ? Image.memory(
                  base64Decode(user!.profilePicture!),
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/pfp.jpg',
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
        ),

      if (hasPfp)
        Positioned(
          bottom: 0,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            ),
          ),
        ),
        ],
    );
  }
}