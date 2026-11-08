import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/routine_repository.dart';

class RoutineState {
  final bool isSaving;
  final String? errorMessage;

  const RoutineState({this.isSaving = false, this.errorMessage});

  RoutineState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RoutineState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository();
});

final routineViewModelProvider =
    NotifierProvider<RoutineViewModel, RoutineState>(RoutineViewModel.new);

class RoutineViewModel extends Notifier<RoutineState> {
  @override
  RoutineState build() {
    return const RoutineState();
  }

  Future<bool> registerAttempt({
    required String profileId,
    required String routineId,
    required List<String> selectedOrder,
    required bool isCorrect,
  }) async {
    state = state.copyWith(isSaving: true, clearError: true);

    try {
      final repository = ref.read(routineRepositoryProvider);

      await repository.registerAttempt(
        profileId: profileId,
        routineId: routineId,
        selectedOrder: selectedOrder,
        isCorrect: isCorrect,
      );

      return true;
    } on PostgrestException catch (error) {
      state = state.copyWith(errorMessage: error.message);

      return false;
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'No fue posible registrar el intento de la rutina.',
      );

      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
