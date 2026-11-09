import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroazul_app/core/database/app_database.dart';
import 'package:neuroazul_app/core/database/local_profile_repository.dart';

void main() {
  late AppDatabase database;
  late LocalProfileRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());

    repository = LocalProfileRepository(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  group('LocalProfileRepository', () {
    test('guarda un perfil infantil en la caché local', () async {
      await repository.cacheProfile(
        profileId: 'profile-1',
        adultId: 'adult-1',
        alias: 'Azul',
        ageRange: '6-8',
        avatarKey: 'explorer',
      );

      final profile = await repository.getProfileById(profileId: 'profile-1');

      expect(profile, isNotNull);
      expect(profile!.profileId, 'profile-1');
      expect(profile.adultId, 'adult-1');
      expect(profile.alias, 'Azul');
      expect(profile.ageRange, '6-8');
      expect(profile.avatarKey, 'explorer');
    });

    test('recupera correctamente un perfil por su identificador', () async {
      await repository.cacheProfile(
        profileId: 'profile-2',
        adultId: 'adult-1',
        alias: 'Estrella',
        ageRange: '9-10',
      );

      final profile = await repository.getProfileById(profileId: 'profile-2');

      expect(profile, isNotNull);
      expect(profile!.alias, 'Estrella');
      expect(profile.ageRange, '9-10');
      expect(profile.avatarKey, isNull);
    });

    test('filtra los perfiles según el adulto responsable', () async {
      await repository.cacheProfile(
        profileId: 'profile-1',
        adultId: 'adult-1',
        alias: 'Carlos',
        ageRange: '6-8',
      );

      await repository.cacheProfile(
        profileId: 'profile-2',
        adultId: 'adult-1',
        alias: 'Ana',
        ageRange: '9-10',
      );

      await repository.cacheProfile(
        profileId: 'profile-3',
        adultId: 'adult-2',
        alias: 'Pedro',
        ageRange: '11-12',
      );

      final adultOneProfiles = await repository.getProfilesForAdult(
        adultId: 'adult-1',
      );

      final adultTwoProfiles = await repository.getProfilesForAdult(
        adultId: 'adult-2',
      );

      expect(adultOneProfiles.length, 2);
      expect(adultTwoProfiles.length, 1);

      expect(adultOneProfiles.map((profile) => profile.alias).toList(), [
        'Ana',
        'Carlos',
      ]);

      expect(adultTwoProfiles.first.alias, 'Pedro');
    });

    test('actualiza un perfil existente en la caché local', () async {
      await repository.cacheProfile(
        profileId: 'profile-1',
        adultId: 'adult-1',
        alias: 'Azul',
        ageRange: '6-8',
        avatarKey: 'explorer',
      );

      await repository.cacheProfile(
        profileId: 'profile-1',
        adultId: 'adult-1',
        alias: 'Azul actualizado',
        ageRange: '9-10',
        avatarKey: 'star',
      );

      final profile = await repository.getProfileById(profileId: 'profile-1');

      expect(profile, isNotNull);
      expect(profile!.alias, 'Azul actualizado');
      expect(profile.ageRange, '9-10');
      expect(profile.avatarKey, 'star');

      final profiles = await repository.getProfilesForAdult(adultId: 'adult-1');

      expect(profiles.length, 1);
    });

    test('elimina un perfil de la caché local', () async {
      await repository.cacheProfile(
        profileId: 'profile-1',
        adultId: 'adult-1',
        alias: 'Azul',
        ageRange: '6-8',
      );

      var profile = await repository.getProfileById(profileId: 'profile-1');

      expect(profile, isNotNull);

      await repository.deleteProfile(profileId: 'profile-1');

      profile = await repository.getProfileById(profileId: 'profile-1');

      expect(profile, isNull);
    });
  });
}
