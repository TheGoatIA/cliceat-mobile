import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables/user_prefs_table.dart';
import 'tables/restaurants_table.dart';
import 'tables/cart_table.dart';
import 'tables/pending_actions_table.dart';
import 'tables/favorites_table.dart';
import 'tables/offline_actions_table.dart';

import 'tables/menu_items_table.dart';
import 'tables/conversations_table.dart';
import 'tables/messages_table.dart';
import 'tables/orders_table.dart';

import 'daos/menu_dao.dart';
import 'daos/chat_dao.dart';
import 'daos/pending_actions_dao.dart';
import 'daos/cart_dao.dart';
import 'daos/restaurant_dao.dart';
import 'daos/user_prefs_dao.dart';
import 'daos/order_dao.dart';
import 'daos/favorites_dao.dart';
import 'daos/offline_queue_dao.dart';

import '../../../features/client/ai/data/local/ai_tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    UserPrefsTable,
    RestaurantsTable,
    CartTable,
    PendingActionsTable,
    MenuItemsTable,
    ConversationsTable,
    MessagesTable,
    OrdersTable,
    FavoritesTable,
    OfflineActionsTable,
    AiConversationsTable,
    AiMessagesTable,
  ],
  daos: [
    CartDao,
    RestaurantDao,
    UserPrefsDao,
    MenuDao,
    ChatDao,
    PendingActionsDao,
    OrderDao,
    FavoritesDao,
    OfflineQueueDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructeur pour les tests en mémoire.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(pendingActionsTable);
      }
      if (from < 3) {
        await m.createTable(menuItemsTable);
        await m.createTable(conversationsTable);
        await m.createTable(messagesTable);
      }
      if (from < 4) {
        await m.addColumn(messagesTable, messagesTable.status);
      }
      if (from < 5) {
        await m.createTable(ordersTable);
      }
      if (from < 6) {
        await m.addColumn(userPrefsTable, userPrefsTable.isDarkMode);
      }
      if (from < 7) {
        await m.createTable(favoritesTable);
      }
      if (from < 8) {
        // Persistance de la file d'attente hors-ligne avec gestion des retries
        // et statuts ('pending' | 'processing' | 'failed').
        await m.createTable(offlineActionsTable);
      }
      if (from < 9) {
        await customStatement('''
          CREATE TABLE IF NOT EXISTS ai_conversations_table (
            id TEXT NOT NULL PRIMARY KEY,
            server_id TEXT,
            title TEXT NOT NULL DEFAULT 'Nouvelle conversation',
            last_message_at INTEGER NOT NULL,
            created_at INTEGER NOT NULL,
            is_synced INTEGER NOT NULL DEFAULT 0,
            is_archived INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await customStatement('''
          CREATE TABLE IF NOT EXISTS ai_messages_table (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            conversation_id TEXT NOT NULL REFERENCES ai_conversations_table(id),
            role TEXT NOT NULL,
            content TEXT NOT NULL,
            token_count INTEGER,
            created_at INTEGER NOT NULL,
            is_synced INTEGER NOT NULL DEFAULT 0
          )
        ''');
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
