import 'package:drift/drift.dart' as drift;
import 'package:injectable/injectable.dart';
import '../database.dart';

/// Data Access Object for user preferences.
@lazySingleton
class UserPrefsDao {
  final AppDatabase _db;

  UserPrefsDao(this._db);

  Future<UserPrefsTableData?> getPrefs(String userId) async {
    final query = _db.select(_db.userPrefsTable)
      ..where((t) => t.userId.equals(userId))
      ..limit(1);
    final results = await query.get();
    return results.firstOrNull;
  }

  Future<void> upsert(UserPrefsTableCompanion prefs) =>
      _db.into(_db.userPrefsTable).insertOnConflictUpdate(prefs);

  Future<void> updateField(
      String userId, UserPrefsTableCompanion partial) async {
    await (_db.update(_db.userPrefsTable)
          ..where((t) => t.userId.equals(userId)))
        .write(partial);
  }

  Future<void> deleteForUser(String userId) =>
      (_db.delete(_db.userPrefsTable)
            ..where((t) => t.userId.equals(userId)))
          .go();

  Future<void> setOnlineStatus(String userId, bool isOnline) =>
      updateField(
        userId,
        UserPrefsTableCompanion(
          isOnline: drift.Value(isOnline),
        ),
      );

  Future<void> setLanguage(String userId, String lang) => updateField(
        userId,
        UserPrefsTableCompanion(language: drift.Value(lang)),
      );

  Future<void> setDarkMode(String userId, bool? isDark) => updateField(
        userId,
        UserPrefsTableCompanion(isDarkMode: drift.Value(isDark)),
      );
}
