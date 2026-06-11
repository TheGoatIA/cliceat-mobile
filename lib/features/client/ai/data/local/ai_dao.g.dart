// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_dao.dart';

// ignore_for_file: type=lint
mixin _$AiLocalDaoMixin on DatabaseAccessor<AppDatabase> {
  $AiConversationsTableTable get aiConversationsTable =>
      attachedDatabase.aiConversationsTable;
  $AiMessagesTableTable get aiMessagesTable => attachedDatabase.aiMessagesTable;
  AiLocalDaoManager get managers => AiLocalDaoManager(this);
}

class AiLocalDaoManager {
  final _$AiLocalDaoMixin _db;
  AiLocalDaoManager(this._db);
  $$AiConversationsTableTableTableManager get aiConversationsTable =>
      $$AiConversationsTableTableTableManager(
        _db.attachedDatabase,
        _db.aiConversationsTable,
      );
  $$AiMessagesTableTableTableManager get aiMessagesTable =>
      $$AiMessagesTableTableTableManager(
        _db.attachedDatabase,
        _db.aiMessagesTable,
      );
}
