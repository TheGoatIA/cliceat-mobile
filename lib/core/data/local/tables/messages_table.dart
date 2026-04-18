import 'package:drift/drift.dart';

class MessagesTable extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get senderId => text()();
  TextColumn get senderRole => text()();
  TextColumn get content => text()();
  TextColumn get fileUrl => text().nullable()();
  TextColumn get messageType => text().withDefault(const Constant('text'))();
  TextColumn get status => text().withDefault(const Constant('sent'))(); // sent, pending, error
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
