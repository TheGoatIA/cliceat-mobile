import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/data/local/database.dart';
import 'ai_tables.dart';

part 'ai_dao.g.dart';

@DriftAccessor(tables: [AiConversationsTable, AiMessagesTable])
@lazySingleton
class AiLocalDao extends DatabaseAccessor<AppDatabase> with _$AiLocalDaoMixin {
  AiLocalDao(super.db);

  Future<List<AiConversationsTableData>> getConversations() =>
      (select(aiConversationsTable)
        ..where((t) => t.isArchived.equals(false))
        ..orderBy([(t) => OrderingTerm.desc(t.lastMessageAt)]))
          .get();

  Future<AiConversationsTableData?> getConversation(String id) =>
      (select(aiConversationsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> createConversation(String title) async {
    final id = const Uuid().v4();
    await into(aiConversationsTable).insert(AiConversationsTableCompanion.insert(
      id: id,
      title: title,
      lastMessageAt: DateTime.now(),
      createdAt: DateTime.now(),
    ));
    return id;
  }

  Future<void> updateConversation(String id, {String? title, String? serverId, bool? isSynced}) async {
    final companion = AiConversationsTableCompanion(
      title: title != null ? Value(title) : const Value.absent(),
      serverId: serverId != null ? Value(serverId) : const Value.absent(),
      isSynced: isSynced != null ? Value(isSynced) : const Value.absent(),
      lastMessageAt: Value(DateTime.now()),
    );
    await (update(aiConversationsTable)..where((t) => t.id.equals(id))).write(companion);
  }

  Future<void> archiveConversation(String id) =>
      (update(aiConversationsTable)..where((t) => t.id.equals(id)))
          .write(const AiConversationsTableCompanion(isArchived: Value(true)));

  Future<List<AiMessagesTableData>> getMessages(String conversationId) =>
      (select(aiMessagesTable)
        ..where((t) => t.conversationId.equals(conversationId))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<void> insertMessage({
    required String conversationId,
    required String role,
    required String content,
    int? tokenCount,
  }) =>
      into(aiMessagesTable).insert(AiMessagesTableCompanion.insert(
        conversationId: conversationId,
        role: role,
        content: content,
        tokenCount: Value(tokenCount),
        createdAt: DateTime.now(),
      ));

  Future<void> deleteConversation(String id) async {
    await (delete(aiMessagesTable)..where((t) => t.conversationId.equals(id))).go();
    await (delete(aiConversationsTable)..where((t) => t.id.equals(id))).go();
  }
}
