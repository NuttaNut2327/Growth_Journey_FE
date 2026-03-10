class ChatMessage {
  final String id;
  final String groupId;
  final String userId;
  final String userName;
  final String message;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.userName,
    required this.message,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['message_id'] ?? json['id'] ?? '',
      groupId: json['group_id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? json['username'] ?? 'Unknown',
      message: json['message'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_id': id,
      'group_id': groupId,
      'user_id': userId,
      'user_name': userName,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
