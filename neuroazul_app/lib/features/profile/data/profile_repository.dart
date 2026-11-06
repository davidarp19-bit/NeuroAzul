import 'package:supabase_flutter/supabase_flutter.dart';

import 'child_profile.dart';

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  Future<List<ChildProfile>> getProfiles() async {
    final response = await _client
        .from('child_profiles')
        .select()
        .order('created_at');

    return (response as List)
        .map(
          (item) => ChildProfile.fromMap(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<ChildProfile> createProfile({
    required String alias,
    required String ageRange,
    String? avatarKey,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const AuthException(
        'No hay un usuario autenticado.',
      );
    }

    final response = await _client
        .from('child_profiles')
        .insert({
          'adult_id': user.id,
          'alias': alias.trim(),
          'age_range': ageRange,
          'avatar_key': avatarKey,
        })
        .select()
        .single();

    return ChildProfile.fromMap(response);
  }

  Future<ChildProfile> updateProfile({
    required String profileId,
    required String alias,
    required String ageRange,
    String? avatarKey,
  }) async {
    final response = await _client
        .from('child_profiles')
        .update({
          'alias': alias.trim(),
          'age_range': ageRange,
          'avatar_key': avatarKey,
          'updated_at':
              DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', profileId)
        .select()
        .single();

    return ChildProfile.fromMap(response);
  }

  Future<void> deleteProfile(String profileId) async {
    await _client
        .from('child_profiles')
        .delete()
        .eq('id', profileId);
  }
}