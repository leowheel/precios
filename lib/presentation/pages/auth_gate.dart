import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'modern_home_page.dart';
import 'login_page.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el estado de autenticación
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      data: (user) {
        // Si el usuario existe, muestra HomePage. Si no, LoginPage.
        if (user != null) {
          return const ModernHomePage();
        } else {
          return const LoginPage();
        }
      },
      // Muestra una pantalla de carga mientras se determina el estado
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Verificando sesión...'),
            ],
          ),
        ),
      ),
      // Muestra la LoginPage en caso de error (p.ej. sin conexión)
      error: (error, stackTrace) {
        debugPrint('Error en AuthGate: $error');
        // Si hay un error, lo más seguro es llevar al Login
        return const LoginPage();
      },
    );
  }
}
