// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $HistoryItemsTable extends HistoryItems
    with TableInfo<$HistoryItemsTable, HistoryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 36),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => UuidMixin.v7.generate(),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        clientDefault: () => DateTime.now().millisecondsSinceEpoch,
      ).withConverter<DateTime>($HistoryItemsTable.$convertercreatedAt);
  static const VerificationMeta _contentsMeta = const VerificationMeta(
    'contents',
  );
  @override
  late final GeneratedColumn<String> contents = GeneratedColumn<String>(
    'contents',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatMeta = const VerificationMeta('format');
  @override
  late final GeneratedColumn<String> format = GeneratedColumn<String>(
    'format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorLevelMeta = const VerificationMeta(
    'errorLevel',
  );
  @override
  late final GeneratedColumn<String> errorLevel = GeneratedColumn<String>(
    'error_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    createdAt,
    contents,
    format,
    type,
    errorLevel,
    origin,
    isFavorite,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('contents')) {
      context.handle(
        _contentsMeta,
        contents.isAcceptableOrUnknown(data['contents']!, _contentsMeta),
      );
    } else if (isInserting) {
      context.missing(_contentsMeta);
    }
    if (data.containsKey('format')) {
      context.handle(
        _formatMeta,
        format.isAcceptableOrUnknown(data['format']!, _formatMeta),
      );
    } else if (isInserting) {
      context.missing(_formatMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('error_level')) {
      context.handle(
        _errorLevelMeta,
        errorLevel.isAcceptableOrUnknown(data['error_level']!, _errorLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_errorLevelMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    } else if (isInserting) {
      context.missing(_isFavoriteMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  HistoryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryItem(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      createdAt: $HistoryItemsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      contents: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contents'],
      )!,
      format: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}format'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      errorLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_level'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $HistoryItemsTable createAlias(String alias) {
    return $HistoryItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt = dateTimeConverter;
}

class HistoryItem extends DataClass implements Insertable<HistoryItem> {
  final String uuid;
  final DateTime createdAt;
  final String contents;
  final String format;
  final String type;
  final String errorLevel;
  final String origin;
  final bool isFavorite;
  final String notes;
  const HistoryItem({
    required this.uuid,
    required this.createdAt,
    required this.contents,
    required this.format,
    required this.type,
    required this.errorLevel,
    required this.origin,
    required this.isFavorite,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    {
      map['created_at'] = Variable<int>(
        $HistoryItemsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    map['contents'] = Variable<String>(contents);
    map['format'] = Variable<String>(format);
    map['type'] = Variable<String>(type);
    map['error_level'] = Variable<String>(errorLevel);
    map['origin'] = Variable<String>(origin);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  HistoryItemsCompanion toCompanion(bool nullToAbsent) {
    return HistoryItemsCompanion(
      uuid: Value(uuid),
      createdAt: Value(createdAt),
      contents: Value(contents),
      format: Value(format),
      type: Value(type),
      errorLevel: Value(errorLevel),
      origin: Value(origin),
      isFavorite: Value(isFavorite),
      notes: Value(notes),
    );
  }

  factory HistoryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryItem(
      uuid: serializer.fromJson<String>(json['uuid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      contents: serializer.fromJson<String>(json['contents']),
      format: serializer.fromJson<String>(json['format']),
      type: serializer.fromJson<String>(json['type']),
      errorLevel: serializer.fromJson<String>(json['errorLevel']),
      origin: serializer.fromJson<String>(json['origin']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'contents': serializer.toJson<String>(contents),
      'format': serializer.toJson<String>(format),
      'type': serializer.toJson<String>(type),
      'errorLevel': serializer.toJson<String>(errorLevel),
      'origin': serializer.toJson<String>(origin),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'notes': serializer.toJson<String>(notes),
    };
  }

  HistoryItem copyWith({
    String? uuid,
    DateTime? createdAt,
    String? contents,
    String? format,
    String? type,
    String? errorLevel,
    String? origin,
    bool? isFavorite,
    String? notes,
  }) => HistoryItem(
    uuid: uuid ?? this.uuid,
    createdAt: createdAt ?? this.createdAt,
    contents: contents ?? this.contents,
    format: format ?? this.format,
    type: type ?? this.type,
    errorLevel: errorLevel ?? this.errorLevel,
    origin: origin ?? this.origin,
    isFavorite: isFavorite ?? this.isFavorite,
    notes: notes ?? this.notes,
  );
  HistoryItem copyWithCompanion(HistoryItemsCompanion data) {
    return HistoryItem(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      contents: data.contents.present ? data.contents.value : this.contents,
      format: data.format.present ? data.format.value : this.format,
      type: data.type.present ? data.type.value : this.type,
      errorLevel: data.errorLevel.present
          ? data.errorLevel.value
          : this.errorLevel,
      origin: data.origin.present ? data.origin.value : this.origin,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryItem(')
          ..write('uuid: $uuid, ')
          ..write('createdAt: $createdAt, ')
          ..write('contents: $contents, ')
          ..write('format: $format, ')
          ..write('type: $type, ')
          ..write('errorLevel: $errorLevel, ')
          ..write('origin: $origin, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    createdAt,
    contents,
    format,
    type,
    errorLevel,
    origin,
    isFavorite,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryItem &&
          other.uuid == this.uuid &&
          other.createdAt == this.createdAt &&
          other.contents == this.contents &&
          other.format == this.format &&
          other.type == this.type &&
          other.errorLevel == this.errorLevel &&
          other.origin == this.origin &&
          other.isFavorite == this.isFavorite &&
          other.notes == this.notes);
}

class HistoryItemsCompanion extends UpdateCompanion<HistoryItem> {
  final Value<String> uuid;
  final Value<DateTime> createdAt;
  final Value<String> contents;
  final Value<String> format;
  final Value<String> type;
  final Value<String> errorLevel;
  final Value<String> origin;
  final Value<bool> isFavorite;
  final Value<String> notes;
  final Value<int> rowid;
  const HistoryItemsCompanion({
    this.uuid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.contents = const Value.absent(),
    this.format = const Value.absent(),
    this.type = const Value.absent(),
    this.errorLevel = const Value.absent(),
    this.origin = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HistoryItemsCompanion.insert({
    this.uuid = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String contents,
    required String format,
    required String type,
    required String errorLevel,
    required String origin,
    required bool isFavorite,
    required String notes,
    this.rowid = const Value.absent(),
  }) : contents = Value(contents),
       format = Value(format),
       type = Value(type),
       errorLevel = Value(errorLevel),
       origin = Value(origin),
       isFavorite = Value(isFavorite),
       notes = Value(notes);
  static Insertable<HistoryItem> custom({
    Expression<String>? uuid,
    Expression<int>? createdAt,
    Expression<String>? contents,
    Expression<String>? format,
    Expression<String>? type,
    Expression<String>? errorLevel,
    Expression<String>? origin,
    Expression<bool>? isFavorite,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (createdAt != null) 'created_at': createdAt,
      if (contents != null) 'contents': contents,
      if (format != null) 'format': format,
      if (type != null) 'type': type,
      if (errorLevel != null) 'error_level': errorLevel,
      if (origin != null) 'origin': origin,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HistoryItemsCompanion copyWith({
    Value<String>? uuid,
    Value<DateTime>? createdAt,
    Value<String>? contents,
    Value<String>? format,
    Value<String>? type,
    Value<String>? errorLevel,
    Value<String>? origin,
    Value<bool>? isFavorite,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return HistoryItemsCompanion(
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      contents: contents ?? this.contents,
      format: format ?? this.format,
      type: type ?? this.type,
      errorLevel: errorLevel ?? this.errorLevel,
      origin: origin ?? this.origin,
      isFavorite: isFavorite ?? this.isFavorite,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $HistoryItemsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (contents.present) {
      map['contents'] = Variable<String>(contents.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(format.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (errorLevel.present) {
      map['error_level'] = Variable<String>(errorLevel.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryItemsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('createdAt: $createdAt, ')
          ..write('contents: $contents, ')
          ..write('format: $format, ')
          ..write('type: $type, ')
          ..write('errorLevel: $errorLevel, ')
          ..write('origin: $origin, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDriftDatabase extends GeneratedDatabase {
  _$MyDriftDatabase(QueryExecutor e) : super(e);
  $MyDriftDatabaseManager get managers => $MyDriftDatabaseManager(this);
  late final $HistoryItemsTable historyItems = $HistoryItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [historyItems];
}

typedef $$HistoryItemsTableCreateCompanionBuilder =
    HistoryItemsCompanion Function({
      Value<String> uuid,
      Value<DateTime> createdAt,
      required String contents,
      required String format,
      required String type,
      required String errorLevel,
      required String origin,
      required bool isFavorite,
      required String notes,
      Value<int> rowid,
    });
typedef $$HistoryItemsTableUpdateCompanionBuilder =
    HistoryItemsCompanion Function({
      Value<String> uuid,
      Value<DateTime> createdAt,
      Value<String> contents,
      Value<String> format,
      Value<String> type,
      Value<String> errorLevel,
      Value<String> origin,
      Value<bool> isFavorite,
      Value<String> notes,
      Value<int> rowid,
    });

class $$HistoryItemsTableFilterComposer
    extends Composer<_$MyDriftDatabase, $HistoryItemsTable> {
  $$HistoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get contents => $composableBuilder(
    column: $table.contents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorLevel => $composableBuilder(
    column: $table.errorLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistoryItemsTableOrderingComposer
    extends Composer<_$MyDriftDatabase, $HistoryItemsTable> {
  $$HistoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contents => $composableBuilder(
    column: $table.contents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorLevel => $composableBuilder(
    column: $table.errorLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistoryItemsTableAnnotationComposer
    extends Composer<_$MyDriftDatabase, $HistoryItemsTable> {
  $$HistoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get contents =>
      $composableBuilder(column: $table.contents, builder: (column) => column);

  GeneratedColumn<String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get errorLevel => $composableBuilder(
    column: $table.errorLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$HistoryItemsTableTableManager
    extends
        RootTableManager<
          _$MyDriftDatabase,
          $HistoryItemsTable,
          HistoryItem,
          $$HistoryItemsTableFilterComposer,
          $$HistoryItemsTableOrderingComposer,
          $$HistoryItemsTableAnnotationComposer,
          $$HistoryItemsTableCreateCompanionBuilder,
          $$HistoryItemsTableUpdateCompanionBuilder,
          (
            HistoryItem,
            BaseReferences<_$MyDriftDatabase, $HistoryItemsTable, HistoryItem>,
          ),
          HistoryItem,
          PrefetchHooks Function()
        > {
  $$HistoryItemsTableTableManager(
    _$MyDriftDatabase db,
    $HistoryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> contents = const Value.absent(),
                Value<String> format = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> errorLevel = const Value.absent(),
                Value<String> origin = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HistoryItemsCompanion(
                uuid: uuid,
                createdAt: createdAt,
                contents: contents,
                format: format,
                type: type,
                errorLevel: errorLevel,
                origin: origin,
                isFavorite: isFavorite,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                required String contents,
                required String format,
                required String type,
                required String errorLevel,
                required String origin,
                required bool isFavorite,
                required String notes,
                Value<int> rowid = const Value.absent(),
              }) => HistoryItemsCompanion.insert(
                uuid: uuid,
                createdAt: createdAt,
                contents: contents,
                format: format,
                type: type,
                errorLevel: errorLevel,
                origin: origin,
                isFavorite: isFavorite,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HistoryItemsTable, HistoryItem>(table),
                  BaseReferences<
                    _$MyDriftDatabase,
                    $HistoryItemsTable,
                    HistoryItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$MyDriftDatabase,
      $HistoryItemsTable,
      HistoryItem,
      $$HistoryItemsTableFilterComposer,
      $$HistoryItemsTableOrderingComposer,
      $$HistoryItemsTableAnnotationComposer,
      $$HistoryItemsTableCreateCompanionBuilder,
      $$HistoryItemsTableUpdateCompanionBuilder,
      (
        HistoryItem,
        BaseReferences<_$MyDriftDatabase, $HistoryItemsTable, HistoryItem>,
      ),
      HistoryItem,
      PrefetchHooks Function()
    >;

class $MyDriftDatabaseManager {
  final _$MyDriftDatabase _db;
  $MyDriftDatabaseManager(this._db);
  $$HistoryItemsTableTableManager get historyItems =>
      $$HistoryItemsTableTableManager(_db, _db.historyItems);
}
