import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/gamification_progress.dart';
import '../data/gamification_repository.dart';

class GamificationState {
  final bool isLoading;
  final GamificationProgress? progress;
  final String? errorMessage;

  const GamificationState({
    this.isLoading = false,
    this.progress,
    this.errorMessage,
  });

  GamificationState copyWith({
    bool? isLoading,
    GamificationProgress? progress,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GamificationState(
      isLoading: isLoading ?? this.isLoading,
      progress: progress ?? this.progress,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return GamificationRepository();
});

final gamificationViewModelProvider =
    NotifierProvider<GamificationViewModel, GamificationState>(
      GamificationViewModel.new,
    );

class GamificationViewModel extends Notifier<GamificationState> {
  @override
  GamificationState build() {
    return const GamificationState();
  }

  Future<void> loadProgress({required String profileId}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(gamificationRepositoryProvider);

      final progress = await repository.getProgress(profileId: profileId);

      state = state.copyWith(progress: progress);
    } on PostgrestException catch (error) {
      state = state.copyWith(errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'No fue posible cargar los logros del perfil.',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refreshProgress({required String profileId}) async {
    await loadProgress(profileId: profileId);
  }
}
