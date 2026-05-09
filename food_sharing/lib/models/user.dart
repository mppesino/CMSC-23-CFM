import 'dart:convert';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

Uint8List base64ToImage(String base64String) {
  return base64Decode(base64String);
}

String imageToBase64(Uint8List bytes) {
  return base64Encode(bytes);
}

Future<Uint8List> compressImage(XFile file) async {
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes)!;

  final resized = img.copyResize(image, width: 300);

  return Uint8List.fromList(
    img.encodeJpg(resized, quality: 60),
  );
}

class User {
  String? userId;
  String email;
  String firstName;
  String lastName;
  String userName;
  String? bio;
  String? profilePicture;
  bool isOnboarded;
  bool isVerified;
  List<String>? tags;

  User({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userName,
    this.bio,
    this.profilePicture,
    required this.isOnboarded,
    required this.isVerified,
    this.tags,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      bio: json['bio'],
      profilePicture: json['profilePicture'],
      isOnboarded: json['isOnboarded'] ?? false,
      isVerified: json['isVerified'] ?? false,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : null,
        );
  }


  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'bio': bio,
      'profilePicture': profilePicture,
      'isVerified': isVerified,
      'isOnboarded': isOnboarded,
      'tags': tags,
    };
  }
}