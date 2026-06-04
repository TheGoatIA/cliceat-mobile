// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dao.dart';

// ignore_for_file: type=lint
mixin _$ChatDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConversationsTableTable get conversationsTable =>
      attachedDatabase.conversationsTable;
  $MessagesTableTable get messagesTable => attachedDatabase.messagesTable;
  ChatDaoManager get managers => ChatDaoManager(this);
}

class ChatDaoManager {
  final _$ChatDaoMixin _db;
  ChatDaoManager(this._db);
  $$ConversationsTableTableTableManager get conversationsTable =>
      $$ConversationsTableTableTableManager(
        _db.attachedDatabase,
        _db.conversationsTable,
      );
  $$MessagesTableTableTableManager get messagesTable =>
      $$MessagesTableTableTableManager(_db.attachedDatabase, _db.messagesTable);
}
