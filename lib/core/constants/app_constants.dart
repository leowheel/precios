import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Aplicación
  static String get appName =>
      dotenv.get('APP_NAME', fallback: 'Precios Catálogo');

  // Configuración de Supabase
  static String get supabaseUrl => dotenv.get('SUPABASE_URL');
  static String get supabaseAnonKey => dotenv.get('SUPABASE_ANON_KEY');

  // Nombres de tablas de la base de datos
  static const String brandsTable = 'brands';
  static const String categoriesTable = 'categories';
  static const String subcategoriesTable = 'subcategories';
  static const String suppliersTable = 'suppliers';
  static const String productsTable = 'products';
  static const String priceListsTable = 'price_lists';
  static const String priceListItemsTable = 'price_list_items';

  // Configuración de base de datos local
  static String get localDatabaseName =>
      dotenv.get('DATABASE_NAME', fallback: 'precios_local.db');
  static int get databaseVersion =>
      int.tryParse(dotenv.get('DATABASE_VERSION', fallback: '1')) ?? 1;

  // Configuración de API
  static const int apiTimeoutSeconds = 30;
  static const int retryAttempts = 3;

  // Paginación
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Configuración de imágenes
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];
}
