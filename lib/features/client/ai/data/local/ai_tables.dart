import 'package:drift/drift.dart';

class AiConversationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get title => text().withDefault(const Constant('Nouvelle conversation'))();
  DateTimeColumn get lastMessageAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class AiMessagesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get conversationId => text().references(AiConversationsTable, #id)();
  TextColumn get role => text()();
  TextColumn get content => text()();
  IntColumn get tokenCount => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}
