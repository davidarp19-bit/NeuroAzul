import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_providers.dart';

class SyncState {
  final bool isLoading;
  final bool isSyncing;
  final int pendingCount;
  final String? message;

  const SyncState({
    this.isLoading = false,
    this.isSyncing = false,
    this.pendingCount = 0,
    this.message,
  });

  SyncState copyWith({
    bool? isLoading,
    bool? isSyncing,
    int? pendingCount,
    String? message,
    bool clearMessage = false,
  }) {
    return SyncState(
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      pendingCount: pendingCount ?? this.pendingCount,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}

final syncViewModelProvider = NotifierProvider<SyncViewModel, SyncState>(
  SyncViewModel.new,
);

class SyncViewModel extends Notifier<SyncState> {
  @override
  SyncState build() {
    return const SyncState();
  }

  Future<void> loadPending({String? profileId}) async {
    state = state.copyWith(isLoading: true, clearMessage: true);

    try {
      final service = ref.read(syncServiceProvider);

      final count = await service.getPendingCount(profileId: profileId);

      state = state.copyWith(pendingCount: count);
    } catch (_) {
      state = state.copyWith(
        message: 'No fue posible consultar los intentos pendientes.',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> syncPending({String? profileId}) async {
    state = state.copyWith(isSyncing: true, clearMessage: true);

    try {
      final service = ref.read(syncServiceProvider);

      final synchronized = await service.syncPendingAttempts(
        profileId: profileId,
      );

      final remaining = await service.getPendingCount(profileId: profileId);

      state = state.copyWith(
        pendingCount: remaining,
        message: synchronized > 0
            ? '$synchronized intento(s) sincronizado(s).'
            : remaining == 0
            ? 'Todo está sincronizado.'
            : 'Aún existen intentos pendientes.',
      );
    } catch (_) {
      state = state.copyWith(
        message: 'No fue posible completar la sincronización.',
      );
    } finally {
      state = state.copyWith(isSyncing: false);
    }
  }
}
