import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/local/database.dart';

@module
abstract class CoreModule {
  @lazySingleton
  Logger get logger => Logger();

  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
