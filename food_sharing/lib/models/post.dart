enum PostStatus { available, requested, reserved, completed }

class Post {
  String? id;
  String? userId;
  String title;
  String description;
  PostStatus status;
  List<String> dietary;
  List<String> category;
  DateTime expiration;
  String? imageUrl;

  Post({
    this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.dietary,
    required this.category,
    required this.expiration,
    this.imageUrl,
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
      dietary: List<String>.from(json['dietary'] ?? json['tags'] ?? []),
      category: List<String>.from(json['category'] ?? json['tag'] ?? []),
      expiration: DateTime.parse(json['expiration'] as String),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'dietary': dietary,
      'category': category,
      'expiration': expiration.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}
