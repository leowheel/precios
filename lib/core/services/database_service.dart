import '../../data/datasources/local/database/app_database.dart';
import '../../data/datasources/local/local_datasource.dart';

class DatabaseService {
  static AppDatabase? _database;
  static LocalDatasource? _localDatasource;

  static AppDatabase get database {
    _database ??= AppDatabase();
    return _database!;
  }

  static LocalDatasource get localDatasource {
    _localDatasource ??= LocalDatasource(database);
    return _localDatasource!;
  }

  static Future<void> initialize() async {
    // Database will be created automatically when first accessed
    database;
  }

  static Future<void> close() async {
    await _database?.close();
    _database = null;
    _localDatasource = null;
  }

  static Future<void> clearAllData() async {
    await localDatasource.clearAllData();
  }
}