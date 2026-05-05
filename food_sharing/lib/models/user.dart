class User {
  String? userId;
  String email;
  String firstName;
  String lastName;
  String userName;
  String? bio;
  String? profilePicture;
  bool isOnboarded;
  Map<String, String>? tags;

  User({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userName,
    this.bio,
    this.profilePicture,
    required this.isOnboarded,
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
      tags: json['tags'] != null
          ? Map<String, String>.from(json['tags'])
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
      'isOnboarded': isOnboarded,
      'tags': tags,
    };
  }
}