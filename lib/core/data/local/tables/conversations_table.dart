import 'package:drift/drift.dart';

class ConversationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get participantName => text().nullable()();
  TextColumn get participantAvatar => text().nullable()();
  TextColumn get lastMessageContent => text().nullable()();
  DateTimeColumn get lastMessageAt => dateTime().nullable()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
