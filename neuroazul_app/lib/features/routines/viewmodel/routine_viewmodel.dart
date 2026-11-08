import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/database/database_providers.dart';
import '../data/routine_repository.dart';

class RoutineState {
  final bool isSaving;
  final bool hasPendingSync;
  final String? errorMessage;

  const RoutineState({
    this.isSaving = false,
    this.hasPendingSync = false,
    this.errorMessage,
  });

  RoutineState copyWith({
    bool? isSaving,
    bool? hasPendingSync,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RoutineState(
      isSaving: isSaving ?? this.isSaving,
      hasPendingSync: hasPendingSync ?? this.hasPendingSync,
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
    state = state.copyWith(
      isSaving: true,
      hasPendingSync: false,
      clearError: true,
    );

    try {
      final localRepository = ref.read(localAttemptRepositoryProvider);

      final localId = await localRepository.saveAttempt(
        profileId: profileId,
        activityType: 'routine',
        activityId: routineId,
        selectedValue: jsonEncode(selectedOrder),
        isCorrect: isCorrect,
      );

      try {
        final remoteRepository = ref.read(routineRepositoryProvider);

        await remoteRepository.registerAttempt(
          profileId: profileId,
          routineId: routineId,
          selectedOrder: selectedOrder,
          isCorrect: isCorrect,
        );

        await localRepository.markAsSynced(localId: localId);

        state = state.copyWith(hasPendingSync: false, clearError: true);

        return true;
      } on PostgrestException catch (error) {
        debugPrint(
          'ROUTINE pendiente de sincronización: '
          '${error.message}',
        );

        state = state.copyWith(hasPendingSync: true, clearError: true);

        return true;
      } catch (error) {
        debugPrint(
          'ROUTINE pendiente de sincronización: '
          '$error',
        );

        state = state.copyWith(hasPendingSync: true, clearError: true);

        return true;
      }
    } catch (error, stackTrace) {
      debugPrint('ERROR AL GUARDAR ROUTINE EN DRIFT: $error');

      debugPrintStack(
        label: 'STACK TRACE ROUTINE DRIFT',
        stackTrace: stackTrace,
      );

      state = state.copyWith(
        errorMessage: 'No fue posible guardar la rutina en el dispositivo.',
      );

      return false;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}
