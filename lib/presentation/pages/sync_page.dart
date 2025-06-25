import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/sync_provider.dart';
import '../../application/providers/connectivity_provider.dart';
import '../../application/providers/app_state_provider.dart';
import '../../core/theme/app_theme.dart';

class SyncPage extends ConsumerWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    final syncAsync = ref.watch(syncAllDataProvider);
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sincronización')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.sync,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          'Sincronizar Datos',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Descarga la información más reciente de productos, marcas, categorías y precios desde el servidor.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Connection Status
                    connectivityAsync.when(
                      data: (isOnline) => _ConnectionStatus(isOnline: isOnline),
                      loading: () => const _ConnectionStatus(isOnline: null),
                      error: (_, __) =>
                          const _ConnectionStatus(isOnline: false),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Sync Status
                    if (appState.lastSyncTime != null) ...[
                      Text(
                        'Última sincronización:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _formatDateTime(appState.lastSyncTime!),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Sync Button
                    syncAsync.when(
                      data: (_) {
                        debugPrint('✅ Sincronización completada exitosamente');
                        return FilledButton.icon(
                          onPressed: connectivityAsync.maybeWhen(
                            data: (isOnline) => isOnline
                                ? () {
                                    debugPrint(
                                      '🔄 Iniciando sincronización...',
                                    );
                                    ref.refresh(syncAllDataProvider);
                                  }
                                : null,
                            orElse: () => null,
                          ),
                          icon: const Icon(Icons.sync),
                          label: const Text('Sincronizar Ahora'),
                        );
                      },
                      loading: () {
                        debugPrint('⏳ Sincronización en progreso...');
                        return FilledButton.icon(
                          onPressed: null,
                          icon: const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          label: const Text('Sincronizando...'),
                        );
                      },
                      error: (error, stackTrace) {
                        debugPrint('❌ Error de sincronización: $error');
                        debugPrint('Stack trace: $stackTrace');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onErrorContainer,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Error de sincronización',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onErrorContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          error.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onErrorContainer,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            FilledButton.icon(
                              onPressed: connectivityAsync.maybeWhen(
                                data: (isOnline) => isOnline
                                    ? () {
                                        debugPrint(
                                          '🔄 Reintentando sincronización...',
                                        );
                                        ref.refresh(syncAllDataProvider);
                                      }
                                    : null,
                                orElse: () => null,
                              ),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reintentar'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Info Cards
            Expanded(
              child: ListView(
                children: [
                  _InfoCard(
                    icon: Icons.local_offer,
                    title: 'Marcas',
                    description: 'Información de todas las marcas disponibles',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _InfoCard(
                    icon: Icons.category,
                    title: 'Categorías',
                    description: 'Categorías y subcategorías de productos',
                    color: Colors.green,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _InfoCard(
                    icon: Icons.inventory_2,
                    title: 'Productos',
                    description: 'Catálogo completo de productos con detalles',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _InfoCard(
                    icon: Icons.attach_money,
                    title: 'Precios',
                    description: 'Listas de precios actualizadas',
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Hace un momento';
    }
  }
}

class _ConnectionStatus extends StatelessWidget {
  final bool? isOnline;

  const _ConnectionStatus({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String status;
    Color color;

    if (isOnline == null) {
      icon = Icons.help_outline;
      status = 'Verificando conexión...';
      color = Colors.grey;
    } else if (isOnline!) {
      icon = Icons.wifi;
      status = 'Conectado a Internet';
      color = Colors.green;
    } else {
      icon = Icons.wifi_off;
      status = 'Sin conexión a Internet';
      color = Colors.red;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Text(
          status,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
