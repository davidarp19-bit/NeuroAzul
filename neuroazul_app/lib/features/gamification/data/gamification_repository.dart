import 'package:supabase_flutter/supabase_flutter.dart';

import 'gamification_progress.dart';

class GamificationRepository {
  final SupabaseClient _client;

  GamificationRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<GamificationProgress> getProgress({required String profileId}) async {
    final pictogramRows = await _client
        .from('pictogram_attempts')
        .select('question_id')
        .eq('profile_id', profileId)
        .eq('is_correct', true);

    final emotionRows = await _client
        .from('emotion_attempts')
        .select('question_id')
        .eq('profile_id', profileId)
        .eq('is_correct', true);

    final routineRows = await _client
        .from('routine_attempts')
        .select('routine_id')
        .eq('profile_id', profileId)
        .eq('is_correct', true);

    final pictogramIds = pictogramRows
        .map<String>((row) => row['question_id'] as String)
        .toSet();

    final emotionIds = emotionRows
        .map<String>((row) => row['question_id'] as String)
        .toSet();

    final routineIds = routineRows
        .map<String>((row) => row['routine_id'] as String)
        .toSet();

    final completedPictograms = pictogramIds.length;

    final completedEmotions = emotionIds.length;

    final completedRoutines = routineIds.length;

    return GamificationProgress(
      pictogramPoints: completedPictograms * 10,
      emotionPoints: completedEmotions * 10,
      routinePoints: completedRoutines * 20,
      completedPictograms: completedPictograms,
      completedEmotions: completedEmotions,
      completedRoutines: completedRoutines,
    );
  }
}
