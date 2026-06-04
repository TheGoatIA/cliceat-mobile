import 'package:drift/drift.dart';

class UserPrefsTable extends Table {
  TextColumn get userId => text()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get language => text().withDefault(const Constant('fr'))();

  // Client specific
  IntColumn get loyaltyPoints => integer().withDefault(const Constant(0))();
  RealColumn get walletBalance => real().withDefault(const Constant(0.0))();

  // Delivery specific
  TextColumn get vehicleType => text().nullable()();
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();

  // Shared
  TextColumn get currentMode =>
      text().withDefault(const Constant('client'))(); // 'client' or 'delivery'
  TextColumn get fcmToken => text().nullable()();
  BoolColumn get isDarkMode => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}
