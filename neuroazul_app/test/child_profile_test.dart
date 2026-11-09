import 'package:flutter_test/flutter_test.dart';
import 'package:neuroazul_app/features/profile/data/child_profile.dart';

void main() {
  group('ChildProfile', () {
    test('crea correctamente un perfil desde un mapa', () {
      final profile = ChildProfile.fromMap({
        'id': 'profile-1',
        'adult_id': 'adult-1',
        'alias': 'Azul',
        'age_range': '6-8',
        'avatar_key': 'explorer',
        'created_at': '2026-01-10T10:00:00.000Z',
        'updated_at': '2026-01-11T12:30:00.000Z',
      });

      expect(profile.id, 'profile-1');
      expect(profile.adultId, 'adult-1');
      expect(profile.alias, 'Azul');
      expect(profile.ageRange, '6-8');
      expect(profile.avatarKey, 'explorer');
      expect(profile.createdAt, DateTime.parse('2026-01-10T10:00:00.000Z'));
      expect(profile.updatedAt, DateTime.parse('2026-01-11T12:30:00.000Z'));
    });

    test('permite un avatar nulo', () {
      final profile = ChildProfile.fromMap({
        'id': 'profile-2',
        'adult_id': 'adult-1',
        'alias': 'Estrella',
        'age_range': '9-10',
        'avatar_key': null,
        'created_at': '2026-02-01T08:00:00.000Z',
        'updated_at': '2026-02-01T08:00:00.000Z',
      });

      expect(profile.avatarKey, isNull);
    });

    test('convierte correctamente un perfil a mapa', () {
      final createdAt = DateTime.parse('2026-03-01T10:00:00.000Z');

      final updatedAt = DateTime.parse('2026-03-02T11:00:00.000Z');

      final profile = ChildProfile(
        id: 'profile-3',
        adultId: 'adult-2',
        alias: 'Aventura',
        ageRange: '11-12',
        avatarKey: 'star',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final map = profile.toMap();

      expect(map['id'], 'profile-3');
      expect(map['adult_id'], 'adult-2');
      expect(map['alias'], 'Aventura');
      expect(map['age_range'], '11-12');
      expect(map['avatar_key'], 'star');
      expect(map['created_at'], createdAt.toIso8601String());
      expect(map['updated_at'], updatedAt.toIso8601String());
    });

    test('conserva los datos en conversión mapa perfil mapa', () {
      final originalMap = <String, dynamic>{
        'id': 'profile-4',
        'adult_id': 'adult-3',
        'alias': 'Explorador',
        'age_range': '6-8',
        'avatar_key': 'adventure',
        'created_at': '2026-04-01T09:00:00.000Z',
        'updated_at': '2026-04-02T10:00:00.000Z',
      };

      final profile = ChildProfile.fromMap(originalMap);

      final result = profile.toMap();

      expect(result['id'], originalMap['id']);
      expect(result['adult_id'], originalMap['adult_id']);
      expect(result['alias'], originalMap['alias']);
      expect(result['age_range'], originalMap['age_range']);
      expect(result['avatar_key'], originalMap['avatar_key']);

      expect(
        DateTime.parse(result['created_at'] as String),
        DateTime.parse(originalMap['created_at'] as String),
      );

      expect(
        DateTime.parse(result['updated_at'] as String),
        DateTime.parse(originalMap['updated_at'] as String),
      );
    });

    test('mantiene independientes las fechas de creación y actualización', () {
      final profile = ChildProfile.fromMap({
        'id': 'profile-5',
        'adult_id': 'adult-4',
        'alias': 'NeuroAzul',
        'age_range': '9-10',
        'avatar_key': null,
        'created_at': '2026-05-01T10:00:00.000Z',
        'updated_at': '2026-05-05T15:00:00.000Z',
      });

      expect(profile.updatedAt.isAfter(profile.createdAt), isTrue);

      expect(profile.createdAt == profile.updatedAt, isFalse);
    });
  });
}
