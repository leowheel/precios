import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvDebug {
  static void printEnvironmentStatus() {
    debugPrint('🔍 === DEBUG VARIABLES DE ENTORNO ===');
    
    // Verificar si dotenv está cargado
    debugPrint('📋 Variables cargadas en dotenv:');
    if (dotenv.env.isEmpty) {
      debugPrint('❌ No hay variables de entorno cargadas');
    } else {
      debugPrint('✅ ${dotenv.env.length} variables encontradas');
      for (final entry in dotenv.env.entries) {
        if (entry.key.contains('KEY') || entry.key.contains('SECRET')) {
          debugPrint('   ${entry.key}: ${entry.value.substring(0, 10)}...');
        } else {
          debugPrint('   ${entry.key}: ${entry.value}');
        }
      }
    }
    
    // Verificar variables específicas
    debugPrint('\n🔍 Variables específicas de Supabase:');
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];
    
    debugPrint('SUPABASE_URL: ${supabaseUrl ?? "❌ NO ENCONTRADA"}');
    debugPrint('SUPABASE_ANON_KEY: ${supabaseKey != null ? "✅ ENCONTRADA (${supabaseKey.substring(0, 10)}...)" : "❌ NO ENCONTRADA"}');
    
    debugPrint('🔍 ==========================================');
  }
}