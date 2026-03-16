import 'package:drift/drift.dart';

class CartTable extends Table {
  TextColumn get id => text()();
  TextColumn get restaurantId => text()();
  TextColumn get itemId => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get variationJson => text().nullable()();
  TextColumn get addonJson => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
