import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'daos/restaurant_dao.dart';
import 'daos/order_dao.dart';

part 'app_database.g.dart';

// Tables
class Restaurants extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get address => text().nullable()();
  RealColumn get rating => real().withDefault(const Constant(0))();
  BoolColumn get isOpen => boolean().withDefault(const Constant(false))();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get restaurantId => text()();
  TextColumn get restaurantName => text()();
  TextColumn get status => text()();
  RealColumn get total => real()();
  TextColumn get itemsJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Restaurants, Orders], daos: [RestaurantDao, OrderDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'cliceat.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
