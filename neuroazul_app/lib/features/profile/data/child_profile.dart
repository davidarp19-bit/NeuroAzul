class ChildProfile {
  final String id;
  final String adultId;
  final String alias;
  final String ageRange;
  final String? avatarKey;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildProfile({
    required this.id,
    required this.adultId,
    required this.alias,
    required this.ageRange,
    this.avatarKey,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildProfile.fromMap(
    Map<String, dynamic> map,
  ) {
    return ChildProfile(
      id: map['id'] as String,
      adultId: map['adult_id'] as String,
      alias: map['alias'] as String,
      ageRange: map['age_range'] as String,
      avatarKey: map['avatar_key'] as String?,
      createdAt:
          DateTime.parse(map['created_at'] as String),
      updatedAt:
          DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adult_id': adultId,
      'alias': alias,
      'age_range': ageRange,
      'avatar_key': avatarKey,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}