class Blog {
  final String blogId;
  final String userId;
  final String name;
  final String? imagePath;
  final String creatTime;
  final String content;
  final int totalLikes;
  final bool isLikedByCurrentUser;

  Blog({
    required this.blogId,
    required this.userId,
    required this.name,
    this.imagePath,
    required this.creatTime,
    required this.content,
    this.totalLikes = 0,
    this.isLikedByCurrentUser = false,
  });

  factory Blog.fromJson(Map<String, dynamic> map) {
    return Blog(
      blogId: map['blogId'],
      userId: map['userId'],
      name: map['name'],
      imagePath: map['imagePath'],
      creatTime: map['creatTime'],
      content: map['content'],
      totalLikes: map['totalLikes'] ?? 0,
      isLikedByCurrentUser: map['isLikedByCurrentUser'] ?? false,
    );
  }
}
