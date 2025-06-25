import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    debugPrint('🔧 Inicializando Supabase...');
    debugPrint('📍 URL: ${AppConstants.supabaseUrl}');
    debugPrint(
      '🔑 Anon Key: ${AppConstants.supabaseAnonKey.substring(0, 20)}...',
    );

    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  static bool get isInitialized {
    try {
      Supabase.instance.client;
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> testConnection() async {
    try {
      final response = await client
          .from(AppConstants.brandsTable)
          .select('id')
          .limit(1);
      return response.isNotEmpty || response.isEmpty;
    } catch (e) {
      return false;
    }
  }
}
