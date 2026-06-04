import 'package:drift/drift.dart';

/// Table des actions en attente de synchronisation (mode hors-ligne).
///
/// Chaque ligne représente une opération qui n'a pas pu être envoyée
/// au serveur faute de réseau, et qui sera rejouée dès le retour en ligne.
class PendingActionsTable extends Table {
  @override
  String get tableName => 'pending_actions';

  /// Identifiant unique de l'action (UUID générée localement).
  TextColumn get id => text()();

  /// Type d'action : 'create_order' | 'cancel_order' | 'rate_order' | etc.
  TextColumn get type => text()();

  /// Payload JSON sérialisé à envoyer.
  TextColumn get payload => text()();

  /// Nombre de tentatives d'envoi déjà effectuées.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// Date de création de l'action (pour trier / expirer les vieilles actions).
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
