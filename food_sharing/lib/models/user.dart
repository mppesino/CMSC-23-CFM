
class User {
  String? userId;
  String email;
  String name;
  String? bio;
  String? profilePicture;
  Map<String, String>? tags;

  User({required this.userId, required this.email, required this.name, this.bio, this.profilePicture, this.tags});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],
      tags: json['tags'] != null ? Map<String, String>.from(json['tags']) : null,    );
  }

  Map<String, dynamic> toJson(){
    return{'userId': userId, 'email': email, 'name': name, 'bio': bio, 'profile_picture': profilePicture, 'tags': tags};
  }

}

