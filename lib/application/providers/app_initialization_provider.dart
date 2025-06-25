import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sync_provider.dart';
import 'connectivity_provider.dart';

final appInitializationProvider = FutureProvider<void>((ref) async {
  debugPrint('🚀 Iniciando inicialización de la aplicación...');
  
  try {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('first_run') ?? true;
    
    if (isFirstRun) {
      debugPrint('🆕 Primera ejecución detectada');
      
      // Verificar conectividad usando el servicio directamente
      final connectivityService = await Future.microtask(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return ref.read(isOnlineProvider);
      });
      
      if (connectivityService) {
        debugPrint('🌐 Conexión disponible, iniciando sincronización inicial...');
        
        try {
          // Crear una nueva instancia del provider para evitar dependencias circulares
          final syncProvider = ref.read(syncAllDataProvider.future);
          await syncProvider;
          
          // Marcar como no primera ejecución
          await prefs.setBool('first_run', false);
          debugPrint('✅ Sincronización inicial completada');
        } catch (e) {
          debugPrint('❌ Error en sincronización inicial: $e');
          // Permitir continuar sin sincronización en primer arranque
          await prefs.setBool('first_run', false);
        }
      } else {
        debugPrint('❌ No hay conexión para sincronización inicial');
        // Marcar como inicializado para permitir uso offline
        await prefs.setBool('first_run', false);
      }
    } else {
      debugPrint('✅ Aplicación ya inicializada previamente');
    }
    
    debugPrint('🎉 Inicialización de aplicación completada');
  } catch (e) {
    debugPrint('❌ Error durante inicialización: $e');
    // Permitir continuar incluso si hay errores
  }
});