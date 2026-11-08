import 'package:supabase_flutter/supabase_flutter.dart';

class EmotionRepository {
  final SupabaseClient _client;

  EmotionRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<void> registerAttempt({
    required String profileId,
    required String questionId,
    required String selectedEmotion,
    required bool isCorrect,
  }) async {
    await _client.from('emotion_attempts').insert({
      'profile_id': profileId,
      'question_id': questionId,
      'selected_emotion': selectedEmotion,
      'is_correct': isCorrect,
    });
  }
}
