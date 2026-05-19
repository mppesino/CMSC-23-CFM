
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

  double discoveryRadius;
  bool alertOnDietaryMatch;
  bool alertOnReminders;

  bool enableDiscovery;
  bool enableRequests;
  bool enablePickups;

  double lat;
  double lng;

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

    this.discoveryRadius = 5,   //default: 5km radius
    this.alertOnDietaryMatch = true,
    this.alertOnReminders = true,

    this.enableDiscovery = false,
    this.enablePickups = false,
    this.enableRequests = false,

    //default coordinates (UPLB):
    this.lat = 14.1653,
    this.lng = 121.2410,
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

      discoveryRadius: (json['discoveryRadius'] as num?)?.toDouble() ?? 5,
      alertOnDietaryMatch: json['alertOnDietaryMatch'] ?? true,
      alertOnReminders: json['alertOnReminders'] ?? true,

      enableDiscovery: json['enableDiscovery'] ?? false,
      enablePickups: json['enablePickups'] ?? false,
      enableRequests: json['enableRequests'] ?? false,

      lat: (json['lat'] as num?)?.toDouble() ?? 14.1653,
      lng: (json['lng'] as num?)?.toDouble() ?? 121.2410,
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

      'discoveryRadius': discoveryRadius,
      'alertOnDietaryMatch': alertOnDietaryMatch,
      'alertOnReminders': alertOnReminders,

      'enableDiscovery': enableDiscovery,
      'enablePickups': enablePickups,
      'enableRequests': enableRequests,

      'lat': lat,
      'lng': lng,
    };
  }
}