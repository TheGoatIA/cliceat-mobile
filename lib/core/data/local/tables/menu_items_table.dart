import 'package:drift/drift.dart';

class MenuItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get restaurantId => text()(); // Clé étrangère logique
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get price => real()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get category => text().nullable()();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  TextColumn get extrasJson => text().nullable()(); // List d'options en JSON

  @override
  Set<Column> get primaryKey => {id};
}
