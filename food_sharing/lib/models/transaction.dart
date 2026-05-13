enum TransactionStatus { pending, approved, declined, completed, cancelled }

class PostTransaction {
  String? id;
  String postId;
  String giverId;
  String requesterId;
  String? comment;
  TransactionStatus status;
  DateTime createdAt;

  PostTransaction({
    this.id,
    required this.postId,
    required this.giverId,
    required this.requesterId,
    this.comment,
    required this.status,
    required this.createdAt,
  });

  factory PostTransaction.fromJson(Map<String, dynamic> json) {
    return PostTransaction(
      id: json['id'] as String?,
      postId: json['postId'] as String,
      giverId: json['giverId'] as String,
      requesterId: json['requesterId'] as String,
      comment: json['comment'] as String,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'giverId': giverId,
      'requesterId': requesterId,
      'comment': comment,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}