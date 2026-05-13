import 'package:flutter/material.dart';
import 'package:food_sharing/models/user.dart';
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

    return ClipOval(
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
    );
  }
}