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
  List<String> requesterIds;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.tags,
    required this.expiration,
    this.foodPicture,
    this.reservedForId,
    this.requesterIds = const [],
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

      tags: (json['tags'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],

      requesterIds: (json['requesterIds'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],

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
    };
  }
}