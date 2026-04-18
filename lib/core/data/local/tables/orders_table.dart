import 'package:drift/drift.dart';

/// Table to store order history for offline access.
class OrdersTable extends Table {
  TextColumn get id => text()();
  TextColumn get restaurantId => text().nullable()();
  TextColumn get restaurantName => text().nullable()();
  
  // JSON encoded list of OrderItemModel
  TextColumn get itemsJson => text()(); 
  
  RealColumn get total => real()();
  RealColumn get deliveryFee => real().nullable()();
  TextColumn get status => text()();
  
  TextColumn get paymentMethod => text().nullable()();
  
  // JSON encoded AddressModel
  TextColumn get deliveryAddressJson => text().nullable()(); 
  
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  RealColumn get rating => real().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}
