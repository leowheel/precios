import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvValidator {
  static void validateEnvironment() {
    debugPrint('🔍 Validando variables de entorno...');

    final requiredVars = ['SUPABASE_URL', 'SUPABASE_ANON_KEY'];
    final missingVars = <String>[];

    for (final varName in requiredVars) {
      if (!dotenv.env.containsKey(varName) || dotenv.env[varName]!.isEmpty) {
        missingVars.add(varName);
      }
    }

    if (missingVars.isNotEmpty) {
      debugPrint('❌ Variables de entorno faltantes: ${missingVars.join(', ')}');
      debugPrint(
        '⚠️ Asegúrate de que el archivo .env contiene todas las variables requeridas',
      );

      if (kDebugMode) {
        debugPrint('📝 Variables de entorno cargadas:');
        for (final entry in dotenv.env.entries) {
          if (entry.key.contains('KEY') || entry.key.contains('SECRET')) {
            debugPrint('  ${entry.key}: ${entry.value.substring(0, 10)}...');
          } else {
            debugPrint('  ${entry.key}: ${entry.value}');
          }
        }
      }
    } else {
      debugPrint(
        '✅ Todas las variables de entorno requeridas están configuradas',
      );
    }
  }

  static bool get isConfigured {
    return dotenv.env.containsKey('SUPABASE_URL') &&
        dotenv.env.containsKey('SUPABASE_ANON_KEY') &&
        dotenv.env['SUPABASE_URL']!.isNotEmpty &&
        dotenv.env['SUPABASE_ANON_KEY']!.isNotEmpty;
  }
}
