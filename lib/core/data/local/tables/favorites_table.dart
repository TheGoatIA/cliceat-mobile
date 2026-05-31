import 'package:drift/drift.dart';

/// Table for locally persisted restaurant favorites.
class FavoritesTable extends Table {
  /// Restaurant ID (backend _id).
  TextColumn get restaurantId => text()();

  /// When the favorite was added locally.
  DateTimeColumn get savedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {restaurantId};
}
