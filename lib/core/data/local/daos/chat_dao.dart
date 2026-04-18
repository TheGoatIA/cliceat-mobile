import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/conversations_table.dart';
import '../tables/messages_table.dart';
import 'package:injectable/injectable.dart';

part 'chat_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [ConversationsTable, MessagesTable])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  ChatDao(super.db);

  Future<List<ConversationsTableData>> getConversations() {
    return (select(conversationsTable)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
  }

  Future<void> upsertConversations(List<ConversationsTableCompanion> items) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(conversationsTable, items);
    });
  }

  Future<List<MessagesTableData>> getMessages(String conversationId) {
    return (select(messagesTable)..where((t) => t.conversationId.equals(conversationId))..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<void> upsertMessages(List<MessagesTableCompanion> items) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(messagesTable, items);
    });
  }
}
