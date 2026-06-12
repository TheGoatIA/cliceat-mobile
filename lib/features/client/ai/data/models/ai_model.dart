import 'package:equatable/equatable.dart';

class AiMessageModel extends Equatable {
  final String role;
  final String content;
  final int? tokenCount;
  final DateTime? createdAt;

  const AiMessageModel({
    required this.role,
    required this.content,
    this.tokenCount,
    this.createdAt,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) => AiMessageModel(
    role: json['role'] as String,
    content: json['content'] as String,
    tokenCount: json['tokenCount'] as int?,
  );

  Map<String, dynamic> toJson() => {'role': role, 'content': content};

  @override
  List<Object?> get props => [role, content, createdAt];
}

class AiConversationModel extends Equatable {
  final String id;
  final String? serverId;
  final String title;
  final DateTime lastMessageAt;
  final List<AiMessageModel> messages;
  final bool isSynced;

  const AiConversationModel({
    required this.id,
    this.serverId,
    required this.title,
    required this.lastMessageAt,
    this.messages = const [],
    this.isSynced = false,
  });

  String get lastMessagePreview => messages.isNotEmpty
      ? messages.last.content.substring(
          0,
          messages.last.content.length.clamp(0, 80),
        )
      : '';

  @override
  List<Object?> get props => [id, title, lastMessageAt, isSynced];
}

class AiSuggestionModel extends Equatable {
  final String text;
  const AiSuggestionModel({required this.text});

  factory AiSuggestionModel.fromJson(Map<String, dynamic> json) {
    return AiSuggestionModel(text: json['text']?.toString() ?? '');
  }

  @override
  List<Object?> get props => [text];
}
