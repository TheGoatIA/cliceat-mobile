import 'package:drift/drift.dart';

class RestaurantsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get cuisineJson => text().nullable()(); // List<String> encoded
  TextColumn get address => text().nullable()();
  TextColumn get city => text()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get coverUrl => text().nullable()();
  RealColumn get rating => real().nullable()();
  BoolColumn get isOpen => boolean().withDefault(const Constant(true))();
  RealColumn get deliveryFee => real().withDefault(const Constant(0.0))();
  RealColumn get minOrder => real().withDefault(const Constant(0.0))();
  IntColumn get avgDeliveryTime => integer().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
