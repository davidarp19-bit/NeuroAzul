import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/database/database_providers.dart';
import '../data/emotion_repository.dart';

class EmotionState {
  final bool isSaving;
  final bool hasPendingSync;
  final String? errorMessage;

  const EmotionState({
    this.isSaving = false,
    this.hasPendingSync = false,
    this.errorMessage,
  });

  EmotionState copyWith({
    bool? isSaving,
    bool? hasPendingSync,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EmotionState(
      isSaving: isSaving ?? this.isSaving,
      hasPendingSync: hasPendingSync ?? this.hasPendingSync,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final emotionRepositoryProvider = Provider<EmotionRepository>((ref) {
  return EmotionRepository();
});

final emotionViewModelProvider =
    NotifierProvider<EmotionViewModel, EmotionState>(EmotionViewModel.new);

class EmotionViewModel extends Notifier<EmotionState> {
  @override
  EmotionState build() {
    return const EmotionState();
  }

  Future<bool> registerAttempt({
    required String profileId,
    required String questionId,
    required String selectedEmotion,
    required bool isCorrect,
  }) async {
    state = state.copyWith(
      isSaving: true,
      hasPendingSync: false,
      clearError: true,
    );

    try {
      final localRepository = ref.read(localAttemptRepositoryProvider);

      final localId = await localRepository.saveAttempt(
        profileId: profileId,
        activityType: 'emotion',
        activityId: questionId,
        selectedValue: selectedEmotion,
        isCorrect: isCorrect,
      );

      try {
        final remoteRepository = ref.read(emotionRepositoryProvider);

        await remoteRepository.registerAttempt(
          profileId: profileId,
          questionId: questionId,
          selectedEmotion: selectedEmotion,
          isCorrect: isCorrect,
        );

        await localRepository.markAsSynced(localId: localId);

        state = state.copyWith(hasPendingSync: false, clearError: true);

        return true;
      } on PostgrestException catch (error) {
        debugPrint(
          'EMOTION pendiente de sincronización: '
          '${error.message}',
        );

        state = state.copyWith(hasPendingSync: true, clearError: true);

        return true;
      } catch (error) {
        debugPrint(
          'EMOTION pendiente de sincronización: '
          '$error',
        );

        state = state.copyWith(hasPendingSync: true, clearError: true);

        return true;
      }
    } catch (error, stackTrace) {
      debugPrint('ERROR AL GUARDAR EMOTION EN DRIFT: $error');

      debugPrintStack(
        label: 'STACK TRACE EMOTION DRIFT',
        stackTrace: stackTrace,
      );

      state = state.copyWith(
        errorMessage: 'No fue posible guardar la respuesta en el dispositivo.',
      );

      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
