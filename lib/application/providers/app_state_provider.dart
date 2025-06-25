import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class AppState {
  final AppStateStatus status;
  final String? errorMessage;
  final bool isOnline;
  final bool isSyncing;
  final DateTime? lastSyncTime;

  const AppState({
    this.status = AppStateStatus.initial,
    this.errorMessage,
    this.isOnline = false,
    this.isSyncing = false,
    this.lastSyncTime,
  });

  AppState copyWith({
    AppStateStatus? status,
    String? errorMessage,
    bool? isOnline,
    bool? isSyncing,
    DateTime? lastSyncTime,
  }) {
    return AppState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setLoading() {
    state = state.copyWith(status: AppStateStatus.loading);
  }

  void setLoaded() {
    state = state.copyWith(status: AppStateStatus.loaded);
  }

  void setError(String error) {
    state = state.copyWith(
      status: AppStateStatus.error,
      errorMessage: error,
    );
  }

  void setOnlineStatus(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }

  void setSyncing(bool isSyncing) {
    state = state.copyWith(isSyncing: isSyncing);
  }

  void setSyncCompleted() {
    state = state.copyWith(
      isSyncing: false,
      lastSyncTime: DateTime.now(),
    );
  }
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});