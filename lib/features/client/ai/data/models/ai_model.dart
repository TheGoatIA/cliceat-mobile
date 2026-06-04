import 'package:equatable/equatable.dart';

class AiSuggestionModel extends Equatable {
  final String text;

  const AiSuggestionModel({required this.text});

  factory AiSuggestionModel.fromJson(Map<String, dynamic> json) {
    return AiSuggestionModel(text: json['text']?.toString() ?? '');
  }

  @override
  List<Object?> get props => [text];
}

class AiMessageModel extends Equatable {
  final String role;
  final String content;

  const AiMessageModel({required this.role, required this.content});

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      role: json['role']?.toString() ?? 'model',
      content: json['content']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'role': role, 'content': content};

  @override
  List<Object?> get props => [role, content];
}
