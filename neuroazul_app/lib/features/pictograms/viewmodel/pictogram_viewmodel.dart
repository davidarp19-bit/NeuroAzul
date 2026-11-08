import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/database/database_providers.dart';
import '../data/pictogram_repository.dart';

enum AttemptSyncStatus { idle, synced, pending }

class PictogramState {
  final bool isSaving;
  final AttemptSyncStatus syncStatus;
  final String? errorMessage;

  const PictogramState({
    this.isSaving = false,
    this.syncStatus = AttemptSyncStatus.idle,
    this.errorMessage,
  });

  PictogramState copyWith({
    bool? isSaving,
    AttemptSyncStatus? syncStatus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PictogramState(
      isSaving: isSaving ?? this.isSaving,
      syncStatus: syncStatus ?? this.syncStatus,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final pictogramRepositoryProvider = Provider<PictogramRepository>((ref) {
  return PictogramRepository();
});

final pictogramViewModelProvider =
    NotifierProvider<PictogramViewModel, PictogramState>(
      PictogramViewModel.new,
    );

class PictogramViewModel extends Notifier<PictogramState> {
  @override
  PictogramState build() {
    return const PictogramState();
  }

  Future<bool> registerAttempt({
    required String profileId,
    required String questionId,
    required String selectedId,
    required bool isCorrect,
  }) async {
    state = state.copyWith(
      isSaving: true,
      syncStatus: AttemptSyncStatus.idle,
      clearError: true,
    );

    try {
      final localRepository = ref.read(localAttemptRepositoryProvider);

      final localId = await localRepository.saveAttempt(
        profileId: profileId,
        activityType: 'pictogram',
        activityId: questionId,
        selectedValue: selectedId,
        isCorrect: isCorrect,
      );

      try {
        final remoteRepository = ref.read(pictogramRepositoryProvider);

        await remoteRepository.registerAttempt(
          profileId: profileId,
          questionId: questionId,
          selectedId: selectedId,
          isCorrect: isCorrect,
        );

        await localRepository.markAsSynced(localId: localId);

        state = state.copyWith(
          syncStatus: AttemptSyncStatus.synced,
          clearError: true,
        );

        return true;
      } on PostgrestException catch (error) {
        debugPrint('SUPABASE pendiente de sincronización: ${error.message}');

        state = state.copyWith(
          syncStatus: AttemptSyncStatus.pending,
          errorMessage: 'El intento quedó guardado localmente y está pendiente de sincronización.',
        );

        return true;
      } catch (error) {
        debugPrint('CONEXIÓN pendiente de sincronización: $error');

        state = state.copyWith(
          syncStatus: AttemptSyncStatus.pending,
          errorMessage: 'El intento quedó guardado localmente y está pendiente de sincronización.',
        );

        return true;
      }
    } catch (error, stackTrace) {
      debugPrint('ERROR AL GUARDAR EN DRIFT: $error');

      debugPrintStack(label: 'STACK TRACE DRIFT', stackTrace: stackTrace);

      state = state.copyWith(errorMessage: 'Error local: $error');

      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
