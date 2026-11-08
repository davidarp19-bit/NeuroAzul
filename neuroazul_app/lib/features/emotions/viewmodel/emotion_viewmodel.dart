import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/emotion_repository.dart';

class EmotionState {
  final bool isSaving;
  final String? errorMessage;

  const EmotionState({this.isSaving = false, this.errorMessage});

  EmotionState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EmotionState(
      isSaving: isSaving ?? this.isSaving,
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
    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final repository = ref.read(emotionRepositoryProvider);

      await repository.registerAttempt(
        profileId: profileId,
        questionId: questionId,
        selectedEmotion: selectedEmotion,
        isCorrect: isCorrect,
      );

      return true;
    } on PostgrestException catch (error) {
      state = state.copyWith(errorMessage: error.message);

      return false;
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'No fue posible registrar la respuesta.',
      );

      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
