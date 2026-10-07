// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ArObjectsTable extends ArObjects
    with TableInfo<$ArObjectsTable, ArObjectRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArObjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _objectIdMeta = const VerificationMeta(
    'objectId',
  );
  @override
  late final GeneratedColumn<String> objectId = GeneratedColumn<String>(
    'object_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ArObjectOrigin, String> origin =
      GeneratedColumn<String>(
        'origin',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ArObjectOrigin>($ArObjectsTable.$converterorigin);
  @override
  late final GeneratedColumnWithTypeConverter<ArObjectType, String> objectType =
      GeneratedColumn<String>(
        'object_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ArObjectType>($ArObjectsTable.$converterobjectType);
  @override
  late final GeneratedColumnWithTypeConverter<ArObjectContent, String> content =
      GeneratedColumn<String>(
        'content',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ArObjectContent>($ArObjectsTable.$convertercontent);
  @override
  late final GeneratedColumnWithTypeConverter<ArPose, String> pose =
      GeneratedColumn<String>(
        'pose',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ArPose>($ArObjectsTable.$converterpose);
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta(
    'placeName',
  );
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ShareStatus, String> shareStatus =
      GeneratedColumn<String>(
        'share_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ShareStatus>($ArObjectsTable.$convertershareStatus);
  static const VerificationMeta _shareCodeMeta = const VerificationMeta(
    'shareCode',
  );
  @override
  late final GeneratedColumn<String> shareCode = GeneratedColumn<String>(
    'share_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    objectId,
    ownerId,
    origin,
    objectType,
    content,
    pose,
    latitude,
    longitude,
    placeName,
    thumbnailPath,
    createdAt,
    shareStatus,
    shareCode,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ar_objects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArObjectRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('object_id')) {
      context.handle(
        _objectIdMeta,
        objectId.isAcceptableOrUnknown(data['object_id']!, _objectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_objectIdMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('place_name')) {
      context.handle(
        _placeNameMeta,
        placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('share_code')) {
      context.handle(
        _shareCodeMeta,
        shareCode.isAcceptableOrUnknown(data['share_code']!, _shareCodeMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {objectId};
  @override
  ArObjectRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArObjectRecord(
      objectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}object_id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
      origin: $ArObjectsTable.$converterorigin.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}origin'],
        )!,
      ),
      objectType: $ArObjectsTable.$converterobjectType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}object_type'],
        )!,
      ),
      content: $ArObjectsTable.$convertercontent.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}content'],
        )!,
      ),
      pose: $ArObjectsTable.$converterpose.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pose'],
        )!,
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      placeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      shareStatus: $ArObjectsTable.$convertershareStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}share_status'],
        )!,
      ),
      shareCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}share_code'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $ArObjectsTable createAlias(String alias) {
    return $ArObjectsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ArObjectOrigin, String, String> $converterorigin =
      const EnumNameConverter<ArObjectOrigin>(ArObjectOrigin.values);
  static JsonTypeConverter2<ArObjectType, String, String> $converterobjectType =
      const EnumNameConverter<ArObjectType>(ArObjectType.values);
  static TypeConverter<ArObjectContent, String> $convertercontent =
      const ArObjectContentConverter();
  static TypeConverter<ArPose, String> $converterpose = const ArPoseConverter();
  static JsonTypeConverter2<ShareStatus, String, String> $convertershareStatus =
      const EnumNameConverter<ShareStatus>(ShareStatus.values);
}

class ArObjectRecord extends DataClass implements Insertable<ArObjectRecord> {
  final String objectId;
  final String? ownerId;
  final ArObjectOrigin origin;

  /// 検索・集計用。値は [content] の種類と一致させる
  final ArObjectType objectType;
  final ArObjectContent content;
  final ArPose pose;
  final double? latitude;
  final double? longitude;
  final String? placeName;
  final String? thumbnailPath;
  final DateTime createdAt;
  final ShareStatus shareStatus;
  final String? shareCode;
  final DateTime? expiresAt;
  const ArObjectRecord({
    required this.objectId,
    this.ownerId,
    required this.origin,
    required this.objectType,
    required this.content,
    required this.pose,
    this.latitude,
    this.longitude,
    this.placeName,
    this.thumbnailPath,
    required this.createdAt,
    required this.shareStatus,
    this.shareCode,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['object_id'] = Variable<String>(objectId);
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    {
      map['origin'] = Variable<String>(
        $ArObjectsTable.$converterorigin.toSql(origin),
      );
    }
    {
      map['object_type'] = Variable<String>(
        $ArObjectsTable.$converterobjectType.toSql(objectType),
      );
    }
    {
      map['content'] = Variable<String>(
        $ArObjectsTable.$convertercontent.toSql(content),
      );
    }
    {
      map['pose'] = Variable<String>(
        $ArObjectsTable.$converterpose.toSql(pose),
      );
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || placeName != null) {
      map['place_name'] = Variable<String>(placeName);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['share_status'] = Variable<String>(
        $ArObjectsTable.$convertershareStatus.toSql(shareStatus),
      );
    }
    if (!nullToAbsent || shareCode != null) {
      map['share_code'] = Variable<String>(shareCode);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  ArObjectsCompanion toCompanion(bool nullToAbsent) {
    return ArObjectsCompanion(
      objectId: Value(objectId),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      origin: Value(origin),
      objectType: Value(objectType),
      content: Value(content),
      pose: Value(pose),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      placeName: placeName == null && nullToAbsent
          ? const Value.absent()
          : Value(placeName),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      createdAt: Value(createdAt),
      shareStatus: Value(shareStatus),
      shareCode: shareCode == null && nullToAbsent
          ? const Value.absent()
          : Value(shareCode),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory ArObjectRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArObjectRecord(
      objectId: serializer.fromJson<String>(json['objectId']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      origin: $ArObjectsTable.$converterorigin.fromJson(
        serializer.fromJson<String>(json['origin']),
      ),
      objectType: $ArObjectsTable.$converterobjectType.fromJson(
        serializer.fromJson<String>(json['objectType']),
      ),
      content: serializer.fromJson<ArObjectContent>(json['content']),
      pose: serializer.fromJson<ArPose>(json['pose']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      placeName: serializer.fromJson<String?>(json['placeName']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      shareStatus: $ArObjectsTable.$convertershareStatus.fromJson(
        serializer.fromJson<String>(json['shareStatus']),
      ),
      shareCode: serializer.fromJson<String?>(json['shareCode']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'objectId': serializer.toJson<String>(objectId),
      'ownerId': serializer.toJson<String?>(ownerId),
      'origin': serializer.toJson<String>(
        $ArObjectsTable.$converterorigin.toJson(origin),
      ),
      'objectType': serializer.toJson<String>(
        $ArObjectsTable.$converterobjectType.toJson(objectType),
      ),
      'content': serializer.toJson<ArObjectContent>(content),
      'pose': serializer.toJson<ArPose>(pose),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'placeName': serializer.toJson<String?>(placeName),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'shareStatus': serializer.toJson<String>(
        $ArObjectsTable.$convertershareStatus.toJson(shareStatus),
      ),
      'shareCode': serializer.toJson<String?>(shareCode),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  ArObjectRecord copyWith({
    String? objectId,
    Value<String?> ownerId = const Value.absent(),
    ArObjectOrigin? origin,
    ArObjectType? objectType,
    ArObjectContent? content,
    ArPose? pose,
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> placeName = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    DateTime? createdAt,
    ShareStatus? shareStatus,
    Value<String?> shareCode = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => ArObjectRecord(
    objectId: objectId ?? this.objectId,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    origin: origin ?? this.origin,
    objectType: objectType ?? this.objectType,
    content: content ?? this.content,
    pose: pose ?? this.pose,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    placeName: placeName.present ? placeName.value : this.placeName,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    createdAt: createdAt ?? this.createdAt,
    shareStatus: shareStatus ?? this.shareStatus,
    shareCode: shareCode.present ? shareCode.value : this.shareCode,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  ArObjectRecord copyWithCompanion(ArObjectsCompanion data) {
    return ArObjectRecord(
      objectId: data.objectId.present ? data.objectId.value : this.objectId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      origin: data.origin.present ? data.origin.value : this.origin,
      objectType: data.objectType.present
          ? data.objectType.value
          : this.objectType,
      content: data.content.present ? data.content.value : this.content,
      pose: data.pose.present ? data.pose.value : this.pose,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      shareStatus: data.shareStatus.present
          ? data.shareStatus.value
          : this.shareStatus,
      shareCode: data.shareCode.present ? data.shareCode.value : this.shareCode,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArObjectRecord(')
          ..write('objectId: $objectId, ')
          ..write('ownerId: $ownerId, ')
          ..write('origin: $origin, ')
          ..write('objectType: $objectType, ')
          ..write('content: $content, ')
          ..write('pose: $pose, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('placeName: $placeName, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('shareStatus: $shareStatus, ')
          ..write('shareCode: $shareCode, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    objectId,
    ownerId,
    origin,
    objectType,
    content,
    pose,
    latitude,
    longitude,
    placeName,
    thumbnailPath,
    createdAt,
    shareStatus,
    shareCode,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArObjectRecord &&
          other.objectId == this.objectId &&
          other.ownerId == this.ownerId &&
          other.origin == this.origin &&
          other.objectType == this.objectType &&
          other.content == this.content &&
          other.pose == this.pose &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.placeName == this.placeName &&
          other.thumbnailPath == this.thumbnailPath &&
          other.createdAt == this.createdAt &&
          other.shareStatus == this.shareStatus &&
          other.shareCode == this.shareCode &&
          other.expiresAt == this.expiresAt);
}

class ArObjectsCompanion extends UpdateCompanion<ArObjectRecord> {
  final Value<String> objectId;
  final Value<String?> ownerId;
  final Value<ArObjectOrigin> origin;
  final Value<ArObjectType> objectType;
  final Value<ArObjectContent> content;
  final Value<ArPose> pose;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> placeName;
  final Value<String?> thumbnailPath;
  final Value<DateTime> createdAt;
  final Value<ShareStatus> shareStatus;
  final Value<String?> shareCode;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const ArObjectsCompanion({
    this.objectId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.origin = const Value.absent(),
    this.objectType = const Value.absent(),
    this.content = const Value.absent(),
    this.pose = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.placeName = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.shareStatus = const Value.absent(),
    this.shareCode = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArObjectsCompanion.insert({
    required String objectId,
    this.ownerId = const Value.absent(),
    required ArObjectOrigin origin,
    required ArObjectType objectType,
    required ArObjectContent content,
    required ArPose pose,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.placeName = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    required DateTime createdAt,
    required ShareStatus shareStatus,
    this.shareCode = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : objectId = Value(objectId),
       origin = Value(origin),
       objectType = Value(objectType),
       content = Value(content),
       pose = Value(pose),
       createdAt = Value(createdAt),
       shareStatus = Value(shareStatus);
  static Insertable<ArObjectRecord> custom({
    Expression<String>? objectId,
    Expression<String>? ownerId,
    Expression<String>? origin,
    Expression<String>? objectType,
    Expression<String>? content,
    Expression<String>? pose,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? placeName,
    Expression<String>? thumbnailPath,
    Expression<DateTime>? createdAt,
    Expression<String>? shareStatus,
    Expression<String>? shareCode,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (objectId != null) 'object_id': objectId,
      if (ownerId != null) 'owner_id': ownerId,
      if (origin != null) 'origin': origin,
      if (objectType != null) 'object_type': objectType,
      if (content != null) 'content': content,
      if (pose != null) 'pose': pose,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (placeName != null) 'place_name': placeName,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (createdAt != null) 'created_at': createdAt,
      if (shareStatus != null) 'share_status': shareStatus,
      if (shareCode != null) 'share_code': shareCode,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArObjectsCompanion copyWith({
    Value<String>? objectId,
    Value<String?>? ownerId,
    Value<ArObjectOrigin>? origin,
    Value<ArObjectType>? objectType,
    Value<ArObjectContent>? content,
    Value<ArPose>? pose,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? placeName,
    Value<String?>? thumbnailPath,
    Value<DateTime>? createdAt,
    Value<ShareStatus>? shareStatus,
    Value<String?>? shareCode,
    Value<DateTime?>? expiresAt,
    Value<int>? rowid,
  }) {
    return ArObjectsCompanion(
      objectId: objectId ?? this.objectId,
      ownerId: ownerId ?? this.ownerId,
      origin: origin ?? this.origin,
      objectType: objectType ?? this.objectType,
      content: content ?? this.content,
      pose: pose ?? this.pose,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeName: placeName ?? this.placeName,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      createdAt: createdAt ?? this.createdAt,
      shareStatus: shareStatus ?? this.shareStatus,
      shareCode: shareCode ?? this.shareCode,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (objectId.present) {
      map['object_id'] = Variable<String>(objectId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(
        $ArObjectsTable.$converterorigin.toSql(origin.value),
      );
    }
    if (objectType.present) {
      map['object_type'] = Variable<String>(
        $ArObjectsTable.$converterobjectType.toSql(objectType.value),
      );
    }
    if (content.present) {
      map['content'] = Variable<String>(
        $ArObjectsTable.$convertercontent.toSql(content.value),
      );
    }
    if (pose.present) {
      map['pose'] = Variable<String>(
        $ArObjectsTable.$converterpose.toSql(pose.value),
      );
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (shareStatus.present) {
      map['share_status'] = Variable<String>(
        $ArObjectsTable.$convertershareStatus.toSql(shareStatus.value),
      );
    }
    if (shareCode.present) {
      map['share_code'] = Variable<String>(shareCode.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArObjectsCompanion(')
          ..write('objectId: $objectId, ')
          ..write('ownerId: $ownerId, ')
          ..write('origin: $origin, ')
          ..write('objectType: $objectType, ')
          ..write('content: $content, ')
          ..write('pose: $pose, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('placeName: $placeName, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('shareStatus: $shareStatus, ')
          ..write('shareCode: $shareCode, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ArObjectsTable arObjects = $ArObjectsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [arObjects];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ArObjectsTableCreateCompanionBuilder =
    ArObjectsCompanion Function({
      required String objectId,
      Value<String?> ownerId,
      required ArObjectOrigin origin,
      required ArObjectType objectType,
      required ArObjectContent content,
      required ArPose pose,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> placeName,
      Value<String?> thumbnailPath,
      required DateTime createdAt,
      required ShareStatus shareStatus,
      Value<String?> shareCode,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });
typedef $$ArObjectsTableUpdateCompanionBuilder =
    ArObjectsCompanion Function({
      Value<String> objectId,
      Value<String?> ownerId,
      Value<ArObjectOrigin> origin,
      Value<ArObjectType> objectType,
      Value<ArObjectContent> content,
      Value<ArPose> pose,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> placeName,
      Value<String?> thumbnailPath,
      Value<DateTime> createdAt,
      Value<ShareStatus> shareStatus,
      Value<String?> shareCode,
      Value<DateTime?> expiresAt,
      Value<int> rowid,
    });

class $$ArObjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ArObjectsTable> {
  $$ArObjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get objectId => $composableBuilder(
    column: $table.objectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ArObjectOrigin, ArObjectOrigin, String>
  get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ArObjectType, ArObjectType, String>
  get objectType => $composableBuilder(
    column: $table.objectType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ArObjectContent, ArObjectContent, String>
  get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ArPose, ArPose, String> get pose =>
      $composableBuilder(
        column: $table.pose,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ShareStatus, ShareStatus, String>
  get shareStatus => $composableBuilder(
    column: $table.shareStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get shareCode => $composableBuilder(
    column: $table.shareCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArObjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArObjectsTable> {
  $$ArObjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get objectId => $composableBuilder(
    column: $table.objectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get objectType => $composableBuilder(
    column: $table.objectType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pose => $composableBuilder(
    column: $table.pose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareStatus => $composableBuilder(
    column: $table.shareStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shareCode => $composableBuilder(
    column: $table.shareCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArObjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArObjectsTable> {
  $$ArObjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get objectId =>
      $composableBuilder(column: $table.objectId, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ArObjectOrigin, String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ArObjectType, String> get objectType =>
      $composableBuilder(
        column: $table.objectType,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<ArObjectContent, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ArPose, String> get pose =>
      $composableBuilder(column: $table.pose, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ShareStatus, String> get shareStatus =>
      $composableBuilder(
        column: $table.shareStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get shareCode =>
      $composableBuilder(column: $table.shareCode, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$ArObjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArObjectsTable,
          ArObjectRecord,
          $$ArObjectsTableFilterComposer,
          $$ArObjectsTableOrderingComposer,
          $$ArObjectsTableAnnotationComposer,
          $$ArObjectsTableCreateCompanionBuilder,
          $$ArObjectsTableUpdateCompanionBuilder,
          (
            ArObjectRecord,
            BaseReferences<_$AppDatabase, $ArObjectsTable, ArObjectRecord>,
          ),
          ArObjectRecord,
          PrefetchHooks Function()
        > {
  $$ArObjectsTableTableManager(_$AppDatabase db, $ArObjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArObjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArObjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArObjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> objectId = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<ArObjectOrigin> origin = const Value.absent(),
                Value<ArObjectType> objectType = const Value.absent(),
                Value<ArObjectContent> content = const Value.absent(),
                Value<ArPose> pose = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<ShareStatus> shareStatus = const Value.absent(),
                Value<String?> shareCode = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArObjectsCompanion(
                objectId: objectId,
                ownerId: ownerId,
                origin: origin,
                objectType: objectType,
                content: content,
                pose: pose,
                latitude: latitude,
                longitude: longitude,
                placeName: placeName,
                thumbnailPath: thumbnailPath,
                createdAt: createdAt,
                shareStatus: shareStatus,
                shareCode: shareCode,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String objectId,
                Value<String?> ownerId = const Value.absent(),
                required ArObjectOrigin origin,
                required ArObjectType objectType,
                required ArObjectContent content,
                required ArPose pose,
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> placeName = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                required DateTime createdAt,
                required ShareStatus shareStatus,
                Value<String?> shareCode = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArObjectsCompanion.insert(
                objectId: objectId,
                ownerId: ownerId,
                origin: origin,
                objectType: objectType,
                content: content,
                pose: pose,
                latitude: latitude,
                longitude: longitude,
                placeName: placeName,
                thumbnailPath: thumbnailPath,
                createdAt: createdAt,
                shareStatus: shareStatus,
                shareCode: shareCode,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArObjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArObjectsTable,
      ArObjectRecord,
      $$ArObjectsTableFilterComposer,
      $$ArObjectsTableOrderingComposer,
      $$ArObjectsTableAnnotationComposer,
      $$ArObjectsTableCreateCompanionBuilder,
      $$ArObjectsTableUpdateCompanionBuilder,
      (
        ArObjectRecord,
        BaseReferences<_$AppDatabase, $ArObjectsTable, ArObjectRecord>,
      ),
      ArObjectRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ArObjectsTableTableManager get arObjects =>
      $$ArObjectsTableTableManager(_db, _db.arObjects);
}
