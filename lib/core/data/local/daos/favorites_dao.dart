import 'package:injectable/injectable.dart';
import '../database.dart';

/// DAO for locally persisted favorites.
@lazySingleton
class FavoritesDao {
  final AppDatabase _db;

  FavoritesDao(this._db);

  /// Returns true if [restaurantId] is in the local favorites set.
  Future<bool> isFavorite(String restaurantId) async {
    final query = _db.select(_db.favoritesTable)
      ..where((t) => t.restaurantId.equals(restaurantId))
      ..limit(1);
    return (await query.getSingleOrNull()) != null;
  }

  /// Returns all locally-favorited restaurant IDs.
  Future<Set<String>> getFavoriteIds() async {
    final rows = await _db.select(_db.favoritesTable).get();
    return rows.map((r) => r.restaurantId).toSet();
  }

  /// Adds [restaurantId] to favorites (no-op if already present).
  Future<void> addFavorite(String restaurantId) =>
      _db.into(_db.favoritesTable).insertOnConflictUpdate(
            FavoritesTableCompanion.insert(restaurantId: restaurantId),
          );

  /// Removes [restaurantId] from favorites.
  Future<void> removeFavorite(String restaurantId) =>
      (_db.delete(_db.favoritesTable)
            ..where((t) => t.restaurantId.equals(restaurantId)))
          .go();

  /// Toggles favorite status. Returns the **new** status (true = liked).
  Future<bool> toggleFavorite(String restaurantId) async {
    final currently = await isFavorite(restaurantId);
    if (currently) {
      await removeFavorite(restaurantId);
    } else {
      await addFavorite(restaurantId);
    }
    return !currently;
  }

  /// Watches changes on the favorites table and emits the full set of IDs.
  Stream<Set<String>> watchFavoriteIds() {
    try {
      return _db
          .select(_db.favoritesTable)
          .watch()
          .map((rows) => rows.map((r) => r.restaurantId).toSet())
          .handleError((e) => <String>{});
    } catch (_) {
      return Stream.value(<String>{});
    }
  }
}
