import 'package:drift/drift.dart';
import '../app_database.dart';

part 'restaurant_dao.g.dart';

@DriftAccessor(tables: [Restaurants])
class RestaurantDao extends DatabaseAccessor<AppDatabase>
    with _$RestaurantDaoMixin {
  RestaurantDao(super.db);

  Future<List<Restaurant>> getAllRestaurants() =>
      select(restaurants).get();

  Future<Restaurant?> getRestaurantById(String id) =>
      (select(restaurants)..where((r) => r.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsertRestaurant(RestaurantsCompanion entry) =>
      into(restaurants).insertOnConflictUpdate(entry);

  Future<void> upsertAll(List<RestaurantsCompanion> entries) =>
      batch((b) => b.insertAllOnConflictUpdate(restaurants, entries));

  Future<void> clearOldCache(Duration maxAge) {
    final cutoff = DateTime.now().subtract(maxAge);
    return (delete(restaurants)
          ..where((r) => r.cachedAt.isSmallerThanValue(cutoff)))
        .go();
  }
}
