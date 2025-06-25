import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncButton extends ConsumerWidget {
  final FutureProvider<void> syncProvider;

  SyncButton({
    super.key,
    required this.syncProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);

    return syncState.when(
      data: (_) => IconButton(
        onPressed: () => ref.refresh(syncProvider),
        icon: const Icon(Icons.sync),
        tooltip: 'Sincronizar',
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, _) => IconButton(
        onPressed: () => ref.refresh(syncProvider),
        icon: const Icon(Icons.sync_problem),
        tooltip: 'Error al sincronizar. Toca para reintentar.',
      ),
    );
  }
}