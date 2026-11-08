// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalAttemptsTable extends LocalAttempts
    with TableInfo<$LocalAttemptsTable, LocalAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientAttemptIdMeta = const VerificationMeta(
    'clientAttemptId',
  );
  @override
  late final GeneratedColumn<String> clientAttemptId = GeneratedColumn<String>(
    'client_attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityTypeMeta = const VerificationMeta(
    'activityType',
  );
  @override
  late final GeneratedColumn<String> activityType = GeneratedColumn<String>(
    'activity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedValueMeta = const VerificationMeta(
    'selectedValue',
  );
  @override
  late final GeneratedColumn<String> selectedValue = GeneratedColumn<String>(
    'selected_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientAttemptId,
    profileId,
    activityType,
    activityId,
    selectedValue,
    isCorrect,
    createdAt,
    isSynced,
    remoteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_attempt_id')) {
      context.handle(
        _clientAttemptIdMeta,
        clientAttemptId.isAcceptableOrUnknown(
          data['client_attempt_id']!,
          _clientAttemptIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientAttemptIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('activity_type')) {
      context.handle(
        _activityTypeMeta,
        activityType.isAcceptableOrUnknown(
          data['activity_type']!,
          _activityTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityTypeMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('selected_value')) {
      context.handle(
        _selectedValueMeta,
        selectedValue.isAcceptableOrUnknown(
          data['selected_value']!,
          _selectedValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedValueMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientAttemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_attempt_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      activityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_type'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      selectedValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_value'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
    );
  }

  @override
  $LocalAttemptsTable createAlias(String alias) {
    return $LocalAttemptsTable(attachedDatabase, alias);
  }
}

class LocalAttempt extends DataClass implements Insertable<LocalAttempt> {
  final int id;
  final String clientAttemptId;
  final String profileId;
  final String activityType;
  final String activityId;
  final String selectedValue;
  final bool isCorrect;
  final DateTime createdAt;
  final bool isSynced;
  final String? remoteId;
  const LocalAttempt({
    required this.id,
    required this.clientAttemptId,
    required this.profileId,
    required this.activityType,
    required this.activityId,
    required this.selectedValue,
    required this.isCorrect,
    required this.createdAt,
    required this.isSynced,
    this.remoteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_attempt_id'] = Variable<String>(clientAttemptId);
    map['profile_id'] = Variable<String>(profileId);
    map['activity_type'] = Variable<String>(activityType);
    map['activity_id'] = Variable<String>(activityId);
    map['selected_value'] = Variable<String>(selectedValue);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    return map;
  }

  LocalAttemptsCompanion toCompanion(bool nullToAbsent) {
    return LocalAttemptsCompanion(
      id: Value(id),
      clientAttemptId: Value(clientAttemptId),
      profileId: Value(profileId),
      activityType: Value(activityType),
      activityId: Value(activityId),
      selectedValue: Value(selectedValue),
      isCorrect: Value(isCorrect),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
    );
  }

  factory LocalAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAttempt(
      id: serializer.fromJson<int>(json['id']),
      clientAttemptId: serializer.fromJson<String>(json['clientAttemptId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      activityType: serializer.fromJson<String>(json['activityType']),
      activityId: serializer.fromJson<String>(json['activityId']),
      selectedValue: serializer.fromJson<String>(json['selectedValue']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientAttemptId': serializer.toJson<String>(clientAttemptId),
      'profileId': serializer.toJson<String>(profileId),
      'activityType': serializer.toJson<String>(activityType),
      'activityId': serializer.toJson<String>(activityId),
      'selectedValue': serializer.toJson<String>(selectedValue),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'remoteId': serializer.toJson<String?>(remoteId),
    };
  }

  LocalAttempt copyWith({
    int? id,
    String? clientAttemptId,
    String? profileId,
    String? activityType,
    String? activityId,
    String? selectedValue,
    bool? isCorrect,
    DateTime? createdAt,
    bool? isSynced,
    Value<String?> remoteId = const Value.absent(),
  }) => LocalAttempt(
    id: id ?? this.id,
    clientAttemptId: clientAttemptId ?? this.clientAttemptId,
    profileId: profileId ?? this.profileId,
    activityType: activityType ?? this.activityType,
    activityId: activityId ?? this.activityId,
    selectedValue: selectedValue ?? this.selectedValue,
    isCorrect: isCorrect ?? this.isCorrect,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
  );
  LocalAttempt copyWithCompanion(LocalAttemptsCompanion data) {
    return LocalAttempt(
      id: data.id.present ? data.id.value : this.id,
      clientAttemptId: data.clientAttemptId.present
          ? data.clientAttemptId.value
          : this.clientAttemptId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      activityType: data.activityType.present
          ? data.activityType.value
          : this.activityType,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      selectedValue: data.selectedValue.present
          ? data.selectedValue.value
          : this.selectedValue,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAttempt(')
          ..write('id: $id, ')
          ..write('clientAttemptId: $clientAttemptId, ')
          ..write('profileId: $profileId, ')
          ..write('activityType: $activityType, ')
          ..write('activityId: $activityId, ')
          ..write('selectedValue: $selectedValue, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('remoteId: $remoteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientAttemptId,
    profileId,
    activityType,
    activityId,
    selectedValue,
    isCorrect,
    createdAt,
    isSynced,
    remoteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAttempt &&
          other.id == this.id &&
          other.clientAttemptId == this.clientAttemptId &&
          other.profileId == this.profileId &&
          other.activityType == this.activityType &&
          other.activityId == this.activityId &&
          other.selectedValue == this.selectedValue &&
          other.isCorrect == this.isCorrect &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.remoteId == this.remoteId);
}

class LocalAttemptsCompanion extends UpdateCompanion<LocalAttempt> {
  final Value<int> id;
  final Value<String> clientAttemptId;
  final Value<String> profileId;
  final Value<String> activityType;
  final Value<String> activityId;
  final Value<String> selectedValue;
  final Value<bool> isCorrect;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<String?> remoteId;
  const LocalAttemptsCompanion({
    this.id = const Value.absent(),
    this.clientAttemptId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.activityType = const Value.absent(),
    this.activityId = const Value.absent(),
    this.selectedValue = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.remoteId = const Value.absent(),
  });
  LocalAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String clientAttemptId,
    required String profileId,
    required String activityType,
    required String activityId,
    required String selectedValue,
    required bool isCorrect,
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.remoteId = const Value.absent(),
  }) : clientAttemptId = Value(clientAttemptId),
       profileId = Value(profileId),
       activityType = Value(activityType),
       activityId = Value(activityId),
       selectedValue = Value(selectedValue),
       isCorrect = Value(isCorrect);
  static Insertable<LocalAttempt> custom({
    Expression<int>? id,
    Expression<String>? clientAttemptId,
    Expression<String>? profileId,
    Expression<String>? activityType,
    Expression<String>? activityId,
    Expression<String>? selectedValue,
    Expression<bool>? isCorrect,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<String>? remoteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientAttemptId != null) 'client_attempt_id': clientAttemptId,
      if (profileId != null) 'profile_id': profileId,
      if (activityType != null) 'activity_type': activityType,
      if (activityId != null) 'activity_id': activityId,
      if (selectedValue != null) 'selected_value': selectedValue,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (remoteId != null) 'remote_id': remoteId,
    });
  }

  LocalAttemptsCompanion copyWith({
    Value<int>? id,
    Value<String>? clientAttemptId,
    Value<String>? profileId,
    Value<String>? activityType,
    Value<String>? activityId,
    Value<String>? selectedValue,
    Value<bool>? isCorrect,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<String?>? remoteId,
  }) {
    return LocalAttemptsCompanion(
      id: id ?? this.id,
      clientAttemptId: clientAttemptId ?? this.clientAttemptId,
      profileId: profileId ?? this.profileId,
      activityType: activityType ?? this.activityType,
      activityId: activityId ?? this.activityId,
      selectedValue: selectedValue ?? this.selectedValue,
      isCorrect: isCorrect ?? this.isCorrect,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      remoteId: remoteId ?? this.remoteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientAttemptId.present) {
      map['client_attempt_id'] = Variable<String>(clientAttemptId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (activityType.present) {
      map['activity_type'] = Variable<String>(activityType.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (selectedValue.present) {
      map['selected_value'] = Variable<String>(selectedValue.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('clientAttemptId: $clientAttemptId, ')
          ..write('profileId: $profileId, ')
          ..write('activityType: $activityType, ')
          ..write('activityId: $activityId, ')
          ..write('selectedValue: $selectedValue, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('remoteId: $remoteId')
          ..write(')'))
        .toString();
  }
}

class $LocalChildProfilesTable extends LocalChildProfiles
    with TableInfo<$LocalChildProfilesTable, LocalChildProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalChildProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _adultIdMeta = const VerificationMeta(
    'adultId',
  );
  @override
  late final GeneratedColumn<String> adultId = GeneratedColumn<String>(
    'adult_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageRangeMeta = const VerificationMeta(
    'ageRange',
  );
  @override
  late final GeneratedColumn<String> ageRange = GeneratedColumn<String>(
    'age_range',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarKeyMeta = const VerificationMeta(
    'avatarKey',
  );
  @override
  late final GeneratedColumn<String> avatarKey = GeneratedColumn<String>(
    'avatar_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    adultId,
    alias,
    ageRange,
    avatarKey,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_child_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalChildProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('adult_id')) {
      context.handle(
        _adultIdMeta,
        adultId.isAcceptableOrUnknown(data['adult_id']!, _adultIdMeta),
      );
    } else if (isInserting) {
      context.missing(_adultIdMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('age_range')) {
      context.handle(
        _ageRangeMeta,
        ageRange.isAcceptableOrUnknown(data['age_range']!, _ageRangeMeta),
      );
    } else if (isInserting) {
      context.missing(_ageRangeMeta);
    }
    if (data.containsKey('avatar_key')) {
      context.handle(
        _avatarKeyMeta,
        avatarKey.isAcceptableOrUnknown(data['avatar_key']!, _avatarKeyMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId};
  @override
  LocalChildProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalChildProfile(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      adultId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adult_id'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      )!,
      ageRange: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}age_range'],
      )!,
      avatarKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_key'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalChildProfilesTable createAlias(String alias) {
    return $LocalChildProfilesTable(attachedDatabase, alias);
  }
}

class LocalChildProfile extends DataClass
    implements Insertable<LocalChildProfile> {
  final String profileId;
  final String adultId;
  final String alias;
  final String ageRange;
  final String? avatarKey;
  final DateTime updatedAt;
  const LocalChildProfile({
    required this.profileId,
    required this.adultId,
    required this.alias,
    required this.ageRange,
    this.avatarKey,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['adult_id'] = Variable<String>(adultId);
    map['alias'] = Variable<String>(alias);
    map['age_range'] = Variable<String>(ageRange);
    if (!nullToAbsent || avatarKey != null) {
      map['avatar_key'] = Variable<String>(avatarKey);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalChildProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalChildProfilesCompanion(
      profileId: Value(profileId),
      adultId: Value(adultId),
      alias: Value(alias),
      ageRange: Value(ageRange),
      avatarKey: avatarKey == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarKey),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalChildProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalChildProfile(
      profileId: serializer.fromJson<String>(json['profileId']),
      adultId: serializer.fromJson<String>(json['adultId']),
      alias: serializer.fromJson<String>(json['alias']),
      ageRange: serializer.fromJson<String>(json['ageRange']),
      avatarKey: serializer.fromJson<String?>(json['avatarKey']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'adultId': serializer.toJson<String>(adultId),
      'alias': serializer.toJson<String>(alias),
      'ageRange': serializer.toJson<String>(ageRange),
      'avatarKey': serializer.toJson<String?>(avatarKey),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalChildProfile copyWith({
    String? profileId,
    String? adultId,
    String? alias,
    String? ageRange,
    Value<String?> avatarKey = const Value.absent(),
    DateTime? updatedAt,
  }) => LocalChildProfile(
    profileId: profileId ?? this.profileId,
    adultId: adultId ?? this.adultId,
    alias: alias ?? this.alias,
    ageRange: ageRange ?? this.ageRange,
    avatarKey: avatarKey.present ? avatarKey.value : this.avatarKey,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalChildProfile copyWithCompanion(LocalChildProfilesCompanion data) {
    return LocalChildProfile(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      adultId: data.adultId.present ? data.adultId.value : this.adultId,
      alias: data.alias.present ? data.alias.value : this.alias,
      ageRange: data.ageRange.present ? data.ageRange.value : this.ageRange,
      avatarKey: data.avatarKey.present ? data.avatarKey.value : this.avatarKey,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalChildProfile(')
          ..write('profileId: $profileId, ')
          ..write('adultId: $adultId, ')
          ..write('alias: $alias, ')
          ..write('ageRange: $ageRange, ')
          ..write('avatarKey: $avatarKey, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(profileId, adultId, alias, ageRange, avatarKey, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalChildProfile &&
          other.profileId == this.profileId &&
          other.adultId == this.adultId &&
          other.alias == this.alias &&
          other.ageRange == this.ageRange &&
          other.avatarKey == this.avatarKey &&
          other.updatedAt == this.updatedAt);
}

class LocalChildProfilesCompanion extends UpdateCompanion<LocalChildProfile> {
  final Value<String> profileId;
  final Value<String> adultId;
  final Value<String> alias;
  final Value<String> ageRange;
  final Value<String?> avatarKey;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalChildProfilesCompanion({
    this.profileId = const Value.absent(),
    this.adultId = const Value.absent(),
    this.alias = const Value.absent(),
    this.ageRange = const Value.absent(),
    this.avatarKey = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalChildProfilesCompanion.insert({
    required String profileId,
    required String adultId,
    required String alias,
    required String ageRange,
    this.avatarKey = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       adultId = Value(adultId),
       alias = Value(alias),
       ageRange = Value(ageRange);
  static Insertable<LocalChildProfile> custom({
    Expression<String>? profileId,
    Expression<String>? adultId,
    Expression<String>? alias,
    Expression<String>? ageRange,
    Expression<String>? avatarKey,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (adultId != null) 'adult_id': adultId,
      if (alias != null) 'alias': alias,
      if (ageRange != null) 'age_range': ageRange,
      if (avatarKey != null) 'avatar_key': avatarKey,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalChildProfilesCompanion copyWith({
    Value<String>? profileId,
    Value<String>? adultId,
    Value<String>? alias,
    Value<String>? ageRange,
    Value<String?>? avatarKey,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalChildProfilesCompanion(
      profileId: profileId ?? this.profileId,
      adultId: adultId ?? this.adultId,
      alias: alias ?? this.alias,
      ageRange: ageRange ?? this.ageRange,
      avatarKey: avatarKey ?? this.avatarKey,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (adultId.present) {
      map['adult_id'] = Variable<String>(adultId.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (ageRange.present) {
      map['age_range'] = Variable<String>(ageRange.value);
    }
    if (avatarKey.present) {
      map['avatar_key'] = Variable<String>(avatarKey.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalChildProfilesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('adultId: $adultId, ')
          ..write('alias: $alias, ')
          ..write('ageRange: $ageRange, ')
          ..write('avatarKey: $avatarKey, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalAttemptsTable localAttempts = $LocalAttemptsTable(this);
  late final $LocalChildProfilesTable localChildProfiles =
      $LocalChildProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localAttempts,
    localChildProfiles,
  ];
}

typedef $$LocalAttemptsTableCreateCompanionBuilder =
    LocalAttemptsCompanion Function({
      Value<int> id,
      required String clientAttemptId,
      required String profileId,
      required String activityType,
      required String activityId,
      required String selectedValue,
      required bool isCorrect,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<String?> remoteId,
    });
typedef $$LocalAttemptsTableUpdateCompanionBuilder =
    LocalAttemptsCompanion Function({
      Value<int> id,
      Value<String> clientAttemptId,
      Value<String> profileId,
      Value<String> activityType,
      Value<String> activityId,
      Value<String> selectedValue,
      Value<bool> isCorrect,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<String?> remoteId,
    });

class $$LocalAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalAttemptsTable> {
  $$LocalAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientAttemptId => $composableBuilder(
    column: $table.clientAttemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedValue => $composableBuilder(
    column: $table.selectedValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalAttemptsTable> {
  $$LocalAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientAttemptId => $composableBuilder(
    column: $table.clientAttemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedValue => $composableBuilder(
    column: $table.selectedValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalAttemptsTable> {
  $$LocalAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientAttemptId => $composableBuilder(
    column: $table.clientAttemptId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activityId => $composableBuilder(
    column: $table.activityId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedValue => $composableBuilder(
    column: $table.selectedValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);
}

class $$LocalAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalAttemptsTable,
          LocalAttempt,
          $$LocalAttemptsTableFilterComposer,
          $$LocalAttemptsTableOrderingComposer,
          $$LocalAttemptsTableAnnotationComposer,
          $$LocalAttemptsTableCreateCompanionBuilder,
          $$LocalAttemptsTableUpdateCompanionBuilder,
          (
            LocalAttempt,
            BaseReferences<_$AppDatabase, $LocalAttemptsTable, LocalAttempt>,
          ),
          LocalAttempt,
          PrefetchHooks Function()
        > {
  $$LocalAttemptsTableTableManager(_$AppDatabase db, $LocalAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> clientAttemptId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> activityType = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String> selectedValue = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
              }) => LocalAttemptsCompanion(
                id: id,
                clientAttemptId: clientAttemptId,
                profileId: profileId,
                activityType: activityType,
                activityId: activityId,
                selectedValue: selectedValue,
                isCorrect: isCorrect,
                createdAt: createdAt,
                isSynced: isSynced,
                remoteId: remoteId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String clientAttemptId,
                required String profileId,
                required String activityType,
                required String activityId,
                required String selectedValue,
                required bool isCorrect,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
              }) => LocalAttemptsCompanion.insert(
                id: id,
                clientAttemptId: clientAttemptId,
                profileId: profileId,
                activityType: activityType,
                activityId: activityId,
                selectedValue: selectedValue,
                isCorrect: isCorrect,
                createdAt: createdAt,
                isSynced: isSynced,
                remoteId: remoteId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalAttemptsTable, LocalAttempt>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalAttemptsTable,
                    LocalAttempt
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalAttemptsTable,
      LocalAttempt,
      $$LocalAttemptsTableFilterComposer,
      $$LocalAttemptsTableOrderingComposer,
      $$LocalAttemptsTableAnnotationComposer,
      $$LocalAttemptsTableCreateCompanionBuilder,
      $$LocalAttemptsTableUpdateCompanionBuilder,
      (
        LocalAttempt,
        BaseReferences<_$AppDatabase, $LocalAttemptsTable, LocalAttempt>,
      ),
      LocalAttempt,
      PrefetchHooks Function()
    >;
typedef $$LocalChildProfilesTableCreateCompanionBuilder =
    LocalChildProfilesCompanion Function({
      required String profileId,
      required String adultId,
      required String alias,
      required String ageRange,
      Value<String?> avatarKey,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalChildProfilesTableUpdateCompanionBuilder =
    LocalChildProfilesCompanion Function({
      Value<String> profileId,
      Value<String> adultId,
      Value<String> alias,
      Value<String> ageRange,
      Value<String?> avatarKey,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalChildProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalChildProfilesTable> {
  $$LocalChildProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adultId => $composableBuilder(
    column: $table.adultId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ageRange => $composableBuilder(
    column: $table.ageRange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarKey => $composableBuilder(
    column: $table.avatarKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalChildProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalChildProfilesTable> {
  $$LocalChildProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adultId => $composableBuilder(
    column: $table.adultId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ageRange => $composableBuilder(
    column: $table.ageRange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarKey => $composableBuilder(
    column: $table.avatarKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalChildProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalChildProfilesTable> {
  $$LocalChildProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get adultId =>
      $composableBuilder(column: $table.adultId, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get ageRange =>
      $composableBuilder(column: $table.ageRange, builder: (column) => column);

  GeneratedColumn<String> get avatarKey =>
      $composableBuilder(column: $table.avatarKey, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalChildProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalChildProfilesTable,
          LocalChildProfile,
          $$LocalChildProfilesTableFilterComposer,
          $$LocalChildProfilesTableOrderingComposer,
          $$LocalChildProfilesTableAnnotationComposer,
          $$LocalChildProfilesTableCreateCompanionBuilder,
          $$LocalChildProfilesTableUpdateCompanionBuilder,
          (
            LocalChildProfile,
            BaseReferences<
              _$AppDatabase,
              $LocalChildProfilesTable,
              LocalChildProfile
            >,
          ),
          LocalChildProfile,
          PrefetchHooks Function()
        > {
  $$LocalChildProfilesTableTableManager(
    _$AppDatabase db,
    $LocalChildProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalChildProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalChildProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalChildProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> adultId = const Value.absent(),
                Value<String> alias = const Value.absent(),
                Value<String> ageRange = const Value.absent(),
                Value<String?> avatarKey = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalChildProfilesCompanion(
                profileId: profileId,
                adultId: adultId,
                alias: alias,
                ageRange: ageRange,
                avatarKey: avatarKey,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String adultId,
                required String alias,
                required String ageRange,
                Value<String?> avatarKey = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalChildProfilesCompanion.insert(
                profileId: profileId,
                adultId: adultId,
                alias: alias,
                ageRange: ageRange,
                avatarKey: avatarKey,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalChildProfilesTable, LocalChildProfile>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalChildProfilesTable,
                    LocalChildProfile
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalChildProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalChildProfilesTable,
      LocalChildProfile,
      $$LocalChildProfilesTableFilterComposer,
      $$LocalChildProfilesTableOrderingComposer,
      $$LocalChildProfilesTableAnnotationComposer,
      $$LocalChildProfilesTableCreateCompanionBuilder,
      $$LocalChildProfilesTableUpdateCompanionBuilder,
      (
        LocalChildProfile,
        BaseReferences<
          _$AppDatabase,
          $LocalChildProfilesTable,
          LocalChildProfile
        >,
      ),
      LocalChildProfile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalAttemptsTableTableManager get localAttempts =>
      $$LocalAttemptsTableTableManager(_db, _db.localAttempts);
  $$LocalChildProfilesTableTableManager get localChildProfiles =>
      $$LocalChildProfilesTableTableManager(_db, _db.localChildProfiles);
}
