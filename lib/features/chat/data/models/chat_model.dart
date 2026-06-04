import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderRole;
  final String content;
  final String type; // 'text', 'image'
  final String? fileUrl;
  final bool isRead;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderRole,
    required this.content,
    required this.type,
    this.fileUrl,
    this.isRead = false,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderRole: json['senderRole']?.toString() ?? 'client',
      content: json['content']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      fileUrl: json['fileUrl']?.toString(),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'conversationId': conversationId,
    'senderId': senderId,
    'senderRole': senderRole,
    'content': content,
    'type': type,
    if (fileUrl != null) 'fileUrl': fileUrl,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    conversationId,
    senderId,
    senderRole,
    content,
    type,
    fileUrl,
    isRead,
    createdAt,
  ];
}

class ConversationModel extends Equatable {
  final String id;
  final String type; // 'restaurant', 'support', 'delivery'
  final String? participantName;
  final String? participantAvatar;
  final String? restaurantId;
  final String? orderId;
  final int unreadCount;
  final MessageModel? lastMessage;
  final DateTime updatedAt;

  const ConversationModel({
    required this.id,
    required this.type,
    this.participantName,
    this.participantAvatar,
    this.restaurantId,
    this.orderId,
    this.unreadCount = 0,
    this.lastMessage,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'support',
      participantName: json['participantName']?.toString(),
      participantAvatar: json['participantAvatar']?.toString(),
      restaurantId: json['restaurantId']?.toString(),
      orderId: json['orderId']?.toString(),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'type': type,
    if (participantName != null) 'participantName': participantName,
    if (participantAvatar != null) 'participantAvatar': participantAvatar,
    if (restaurantId != null) 'restaurantId': restaurantId,
    if (orderId != null) 'orderId': orderId,
    'unreadCount': unreadCount,
    if (lastMessage != null) 'lastMessage': lastMessage!.toJson(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  @override
  List<Object?> get props => [
    id,
    type,
    participantName,
    participantAvatar,
    restaurantId,
    orderId,
    unreadCount,
    lastMessage,
    updatedAt,
  ];
}
