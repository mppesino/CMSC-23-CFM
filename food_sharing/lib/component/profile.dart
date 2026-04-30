import 'package:flutter/cupertino.dart';

class ProfilePicture extends StatelessWidget {
  final String userID;

  const ProfilePicture({
    super.key,
    required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: Image.network(
        'https://picsum.photos/200', 
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}