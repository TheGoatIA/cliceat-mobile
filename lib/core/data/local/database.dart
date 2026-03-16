import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables/user_prefs_table.dart';
import 'tables/restaurants_table.dart';
import 'tables/cart_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [UserPrefsTable, RestaurantsTable, CartTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cliceat_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
