// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_dao.dart';

// ignore_for_file: type=lint
mixin _$MenuDaoMixin on DatabaseAccessor<AppDatabase> {
  $MenuItemsTableTable get menuItemsTable => attachedDatabase.menuItemsTable;
  MenuDaoManager get managers => MenuDaoManager(this);
}

class MenuDaoManager {
  final _$MenuDaoMixin _db;
  MenuDaoManager(this._db);
  $$MenuItemsTableTableTableManager get menuItemsTable =>
      $$MenuItemsTableTableTableManager(
        _db.attachedDatabase,
        _db.menuItemsTable,
      );
}
