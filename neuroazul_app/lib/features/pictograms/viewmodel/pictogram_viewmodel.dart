import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/pictogram_repository.dart';

class PictogramState {
  final bool isSaving;
  final String? errorMessage;

  const PictogramState({this.isSaving = false, this.errorMessage});

  PictogramState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PictogramState(
      isSaving: isSaving ?? this.isSaving,
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
    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final repository = ref.read(pictogramRepositoryProvider);

      await repository.registerAttempt(
        profileId: profileId,
        questionId: questionId,
        selectedId: selectedId,
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
