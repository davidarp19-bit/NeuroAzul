import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/local_profile_repository.dart';
import 'child_profile.dart';

class ProfileRepository {
  final SupabaseClient _client;
  final LocalProfileRepository _localRepository;

  ProfileRepository({
    required LocalProfileRepository localRepository,
    SupabaseClient? client,
  }) : _localRepository = localRepository,
       _client = client ?? Supabase.instance.client;

  User _requireCurrentUser() {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    return user;
  }

  Future<List<ChildProfile>> getProfiles() async {
    final user = _requireCurrentUser();

    try {
      final response = await _client
          .from('child_profiles')
          .select()
          .order('created_at');

      final profiles = response
          .map<ChildProfile>((row) => ChildProfile.fromMap(row))
          .toList();

      for (final profile in profiles) {
        await _cacheProfile(profile);
      }

      return profiles;
    } catch (_) {
      final localProfiles = await _localRepository.getProfilesForAdult(
        adultId: user.id,
      );

      return localProfiles.map(_childProfileFromLocal).toList();
    }
  }

  Future<ChildProfile> getProfileById(String profileId) async {
    try {
      final response = await _client
          .from('child_profiles')
          .select()
          .eq('id', profileId)
          .single();

      final profile = ChildProfile.fromMap(response);

      await _cacheProfile(profile);

      return profile;
    } catch (_) {
      final localProfile = await _localRepository.getProfileById(
        profileId: profileId,
      );

      if (localProfile == null) {
        throw Exception('No fue posible obtener el perfil.');
      }

      return _childProfileFromLocal(localProfile);
    }
  }

  Future<ChildProfile> createProfile({
    required String alias,
    required String ageRange,
    String? avatarKey,
  }) async {
    final user = _requireCurrentUser();

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

    final profile = ChildProfile.fromMap(response);

    await _cacheProfile(profile);

    return profile;
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
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', profileId)
        .select()
        .single();

    final profile = ChildProfile.fromMap(response);

    await _cacheProfile(profile);

    return profile;
  }

  Future<void> deleteProfile(String profileId) async {
    await _client.from('child_profiles').delete().eq('id', profileId);

    await _localRepository.deleteProfile(profileId: profileId);
  }

  Future<void> _cacheProfile(ChildProfile profile) async {
    await _localRepository.cacheProfile(
      profileId: profile.id,
      adultId: profile.adultId,
      alias: profile.alias,
      ageRange: profile.ageRange,
      avatarKey: profile.avatarKey,
    );
  }

  ChildProfile _childProfileFromLocal(LocalChildProfile profile) {
    return ChildProfile(
      id: profile.profileId,
      adultId: profile.adultId,
      alias: profile.alias,
      ageRange: profile.ageRange,
      avatarKey: profile.avatarKey,
      createdAt: profile.updatedAt,
      updatedAt: profile.updatedAt,
    );
  }
}
