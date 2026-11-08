import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/profile_progress.dart';
import '../data/progress_repository.dart';

class ProgressState {
  final bool isLoading;
  final ProfileProgress? progress;
  final String? errorMessage;

  const ProgressState({
    this.isLoading = false,
    this.progress,
    this.errorMessage,
  });

  ProgressState copyWith({
    bool? isLoading,
    ProfileProgress? progress,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProgressState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository();
});

final progressViewModelProvider =
    NotifierProvider<ProgressViewModel, ProgressState>(ProgressViewModel.new);

class ProgressViewModel extends Notifier<ProgressState> {
  @override
  ProgressState build() {
    return const ProgressState();
  }

  Future<void> loadProgress({required String profileId}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(progressRepositoryProvider);

      final progress = await repository.getProgress(profileId: profileId);

      state = state.copyWith(progress: progress);
    } on PostgrestException catch (error) {
      state = state.copyWith(errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'No fue posible cargar el progreso del perfil.',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshProgress({required String profileId}) async {
    await loadProgress(profileId: profileId);
  }
}
