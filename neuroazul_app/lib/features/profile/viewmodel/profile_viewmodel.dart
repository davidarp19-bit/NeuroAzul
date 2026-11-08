import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/database/database_providers.dart';

import '../data/child_profile.dart';
import '../data/profile_repository.dart';

class ProfileState {
  final List<ChildProfile> profiles;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.profiles = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    List<ChildProfile>? profiles,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final localRepository = ref.watch(localProfileRepositoryProvider);

  return ProfileRepository(localRepository: localRepository);
});

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(ProfileViewModel.new);

class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }

  Future<ChildProfile?> getProfileById(String profileId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(profileRepositoryProvider);

      final profile = await repository.getProfileById(profileId);

      return profile;
    } on PostgrestException catch (error) {
      state = state.copyWith(errorMessage: error.message);

      return null;
    } catch (_) {
      state = state.copyWith(errorMessage: 'No fue posible cargar el perfil.');

      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadProfiles() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(profileRepositoryProvider);

      final profiles = await repository.getProfiles();

      state = state.copyWith(profiles: profiles);
    } on PostgrestException catch (error) {
      state = state.copyWith(errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'No fue posible cargar los perfiles.',
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> createProfile({
    required String alias,
    required String ageRange,
    String? avatarKey,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(profileRepositoryProvider);

      final newProfile = await repository.createProfile(
        alias: alias,
        ageRange: ageRange,
        avatarKey: avatarKey,
      );

      state = state.copyWith(profiles: [...state.profiles, newProfile]);

      return true;
    } on PostgrestException catch (error) {
      state = state.copyWith(errorMessage: error.message);

      return false;
    } on AuthException catch (error) {
      state = state.copyWith(errorMessage: error.message);

      return false;
    } catch (_) {
      state = state.copyWith(errorMessage: 'No fue posible crear el perfil.');

      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> updateProfile({
    required String profileId,
    required String alias,
    required String ageRange,
    String? avatarKey,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(profileRepositoryProvider);

      final updatedProfile = await repository.updateProfile(
        profileId: profileId,
        alias: alias,
        ageRange: ageRange,
        avatarKey: avatarKey,
      );

      final updatedProfiles = state.profiles.map((profile) {
        if (profile.id == profileId) {
          return updatedProfile;
        }

        return profile;
      }).toList();

      state = state.copyWith(profiles: updatedProfiles);

      return true;
    } on PostgrestException catch (error) {
      state = state.copyWith(errorMessage: error.message);

      return false;
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'No fue posible actualizar el perfil.',
      );

      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> deleteProfile(String profileId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repository = ref.read(profileRepositoryProvider);

      await repository.deleteProfile(profileId);

      state = state.copyWith(
        profiles: state.profiles
            .where((profile) => profile.id != profileId)
            .toList(),
      );

      return true;
    } on PostgrestException catch (error) {
      state = state.copyWith(errorMessage: error.message);

      return false;
    } catch (_) {
      state = state.copyWith(
        errorMessage: 'No fue posible eliminar el perfil.',
      );

      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
