import 'package:supabase_flutter/supabase_flutter.dart';

class PictogramRepository {
  final SupabaseClient _client;

  PictogramRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<void> registerAttempt({
    required String profileId,
    required String questionId,
    required String selectedId,
    required bool isCorrect,
  }) async {
    await _client.from('pictogram_attempts').insert({
      'profile_id': profileId,
      'question_id': questionId,
      'selected_id': selectedId,
      'is_correct': isCorrect,
    });
  }
}
