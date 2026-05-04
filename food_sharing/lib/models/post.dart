enum PostStatus { available, requested, reserved, completed }

class Post {
  String? id;
  String? userId;
  String title;
  String description;
  PostStatus status;
  List<String> tags;
  DateTime expiration;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.tags,
    required this.expiration,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as String?,
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      status: PostStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PostStatus.available,
      ),
      tags: List<String>.from(json['tags'] ?? []),
      expiration: DateTime.parse(json['expiration'] as String),
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
    };
  }
}