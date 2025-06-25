import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'core/services/database_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/utils/env_validator.dart';
import 'core/utils/env_debug.dart';
import 'presentation/pages/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('✅ Variables de entorno cargadas');
    EnvDebug.printEnvironmentStatus();
    EnvValidator.validateEnvironment();
  } catch (e) {
    debugPrint('⚠️ Error cargando variables de entorno: $e');
    debugPrint('La aplicación continuará con valores por defecto');
    EnvDebug.printEnvironmentStatus();
  }

  // Initialize services with error handling
  try {
    // Initialize local database first (most critical)
    await DatabaseService.initialize();
    debugPrint('✅ Database service initialized');
  } catch (e) {
    debugPrint('❌ Database initialization failed: $e');
  }

  try {
    // Initialize connectivity service
    await ConnectivityService.initialize();
    debugPrint('✅ Connectivity service initialized');
  } catch (e) {
    debugPrint('❌ Connectivity initialization failed: $e');
  }

  try {
    // Initialize Supabase
    await SupabaseService.initialize();
    debugPrint('✅ Supabase service initialized');
  } catch (e) {
    debugPrint('❌ Supabase initialization failed: $e');
  }

  runApp(const ProviderScope(child: PreciosApp()));
}

class PreciosApp extends StatelessWidget {
  const PreciosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Precios Catálogo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
