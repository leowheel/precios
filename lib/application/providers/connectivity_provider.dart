import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/connectivity_service.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  return ConnectivityService.connectivityStream;
});

final isOnlineProvider = Provider<bool>((ref) {
  return ConnectivityService.isOnline;
});