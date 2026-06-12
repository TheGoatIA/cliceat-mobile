import 'package:drift/drift.dart';

/// Table de persistance des actions hors-ligne dans la file d'attente.
///
/// Étend la couverture de [PendingActionsTable] en ajoutant :
///   - [maxRetries] : nombre maximum de tentatives configurables par action
///   - [status]     : état de traitement ('pending' | 'processing' | 'failed')
///
/// Types d'actions supportées :
///   'send_chat' | 'create_review' | 'update_profile' | 'toggle_favorite'
///   'place_order' | 'apply_coupon' | 'add_to_cart'
class OfflineActionsTable extends Table {
  @override
  String get tableName => 'offline_actions';

  IntColumn get id => integer().autoIncrement()();

  /// Type d'action — identifie le handler dans SyncManagerService.
  TextColumn get actionType => text()();

  /// Payload JSON sérialisé contenant les données de l'action.
  TextColumn get payload => text()();

  /// Nombre de tentatives déjà effectuées.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// Nombre maximum de tentatives avant marquage 'failed'.
  IntColumn get maxRetries => integer().withDefault(const Constant(3))();

  /// Date de création de l'entrée.
  DateTimeColumn get createdAt => dateTime()();

  /// Statut de l'action : 'pending' | 'processing' | 'failed'.
  TextColumn get status => text().withDefault(const Constant('pending'))();
}
