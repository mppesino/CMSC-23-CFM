enum PostStatus { Available, Reserved, Unavailable }

class Post {
  String? id;
  String? userId;
  String title;
  String description;
  PostStatus status;
  List<String> tags;
  DateTime expiration;
  String? foodPicture;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.tags,
    required this.expiration,
    this.foodPicture,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as String?,
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      status: PostStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PostStatus.Available,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      expiration: DateTime.parse(json['expiration'] as String),
      foodPicture: json['foodPicture'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'tags': tags,
      'expiration': expiration.toIso8601String(),
      'foodPicture': foodPicture,
    };
  }
}
