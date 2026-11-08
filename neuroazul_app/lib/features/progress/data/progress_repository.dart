import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_progress.dart';

class ProgressRepository {
  final SupabaseClient _client;

  ProgressRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  Future<ProfileProgress> getProgress({required String profileId}) async {
    final pictogramRows = await _client
        .from('pictogram_attempts')
        .select('question_id, is_correct')
        .eq('profile_id', profileId);

    final emotionRows = await _client
        .from('emotion_attempts')
        .select('question_id, is_correct')
        .eq('profile_id', profileId);

    final routineRows = await _client
        .from('routine_attempts')
        .select('routine_id, is_correct')
        .eq('profile_id', profileId);

    final pictogramAttempts = pictogramRows.length;

    final correctPictograms = pictogramRows
        .where((row) => row['is_correct'] == true)
        .length;

    final emotionAttempts = emotionRows.length;

    final correctEmotions = emotionRows
        .where((row) => row['is_correct'] == true)
        .length;

    final routineAttempts = routineRows.length;

    final correctRoutines = routineRows
        .where((row) => row['is_correct'] == true)
        .length;

    final completedPictogramActivities = pictogramRows
        .where((row) => row['is_correct'] == true)
        .map<String>((row) => row['question_id'] as String)
        .toSet()
        .length;

    final completedEmotionActivities = emotionRows
        .where((row) => row['is_correct'] == true)
        .map<String>((row) => row['question_id'] as String)
        .toSet()
        .length;

    final completedRoutineActivities = routineRows
        .where((row) => row['is_correct'] == true)
        .map<String>((row) => row['routine_id'] as String)
        .toSet()
        .length;

    return ProfileProgress(
      pictogramAttempts: pictogramAttempts,
      correctPictograms: correctPictograms,
      emotionAttempts: emotionAttempts,
      correctEmotions: correctEmotions,
      routineAttempts: routineAttempts,
      correctRoutines: correctRoutines,
      completedPictogramActivities: completedPictogramActivities,
      completedEmotionActivities: completedEmotionActivities,
      completedRoutineActivities: completedRoutineActivities,
    );
  }
}
