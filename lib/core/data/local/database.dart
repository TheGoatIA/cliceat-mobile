import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables/user_prefs_table.dart';
import 'tables/restaurants_table.dart';
import 'tables/cart_table.dart';
import 'tables/pending_actions_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    UserPrefsTable,
    RestaurantsTable,
    CartTable,
    PendingActionsTable, // ajouté en v2
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructeur pour les tests en mémoire.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // v1 → v2 : ajout de la table pending_actions
          if (from < 2) {
            await m.createTable(pendingActionsTable);
          }
        },
        beforeOpen: (details) async {
          // Active les foreign keys (bonne pratique SQLite)
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cliceat_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
