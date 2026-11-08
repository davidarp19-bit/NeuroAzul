import 'package:supabase_flutter/supabase_flutter.dart';

class RoutineRepository {
  final SupabaseClient _client;

  RoutineRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<void> registerAttempt({
    required String profileId,
    required String routineId,
    required List<String> selectedOrder,
    required bool isCorrect,
  }) async {
    await _client.from('routine_attempts').insert({
      'profile_id': profileId,
      'routine_id': routineId,
      'selected_order': selectedOrder,
      'is_correct': isCorrect,
    });
  }
}
