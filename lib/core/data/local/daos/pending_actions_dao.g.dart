// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_actions_dao.dart';

// ignore_for_file: type=lint
mixin _$PendingActionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PendingActionsTableTable get pendingActionsTable =>
      attachedDatabase.pendingActionsTable;
  PendingActionsDaoManager get managers => PendingActionsDaoManager(this);
}

class PendingActionsDaoManager {
  final _$PendingActionsDaoMixin _db;
  PendingActionsDaoManager(this._db);
  $$PendingActionsTableTableTableManager get pendingActionsTable =>
      $$PendingActionsTableTableTableManager(
        _db.attachedDatabase,
        _db.pendingActionsTable,
      );
}
