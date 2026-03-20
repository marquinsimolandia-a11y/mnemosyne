import 'dart:convert';

enum MessageRole {
  user,
  model,
  system,
}

class MessageModel {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final List<String>? attachments;

  MessageModel({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.attachments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'role': role.name,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments != null ? jsonEncode(attachments) : null,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      content: map['content'] as String,
      role: MessageRole.values.byName(map['role'] as String),
      timestamp: DateTime.parse(map['timestamp'] as String),
      attachments: map['attachments'] != null
          ? List<String>.from(jsonDecode(map['attachments'] as String) as List)
          : null,
    );
  }

  MessageModel copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    List<String>? attachments,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      attachments: attachments ?? this.attachments,
    );
  }
}
