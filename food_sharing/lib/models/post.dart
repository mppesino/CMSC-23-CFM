enum PostStatus { available, reserved, completed }

class Post {
  String? id;
  String? userId;
  String title;
  String description;
  PostStatus status;
  List<String> tags;
  DateTime expiration;
  String? foodPicture;
  String? reservedForId;
  List<String>? requesterIds;
  Map<String, String>? requesterAppeals;
  double postLat;
  double postLng;
  String pickupAddress;
  DateTime? pickupDateTime;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.tags,
    required this.expiration,
    required this.postLat,
    required this.postLng,
    required this.pickupAddress,
    this.pickupDateTime,
    this.foodPicture,
    this.reservedForId,
    this.requesterIds,
    this.requesterAppeals
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: PostStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PostStatus.available,
      ),

      postLat: (json['postLat'] ?? 0).toDouble(),
      postLng: (json['postLng'] ?? 0).toDouble(),
      pickupAddress: json['pickupAddress'] as String? ?? '',
      pickupDateTime: json['pickupDateTime'] is String
          ? DateTime.parse(json['pickupDateTime'])
          : json['pickupDateTime'] != null
              ? (json['pickupDateTime'] as dynamic).toDate()
              : DateTime.now(),

      tags: (json['tags'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],

      requesterIds: (json['requesterIds'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],

    requesterAppeals: json['requesterAppeals'] != null 
        ? Map<String, String>.from(json['requesterAppeals']) 
        : {},

    expiration: json['expiration'] is String
        ? DateTime.parse(json['expiration'])
        : json['expiration'] != null
            ? (json['expiration'] as dynamic).toDate()
            : DateTime.now(),
            
      foodPicture: json['foodPicture'] as String?,
      reservedForId: json['reservedForId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'status': status.name,
      'tags': tags,
      'expiration': expiration.toIso8601String(),
      'foodPicture': foodPicture,
      'reservedForId': reservedForId,
      'requesterIds': requesterIds,
      'requesterAppeals': requesterAppeals,
      'postLat': postLat,
      'postLng': postLng,
      'pickupAddress': pickupAddress,
      'pickupDateTime': pickupDateTime?.toIso8601String(),
    };
  }
}