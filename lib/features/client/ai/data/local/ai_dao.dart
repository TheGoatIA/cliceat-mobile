import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/data/local/database.dart';

class AiConversationRow {
  final String id;
  final String? serverId;
  final String title;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final bool isSynced;
  final bool isArchived;

  AiConversationRow({
    required this.id,
    this.serverId,
    required this.title,
    required this.lastMessageAt,
    required this.createdAt,
    required this.isSynced,
    required this.isArchived,
  });

  factory AiConversationRow.fromRow(QueryRow row) => AiConversationRow(
        id: row.read<String>('id'),
        serverId: row.readNullable<String>('server_id'),
        title: row.read<String>('title'),
        lastMessageAt: DateTime.fromMillisecondsSinceEpoch(
            row.read<int>('last_message_at') * 1000),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            row.read<int>('created_at') * 1000),
        isSynced: row.read<int>('is_synced') == 1,
        isArchived: row.read<int>('is_archived') == 1,
      );
}

class AiMessageRow {
  final int id;
  final String conversationId;
  final String role;
  final String content;
  final int? tokenCount;
  final DateTime createdAt;
  final bool isSynced;

  AiMessageRow({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    this.tokenCount,
    required this.createdAt,
    required this.isSynced,
  });

  factory AiMessageRow.fromRow(QueryRow row) => AiMessageRow(
        id: row.read<int>('id'),
        conversationId: row.read<String>('conversation_id'),
        role: row.read<String>('role'),
        content: row.read<String>('content'),
        tokenCount: row.readNullable<int>('token_count'),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            row.read<int>('created_at') * 1000),
        isSynced: row.read<int>('is_synced') == 1,
      );
}

@lazySingleton
class AiLocalDao {
  final AppDatabase _db;

  AiLocalDao(this._db);

  Future<List<AiConversationRow>> getConversations() async {
    final rows = await _db.customSelect(
      'SELECT * FROM ai_conversations_table WHERE is_archived = 0 ORDER BY last_message_at DESC',
    ).get();
    return rows.map(AiConversationRow.fromRow).toList();
  }

  Future<AiConversationRow?> getConversation(String id) async {
    final rows = await _db.customSelect(
      'SELECT * FROM ai_conversations_table WHERE id = ?',
      variables: [Variable.withString(id)],
    ).get();
    if (rows.isEmpty) return null;
    return AiConversationRow.fromRow(rows.first);
  }

  Future<String> createConversation(String title) async {
    final id = const Uuid().v4();
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _db.customInsert(
      'INSERT INTO ai_conversations_table (id, title, last_message_at, created_at, is_synced, is_archived) VALUES (?, ?, ?, ?, 0, 0)',
      variables: [
        Variable.withString(id),
        Variable.withString(title),
        Variable.withInt(now),
        Variable.withInt(now),
      ],
    );
    return id;
  }

  Future<void> updateConversation(String id,
      {String? title, String? serverId, bool? isSynced}) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final parts = <String>['last_message_at = ?'];
    final vars = <Variable>[Variable.withInt(now)];

    if (title != null) {
      parts.add('title = ?');
      vars.add(Variable.withString(title));
    }
    if (serverId != null) {
      parts.add('server_id = ?');
      vars.add(Variable.withString(serverId));
    }
    if (isSynced != null) {
      parts.add('is_synced = ?');
      vars.add(Variable.withInt(isSynced ? 1 : 0));
    }

    vars.add(Variable.withString(id));
    await _db.customUpdate(
      'UPDATE ai_conversations_table SET ${parts.join(', ')} WHERE id = ?',
      variables: vars,
    );
  }

  Future<void> archiveConversation(String id) async {
    await _db.customUpdate(
      'UPDATE ai_conversations_table SET is_archived = 1 WHERE id = ?',
      variables: [Variable.withString(id)],
    );
  }

  Future<List<AiMessageRow>> getMessages(String conversationId) async {
    final rows = await _db.customSelect(
      'SELECT * FROM ai_messages_table WHERE conversation_id = ? ORDER BY created_at ASC',
      variables: [Variable.withString(conversationId)],
    ).get();
    return rows.map(AiMessageRow.fromRow).toList();
  }

  Future<void> insertMessage({
    required String conversationId,
    required String role,
    required String content,
    int? tokenCount,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _db.customInsert(
      'INSERT INTO ai_messages_table (conversation_id, role, content, token_count, created_at, is_synced) VALUES (?, ?, ?, ?, ?, 0)',
      variables: [
        Variable.withString(conversationId),
        Variable.withString(role),
        Variable.withString(content),
        tokenCount != null ? Variable.withInt(tokenCount) : const Variable(null),
        Variable.withInt(now),
      ],
    );
  }

  Future<void> deleteConversation(String id) async {
    await _db.customUpdate(
      'DELETE FROM ai_messages_table WHERE conversation_id = ?',
      variables: [Variable.withString(id)],
    );
    await _db.customUpdate(
      'DELETE FROM ai_conversations_table WHERE id = ?',
      variables: [Variable.withString(id)],
    );
  }
}
