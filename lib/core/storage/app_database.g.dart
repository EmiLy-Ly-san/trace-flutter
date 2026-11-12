// GENERATED CODE - DO NOT MODIFY BY HAND
// Fichier généré par Drift à partir de app_database.dart.
// Il est recréé par build_runner : ne pas le modifier à la main.

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ContentsTable extends Contents with TableInfo<$ContentsTable, Content> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ContentType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ContentType>($ContentsTable.$convertertype);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
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
  static const VerificationMeta _isSharedMeta = const VerificationMeta(
    'isShared',
  );
  @override
  late final GeneratedColumn<bool> isShared = GeneratedColumn<bool>(
    'is_shared',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_shared" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    type,
    body,
    filePath,
    createdAt,
    isShared,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Content> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
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
    if (data.containsKey('is_shared')) {
      context.handle(
        _isSharedMeta,
        isShared.isAcceptableOrUnknown(data['is_shared']!, _isSharedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Content map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Content(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      type: $ContentsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isShared: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_shared'],
      )!,
    );
  }

  @override
  $ContentsTable createAlias(String alias) {
    return $ContentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ContentType, String, String> $convertertype =
      const EnumNameConverter<ContentType>(ContentType.values);
}

class Content extends DataClass implements Insertable<Content> {
  final int id;
  final String title;
  final ContentType type;
  final String? body;
  final String? filePath;
  final DateTime createdAt;
  final bool isShared;
  const Content({
    required this.id,
    required this.title,
    required this.type,
    this.body,
    this.filePath,
    required this.createdAt,
    required this.isShared,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    {
      map['type'] = Variable<String>($ContentsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_shared'] = Variable<bool>(isShared);
    return map;
  }

  ContentsCompanion toCompanion(bool nullToAbsent) {
    return ContentsCompanion(
      id: Value(id),
      title: Value(title),
      type: Value(type),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      createdAt: Value(createdAt),
      isShared: Value(isShared),
    );
  }

  factory Content.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Content(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      type: $ContentsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      body: serializer.fromJson<String?>(json['body']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isShared: serializer.fromJson<bool>(json['isShared']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(
        $ContentsTable.$convertertype.toJson(type),
      ),
      'body': serializer.toJson<String?>(body),
      'filePath': serializer.toJson<String?>(filePath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isShared': serializer.toJson<bool>(isShared),
    };
  }

  Content copyWith({
    int? id,
    String? title,
    ContentType? type,
    Value<String?> body = const Value.absent(),
    Value<String?> filePath = const Value.absent(),
    DateTime? createdAt,
    bool? isShared,
  }) => Content(
    id: id ?? this.id,
    title: title ?? this.title,
    type: type ?? this.type,
    body: body.present ? body.value : this.body,
    filePath: filePath.present ? filePath.value : this.filePath,
    createdAt: createdAt ?? this.createdAt,
    isShared: isShared ?? this.isShared,
  );
  Content copyWithCompanion(ContentsCompanion data) {
    return Content(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      body: data.body.present ? data.body.value : this.body,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isShared: data.isShared.present ? data.isShared.value : this.isShared,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Content(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('body: $body, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('isShared: $isShared')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, type, body, filePath, createdAt, isShared);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Content &&
          other.id == this.id &&
          other.title == this.title &&
          other.type == this.type &&
          other.body == this.body &&
          other.filePath == this.filePath &&
          other.createdAt == this.createdAt &&
          other.isShared == this.isShared);
}

class ContentsCompanion extends UpdateCompanion<Content> {
  final Value<int> id;
  final Value<String> title;
  final Value<ContentType> type;
  final Value<String?> body;
  final Value<String?> filePath;
  final Value<DateTime> createdAt;
  final Value<bool> isShared;
  const ContentsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.body = const Value.absent(),
    this.filePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isShared = const Value.absent(),
  });
  ContentsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required ContentType type,
    this.body = const Value.absent(),
    this.filePath = const Value.absent(),
    required DateTime createdAt,
    this.isShared = const Value.absent(),
  }) : title = Value(title),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<Content> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? type,
    Expression<String>? body,
    Expression<String>? filePath,
    Expression<DateTime>? createdAt,
    Expression<bool>? isShared,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (body != null) 'body': body,
      if (filePath != null) 'file_path': filePath,
      if (createdAt != null) 'created_at': createdAt,
      if (isShared != null) 'is_shared': isShared,
    });
  }

  ContentsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<ContentType>? type,
    Value<String?>? body,
    Value<String?>? filePath,
    Value<DateTime>? createdAt,
    Value<bool>? isShared,
  }) {
    return ContentsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      body: body ?? this.body,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      isShared: isShared ?? this.isShared,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ContentsTable.$convertertype.toSql(type.value),
      );
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isShared.present) {
      map['is_shared'] = Variable<bool>(isShared.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('body: $body, ')
          ..write('filePath: $filePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('isShared: $isShared')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ContentsTable contents = $ContentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [contents];
}

typedef $$ContentsTableCreateCompanionBuilder =
    ContentsCompanion Function({
      Value<int> id,
      required String title,
      required ContentType type,
      Value<String?> body,
      Value<String?> filePath,
      required DateTime createdAt,
      Value<bool> isShared,
    });
typedef $$ContentsTableUpdateCompanionBuilder =
    ContentsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<ContentType> type,
      Value<String?> body,
      Value<String?> filePath,
      Value<DateTime> createdAt,
      Value<bool> isShared,
    });

class $$ContentsTableFilterComposer
    extends Composer<_$AppDatabase, $ContentsTable> {
  $$ContentsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ContentType, ContentType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isShared => $composableBuilder(
    column: $table.isShared,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentsTable> {
  $$ContentsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isShared => $composableBuilder(
    column: $table.isShared,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentsTable> {
  $$ContentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ContentType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isShared =>
      $composableBuilder(column: $table.isShared, builder: (column) => column);
}

class $$ContentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentsTable,
          Content,
          $$ContentsTableFilterComposer,
          $$ContentsTableOrderingComposer,
          $$ContentsTableAnnotationComposer,
          $$ContentsTableCreateCompanionBuilder,
          $$ContentsTableUpdateCompanionBuilder,
          (Content, BaseReferences<_$AppDatabase, $ContentsTable, Content>),
          Content,
          PrefetchHooks Function()
        > {
  $$ContentsTableTableManager(_$AppDatabase db, $ContentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<ContentType> type = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isShared = const Value.absent(),
              }) => ContentsCompanion(
                id: id,
                title: title,
                type: type,
                body: body,
                filePath: filePath,
                createdAt: createdAt,
                isShared: isShared,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required ContentType type,
                Value<String?> body = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isShared = const Value.absent(),
              }) => ContentsCompanion.insert(
                id: id,
                title: title,
                type: type,
                body: body,
                filePath: filePath,
                createdAt: createdAt,
                isShared: isShared,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ContentsTable, Content>(table),
                  BaseReferences<_$AppDatabase, $ContentsTable, Content>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentsTable,
      Content,
      $$ContentsTableFilterComposer,
      $$ContentsTableOrderingComposer,
      $$ContentsTableAnnotationComposer,
      $$ContentsTableCreateCompanionBuilder,
      $$ContentsTableUpdateCompanionBuilder,
      (Content, BaseReferences<_$AppDatabase, $ContentsTable, Content>),
      Content,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ContentsTableTableManager get contents =>
      $$ContentsTableTableManager(_db, _db.contents);
}
