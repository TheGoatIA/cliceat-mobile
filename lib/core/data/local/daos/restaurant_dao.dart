import 'package:drift/drift.dart' as drift;
import '../database.dart';

/// Data Access Object for restaurant cache operations.
class RestaurantDao {
  final AppDatabase _db;

  RestaurantDao(this._db);

  Future<List<RestaurantsTableData>> getAll() =>
      _db.select(_db.restaurantsTable).get();

  Future<List<RestaurantsTableData>> getByCity(String city) async {
    final query = _db.select(_db.restaurantsTable)
      ..where((t) => t.city.equals(city));
    return query.get();
  }

  Future<RestaurantsTableData?> getById(String id) async {
    final query = _db.select(_db.restaurantsTable)
      ..where((t) => t.id.equals(id))
      ..limit(1);
    final results = await query.get();
    return results.firstOrNull;
  }

  Future<void> upsert(RestaurantsTableCompanion entry) =>
      _db.into(_db.restaurantsTable).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<RestaurantsTableCompanion> entries) =>
      _db.batch((batch) {
        batch.insertAllOnConflictUpdate(_db.restaurantsTable, entries);
      });

  Future<void> deleteById(String id) =>
      (_db.delete(_db.restaurantsTable)..where((t) => t.id.equals(id)))
          .go();

  /// Remove restaurants cached more than [maxAgeHours] hours ago.
  Future<void> evictStale({int maxAgeHours = 24}) async {
    final cutoff =
        DateTime.now().subtract(Duration(hours: maxAgeHours));
    await (_db.delete(_db.restaurantsTable)
          ..where((t) => t.cachedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  Stream<List<RestaurantsTableData>> watchAll() =>
      _db.select(_db.restaurantsTable).watch();
}
