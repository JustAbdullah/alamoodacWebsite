class Comment {
  final int id;
  final int postId;
  final int userId;
  final String commentText;
  final String? userName; // اسم المستخدم الذي كتب التعليق
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.commentText,
    this.userName,
    required this.createdAt,
  });

  // إنشاء كائن Comment من JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: int.tryParse(json['post_id']) ?? 0, // التأكد من تحويل إلى int
      userId: int.tryParse(json['user_id']) ?? 0, // التأكد من تحويل إلى int
      commentText: json['comment_text'],
      userName: json['user']?['name'], // اسم المستخدم إذا كان موجودًا
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
