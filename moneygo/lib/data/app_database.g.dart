// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _maxBudgetMeta =
      const VerificationMeta('maxBudget');
  @override
  late final GeneratedColumn<double> maxBudget = GeneratedColumn<double>(
      'max_budget', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dateUpdatedMeta =
      const VerificationMeta('dateUpdated');
  @override
  late final GeneratedColumn<DateTime> dateUpdated = GeneratedColumn<DateTime>(
      'date_updated', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _periodIdMeta =
      const VerificationMeta('periodId');
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
      'period_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES periods(id) ON DELETE CASCADE NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, maxBudget, balance, dateCreated, dateUpdated, periodId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('max_budget')) {
      context.handle(_maxBudgetMeta,
          maxBudget.isAcceptableOrUnknown(data['max_budget']!, _maxBudgetMeta));
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    if (data.containsKey('date_updated')) {
      context.handle(
          _dateUpdatedMeta,
          dateUpdated.isAcceptableOrUnknown(
              data['date_updated']!, _dateUpdatedMeta));
    }
    if (data.containsKey('period_id')) {
      context.handle(_periodIdMeta,
          periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta));
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      maxBudget: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_budget'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_updated']),
      periodId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}period_id'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final double maxBudget;
  final double balance;
  final DateTime dateCreated;
  final DateTime? dateUpdated;
  final int periodId;
  const Category(
      {required this.id,
      required this.name,
      required this.maxBudget,
      required this.balance,
      required this.dateCreated,
      this.dateUpdated,
      required this.periodId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['max_budget'] = Variable<double>(maxBudget);
    map['balance'] = Variable<double>(balance);
    map['date_created'] = Variable<DateTime>(dateCreated);
    if (!nullToAbsent || dateUpdated != null) {
      map['date_updated'] = Variable<DateTime>(dateUpdated);
    }
    map['period_id'] = Variable<int>(periodId);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      maxBudget: Value(maxBudget),
      balance: Value(balance),
      dateCreated: Value(dateCreated),
      dateUpdated: dateUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateUpdated),
      periodId: Value(periodId),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      maxBudget: serializer.fromJson<double>(json['maxBudget']),
      balance: serializer.fromJson<double>(json['balance']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateUpdated: serializer.fromJson<DateTime?>(json['dateUpdated']),
      periodId: serializer.fromJson<int>(json['periodId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'maxBudget': serializer.toJson<double>(maxBudget),
      'balance': serializer.toJson<double>(balance),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateUpdated': serializer.toJson<DateTime?>(dateUpdated),
      'periodId': serializer.toJson<int>(periodId),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          double? maxBudget,
          double? balance,
          DateTime? dateCreated,
          Value<DateTime?> dateUpdated = const Value.absent(),
          int? periodId}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        maxBudget: maxBudget ?? this.maxBudget,
        balance: balance ?? this.balance,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated.present ? dateUpdated.value : this.dateUpdated,
        periodId: periodId ?? this.periodId,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('maxBudget: $maxBudget, ')
          ..write('balance: $balance, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('periodId: $periodId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, maxBudget, balance, dateCreated, dateUpdated, periodId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.maxBudget == this.maxBudget &&
          other.balance == this.balance &&
          other.dateCreated == this.dateCreated &&
          other.dateUpdated == this.dateUpdated &&
          other.periodId == this.periodId);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> maxBudget;
  final Value<double> balance;
  final Value<DateTime> dateCreated;
  final Value<DateTime?> dateUpdated;
  final Value<int> periodId;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.maxBudget = const Value.absent(),
    this.balance = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    this.periodId = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.maxBudget = const Value.absent(),
    this.balance = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    required int periodId,
  })  : name = Value(name),
        periodId = Value(periodId);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? maxBudget,
    Expression<double>? balance,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateUpdated,
    Expression<int>? periodId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (maxBudget != null) 'max_budget': maxBudget,
      if (balance != null) 'balance': balance,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateUpdated != null) 'date_updated': dateUpdated,
      if (periodId != null) 'period_id': periodId,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? maxBudget,
      Value<double>? balance,
      Value<DateTime>? dateCreated,
      Value<DateTime?>? dateUpdated,
      Value<int>? periodId}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      maxBudget: maxBudget ?? this.maxBudget,
      balance: balance ?? this.balance,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      periodId: periodId ?? this.periodId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (maxBudget.present) {
      map['max_budget'] = Variable<double>(maxBudget.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<DateTime>(dateUpdated.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('maxBudget: $maxBudget, ')
          ..write('balance: $balance, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('periodId: $periodId')
          ..write(')'))
        .toString();
  }
}

class $SourcesTable extends Sources with TableInfo<$SourcesTable, Source> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dateUpdatedMeta =
      const VerificationMeta('dateUpdated');
  @override
  late final GeneratedColumn<DateTime> dateUpdated = GeneratedColumn<DateTime>(
      'date_updated', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, balance, dateCreated, dateUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sources';
  @override
  VerificationContext validateIntegrity(Insertable<Source> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    if (data.containsKey('date_updated')) {
      context.handle(
          _dateUpdatedMeta,
          dateUpdated.isAcceptableOrUnknown(
              data['date_updated']!, _dateUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Source map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Source(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_updated']),
    );
  }

  @override
  $SourcesTable createAlias(String alias) {
    return $SourcesTable(attachedDatabase, alias);
  }
}

class Source extends DataClass implements Insertable<Source> {
  final int id;
  final String name;
  final double balance;
  final DateTime dateCreated;
  final DateTime? dateUpdated;
  const Source(
      {required this.id,
      required this.name,
      required this.balance,
      required this.dateCreated,
      this.dateUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['balance'] = Variable<double>(balance);
    map['date_created'] = Variable<DateTime>(dateCreated);
    if (!nullToAbsent || dateUpdated != null) {
      map['date_updated'] = Variable<DateTime>(dateUpdated);
    }
    return map;
  }

  SourcesCompanion toCompanion(bool nullToAbsent) {
    return SourcesCompanion(
      id: Value(id),
      name: Value(name),
      balance: Value(balance),
      dateCreated: Value(dateCreated),
      dateUpdated: dateUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateUpdated),
    );
  }

  factory Source.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Source(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      balance: serializer.fromJson<double>(json['balance']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateUpdated: serializer.fromJson<DateTime?>(json['dateUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'balance': serializer.toJson<double>(balance),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateUpdated': serializer.toJson<DateTime?>(dateUpdated),
    };
  }

  Source copyWith(
          {int? id,
          String? name,
          double? balance,
          DateTime? dateCreated,
          Value<DateTime?> dateUpdated = const Value.absent()}) =>
      Source(
        id: id ?? this.id,
        name: name ?? this.name,
        balance: balance ?? this.balance,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated.present ? dateUpdated.value : this.dateUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('Source(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, balance, dateCreated, dateUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Source &&
          other.id == this.id &&
          other.name == this.name &&
          other.balance == this.balance &&
          other.dateCreated == this.dateCreated &&
          other.dateUpdated == this.dateUpdated);
}

class SourcesCompanion extends UpdateCompanion<Source> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> balance;
  final Value<DateTime> dateCreated;
  final Value<DateTime?> dateUpdated;
  const SourcesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.balance = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
  });
  SourcesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.balance = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Source> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? balance,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (balance != null) 'balance': balance,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateUpdated != null) 'date_updated': dateUpdated,
    });
  }

  SourcesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? balance,
      Value<DateTime>? dateCreated,
      Value<DateTime?>? dateUpdated}) {
    return SourcesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<DateTime>(dateUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SourcesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dateUpdatedMeta =
      const VerificationMeta('dateUpdated');
  @override
  late final GeneratedColumn<DateTime> dateUpdated = GeneratedColumn<DateTime>(
      'date_updated', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TransactionTypes, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TransactionTypes>($TransactionsTable.$convertertype);
  @override
  List<GeneratedColumn> get $columns =>
      [id, amount, title, description, date, dateCreated, dateUpdated, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    if (data.containsKey('date_updated')) {
      context.handle(
          _dateUpdatedMeta,
          dateUpdated.isAcceptableOrUnknown(
              data['date_updated']!, _dateUpdatedMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_updated']),
      type: $TransactionsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionTypes, int, int> $convertertype =
      const EnumIndexConverter<TransactionTypes>(TransactionTypes.values);
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final double amount;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime dateCreated;
  final DateTime? dateUpdated;
  final TransactionTypes type;
  const Transaction(
      {required this.id,
      required this.amount,
      required this.title,
      this.description,
      required this.date,
      required this.dateCreated,
      this.dateUpdated,
      required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['date'] = Variable<DateTime>(date);
    map['date_created'] = Variable<DateTime>(dateCreated);
    if (!nullToAbsent || dateUpdated != null) {
      map['date_updated'] = Variable<DateTime>(dateUpdated);
    }
    {
      map['type'] =
          Variable<int>($TransactionsTable.$convertertype.toSql(type));
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      date: Value(date),
      dateCreated: Value(dateCreated),
      dateUpdated: dateUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateUpdated),
      type: Value(type),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      date: serializer.fromJson<DateTime>(json['date']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateUpdated: serializer.fromJson<DateTime?>(json['dateUpdated']),
      type: $TransactionsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'date': serializer.toJson<DateTime>(date),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateUpdated': serializer.toJson<DateTime?>(dateUpdated),
      'type': serializer
          .toJson<int>($TransactionsTable.$convertertype.toJson(type)),
    };
  }

  Transaction copyWith(
          {int? id,
          double? amount,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? date,
          DateTime? dateCreated,
          Value<DateTime?> dateUpdated = const Value.absent(),
          TransactionTypes? type}) =>
      Transaction(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        date: date ?? this.date,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated.present ? dateUpdated.value : this.dateUpdated,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, amount, title, description, date, dateCreated, dateUpdated, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.title == this.title &&
          other.description == this.description &&
          other.date == this.date &&
          other.dateCreated == this.dateCreated &&
          other.dateUpdated == this.dateUpdated &&
          other.type == this.type);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> date;
  final Value<DateTime> dateCreated;
  final Value<DateTime?> dateUpdated;
  final Value<TransactionTypes> type;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.date = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    this.type = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required String title,
    this.description = const Value.absent(),
    required DateTime date,
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    required TransactionTypes type,
  })  : amount = Value(amount),
        title = Value(title),
        date = Value(date),
        type = Value(type);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? date,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateUpdated,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (date != null) 'date': date,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateUpdated != null) 'date_updated': dateUpdated,
      if (type != null) 'type': type,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? date,
      Value<DateTime>? dateCreated,
      Value<DateTime?>? dateUpdated,
      Value<TransactionTypes>? type}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<DateTime>(dateUpdated.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($TransactionsTable.$convertertype.toSql(type.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('date: $date, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $TransfersTable extends Transfers
    with TableInfo<$TransfersTable, Transfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES transactions(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _fromSourceIdMeta =
      const VerificationMeta('fromSourceId');
  @override
  late final GeneratedColumn<int> fromSourceId = GeneratedColumn<int>(
      'from_source_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES sources(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _toSourceIdMeta =
      const VerificationMeta('toSourceId');
  @override
  late final GeneratedColumn<int> toSourceId = GeneratedColumn<int>(
      'to_source_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES sources(id) ON DELETE CASCADE NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, transactionId, fromSourceId, toSourceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfers';
  @override
  VerificationContext validateIntegrity(Insertable<Transfer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('from_source_id')) {
      context.handle(
          _fromSourceIdMeta,
          fromSourceId.isAcceptableOrUnknown(
              data['from_source_id']!, _fromSourceIdMeta));
    } else if (isInserting) {
      context.missing(_fromSourceIdMeta);
    }
    if (data.containsKey('to_source_id')) {
      context.handle(
          _toSourceIdMeta,
          toSourceId.isAcceptableOrUnknown(
              data['to_source_id']!, _toSourceIdMeta));
    } else if (isInserting) {
      context.missing(_toSourceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transfer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id'])!,
      fromSourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_source_id'])!,
      toSourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_source_id'])!,
    );
  }

  @override
  $TransfersTable createAlias(String alias) {
    return $TransfersTable(attachedDatabase, alias);
  }
}

class Transfer extends DataClass implements Insertable<Transfer> {
  final int id;
  final int transactionId;
  final int fromSourceId;
  final int toSourceId;
  const Transfer(
      {required this.id,
      required this.transactionId,
      required this.fromSourceId,
      required this.toSourceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['from_source_id'] = Variable<int>(fromSourceId);
    map['to_source_id'] = Variable<int>(toSourceId);
    return map;
  }

  TransfersCompanion toCompanion(bool nullToAbsent) {
    return TransfersCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      fromSourceId: Value(fromSourceId),
      toSourceId: Value(toSourceId),
    );
  }

  factory Transfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transfer(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      fromSourceId: serializer.fromJson<int>(json['fromSourceId']),
      toSourceId: serializer.fromJson<int>(json['toSourceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'fromSourceId': serializer.toJson<int>(fromSourceId),
      'toSourceId': serializer.toJson<int>(toSourceId),
    };
  }

  Transfer copyWith(
          {int? id, int? transactionId, int? fromSourceId, int? toSourceId}) =>
      Transfer(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        fromSourceId: fromSourceId ?? this.fromSourceId,
        toSourceId: toSourceId ?? this.toSourceId,
      );
  @override
  String toString() {
    return (StringBuffer('Transfer(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('fromSourceId: $fromSourceId, ')
          ..write('toSourceId: $toSourceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transactionId, fromSourceId, toSourceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transfer &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.fromSourceId == this.fromSourceId &&
          other.toSourceId == this.toSourceId);
}

class TransfersCompanion extends UpdateCompanion<Transfer> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> fromSourceId;
  final Value<int> toSourceId;
  const TransfersCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.fromSourceId = const Value.absent(),
    this.toSourceId = const Value.absent(),
  });
  TransfersCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int fromSourceId,
    required int toSourceId,
  })  : transactionId = Value(transactionId),
        fromSourceId = Value(fromSourceId),
        toSourceId = Value(toSourceId);
  static Insertable<Transfer> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? fromSourceId,
    Expression<int>? toSourceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (fromSourceId != null) 'from_source_id': fromSourceId,
      if (toSourceId != null) 'to_source_id': toSourceId,
    });
  }

  TransfersCompanion copyWith(
      {Value<int>? id,
      Value<int>? transactionId,
      Value<int>? fromSourceId,
      Value<int>? toSourceId}) {
    return TransfersCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      fromSourceId: fromSourceId ?? this.fromSourceId,
      toSourceId: toSourceId ?? this.toSourceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (fromSourceId.present) {
      map['from_source_id'] = Variable<int>(fromSourceId.value);
    }
    if (toSourceId.present) {
      map['to_source_id'] = Variable<int>(toSourceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('fromSourceId: $fromSourceId, ')
          ..write('toSourceId: $toSourceId')
          ..write(')'))
        .toString();
  }
}

class $IncomesTable extends Incomes with TableInfo<$IncomesTable, Income> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES transactions(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _placedOnsourceIdMeta =
      const VerificationMeta('placedOnsourceId');
  @override
  late final GeneratedColumn<int> placedOnsourceId = GeneratedColumn<int>(
      'placed_onsource_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES sources(id) ON DELETE CASCADE NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, transactionId, placedOnsourceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'incomes';
  @override
  VerificationContext validateIntegrity(Insertable<Income> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('placed_onsource_id')) {
      context.handle(
          _placedOnsourceIdMeta,
          placedOnsourceId.isAcceptableOrUnknown(
              data['placed_onsource_id']!, _placedOnsourceIdMeta));
    } else if (isInserting) {
      context.missing(_placedOnsourceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Income map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Income(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id'])!,
      placedOnsourceId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}placed_onsource_id'])!,
    );
  }

  @override
  $IncomesTable createAlias(String alias) {
    return $IncomesTable(attachedDatabase, alias);
  }
}

class Income extends DataClass implements Insertable<Income> {
  final int id;
  final int transactionId;
  final int placedOnsourceId;
  const Income(
      {required this.id,
      required this.transactionId,
      required this.placedOnsourceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['placed_onsource_id'] = Variable<int>(placedOnsourceId);
    return map;
  }

  IncomesCompanion toCompanion(bool nullToAbsent) {
    return IncomesCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      placedOnsourceId: Value(placedOnsourceId),
    );
  }

  factory Income.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Income(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      placedOnsourceId: serializer.fromJson<int>(json['placedOnsourceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'placedOnsourceId': serializer.toJson<int>(placedOnsourceId),
    };
  }

  Income copyWith({int? id, int? transactionId, int? placedOnsourceId}) =>
      Income(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        placedOnsourceId: placedOnsourceId ?? this.placedOnsourceId,
      );
  @override
  String toString() {
    return (StringBuffer('Income(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('placedOnsourceId: $placedOnsourceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transactionId, placedOnsourceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Income &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.placedOnsourceId == this.placedOnsourceId);
}

class IncomesCompanion extends UpdateCompanion<Income> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> placedOnsourceId;
  const IncomesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.placedOnsourceId = const Value.absent(),
  });
  IncomesCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int placedOnsourceId,
  })  : transactionId = Value(transactionId),
        placedOnsourceId = Value(placedOnsourceId);
  static Insertable<Income> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? placedOnsourceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (placedOnsourceId != null) 'placed_onsource_id': placedOnsourceId,
    });
  }

  IncomesCompanion copyWith(
      {Value<int>? id,
      Value<int>? transactionId,
      Value<int>? placedOnsourceId}) {
    return IncomesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      placedOnsourceId: placedOnsourceId ?? this.placedOnsourceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (placedOnsourceId.present) {
      map['placed_onsource_id'] = Variable<int>(placedOnsourceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('placedOnsourceId: $placedOnsourceId')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES transactions(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES sources(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES categories(id) ON DELETE SET NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, transactionId, sourceId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int transactionId;
  final int sourceId;
  final int? categoryId;
  const Expense(
      {required this.id,
      required this.transactionId,
      required this.sourceId,
      this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<int>(transactionId);
    map['source_id'] = Variable<int>(sourceId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      sourceId: Value(sourceId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<int>(json['transactionId']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<int>(transactionId),
      'sourceId': serializer.toJson<int>(sourceId),
      'categoryId': serializer.toJson<int?>(categoryId),
    };
  }

  Expense copyWith(
          {int? id,
          int? transactionId,
          int? sourceId,
          Value<int?> categoryId = const Value.absent()}) =>
      Expense(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        sourceId: sourceId ?? this.sourceId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
      );
  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('sourceId: $sourceId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transactionId, sourceId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.sourceId == this.sourceId &&
          other.categoryId == this.categoryId);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int> transactionId;
  final Value<int> sourceId;
  final Value<int?> categoryId;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int transactionId,
    required int sourceId,
    this.categoryId = const Value.absent(),
  })  : transactionId = Value(transactionId),
        sourceId = Value(sourceId);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? transactionId,
    Expression<int>? sourceId,
    Expression<int>? categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (sourceId != null) 'source_id': sourceId,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<int>? transactionId,
      Value<int>? sourceId,
      Value<int?>? categoryId}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      sourceId: sourceId ?? this.sourceId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('sourceId: $sourceId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $PeriodsTable extends Periods with TableInfo<$PeriodsTable, Period> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, startDate, endDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'periods';
  @override
  VerificationContext validateIntegrity(Insertable<Period> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Period map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Period(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
    );
  }

  @override
  $PeriodsTable createAlias(String alias) {
    return $PeriodsTable(attachedDatabase, alias);
  }
}

class Period extends DataClass implements Insertable<Period> {
  final int id;
  final DateTime startDate;
  final DateTime? endDate;
  const Period({required this.id, required this.startDate, this.endDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  PeriodsCompanion toCompanion(bool nullToAbsent) {
    return PeriodsCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory Period.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Period(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
    };
  }

  Period copyWith(
          {int? id,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent()}) =>
      Period(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
      );
  @override
  String toString() {
    return (StringBuffer('Period(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Period &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class PeriodsCompanion extends UpdateCompanion<Period> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  const PeriodsCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  PeriodsCompanion.insert({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  static Insertable<Period> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  PeriodsCompanion copyWith(
      {Value<int>? id, Value<DateTime>? startDate, Value<DateTime?>? endDate}) {
    return PeriodsCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodsCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

class $VaultsTable extends Vaults with TableInfo<$VaultsTable, Vault> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
      'balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dateUpdatedMeta =
      const VerificationMeta('dateUpdated');
  @override
  late final GeneratedColumn<DateTime> dateUpdated = GeneratedColumn<DateTime>(
      'date_updated', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, balance, dateCreated, dateUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaults';
  @override
  VerificationContext validateIntegrity(Insertable<Vault> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    if (data.containsKey('date_updated')) {
      context.handle(
          _dateUpdatedMeta,
          dateUpdated.isAcceptableOrUnknown(
              data['date_updated']!, _dateUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vault map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vault(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_updated']),
    );
  }

  @override
  $VaultsTable createAlias(String alias) {
    return $VaultsTable(attachedDatabase, alias);
  }
}

class Vault extends DataClass implements Insertable<Vault> {
  final int id;
  final String name;
  final double balance;
  final DateTime dateCreated;
  final DateTime? dateUpdated;
  const Vault(
      {required this.id,
      required this.name,
      required this.balance,
      required this.dateCreated,
      this.dateUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['balance'] = Variable<double>(balance);
    map['date_created'] = Variable<DateTime>(dateCreated);
    if (!nullToAbsent || dateUpdated != null) {
      map['date_updated'] = Variable<DateTime>(dateUpdated);
    }
    return map;
  }

  VaultsCompanion toCompanion(bool nullToAbsent) {
    return VaultsCompanion(
      id: Value(id),
      name: Value(name),
      balance: Value(balance),
      dateCreated: Value(dateCreated),
      dateUpdated: dateUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateUpdated),
    );
  }

  factory Vault.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vault(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      balance: serializer.fromJson<double>(json['balance']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateUpdated: serializer.fromJson<DateTime?>(json['dateUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'balance': serializer.toJson<double>(balance),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateUpdated': serializer.toJson<DateTime?>(dateUpdated),
    };
  }

  Vault copyWith(
          {int? id,
          String? name,
          double? balance,
          DateTime? dateCreated,
          Value<DateTime?> dateUpdated = const Value.absent()}) =>
      Vault(
        id: id ?? this.id,
        name: name ?? this.name,
        balance: balance ?? this.balance,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated.present ? dateUpdated.value : this.dateUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('Vault(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, balance, dateCreated, dateUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vault &&
          other.id == this.id &&
          other.name == this.name &&
          other.balance == this.balance &&
          other.dateCreated == this.dateCreated &&
          other.dateUpdated == this.dateUpdated);
}

class VaultsCompanion extends UpdateCompanion<Vault> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> balance;
  final Value<DateTime> dateCreated;
  final Value<DateTime?> dateUpdated;
  const VaultsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.balance = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
  });
  VaultsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.balance = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Vault> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? balance,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (balance != null) 'balance': balance,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateUpdated != null) 'date_updated': dateUpdated,
    });
  }

  VaultsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? balance,
      Value<DateTime>? dateCreated,
      Value<DateTime?>? dateUpdated}) {
    return VaultsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<DateTime>(dateUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaultsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated')
          ..write(')'))
        .toString();
  }
}

class $SavingsTable extends Savings with TableInfo<$SavingsTable, Saving> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _vaultIdMeta =
      const VerificationMeta('vaultId');
  @override
  late final GeneratedColumn<int> vaultId = GeneratedColumn<int>(
      'vault_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES vaults(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _goalAmountMeta =
      const VerificationMeta('goalAmount');
  @override
  late final GeneratedColumn<double> goalAmount = GeneratedColumn<double>(
      'goal_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _goalEndDateMeta =
      const VerificationMeta('goalEndDate');
  @override
  late final GeneratedColumn<DateTime> goalEndDate = GeneratedColumn<DateTime>(
      'goal_end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dateUpdatedMeta =
      const VerificationMeta('dateUpdated');
  @override
  late final GeneratedColumn<DateTime> dateUpdated = GeneratedColumn<DateTime>(
      'date_updated', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, amount, vaultId, goalAmount, goalEndDate, dateCreated, dateUpdated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings';
  @override
  VerificationContext validateIntegrity(Insertable<Saving> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('vault_id')) {
      context.handle(_vaultIdMeta,
          vaultId.isAcceptableOrUnknown(data['vault_id']!, _vaultIdMeta));
    } else if (isInserting) {
      context.missing(_vaultIdMeta);
    }
    if (data.containsKey('goal_amount')) {
      context.handle(
          _goalAmountMeta,
          goalAmount.isAcceptableOrUnknown(
              data['goal_amount']!, _goalAmountMeta));
    }
    if (data.containsKey('goal_end_date')) {
      context.handle(
          _goalEndDateMeta,
          goalEndDate.isAcceptableOrUnknown(
              data['goal_end_date']!, _goalEndDateMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    if (data.containsKey('date_updated')) {
      context.handle(
          _dateUpdatedMeta,
          dateUpdated.isAcceptableOrUnknown(
              data['date_updated']!, _dateUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Saving map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Saving(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      vaultId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vault_id'])!,
      goalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}goal_amount']),
      goalEndDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}goal_end_date']),
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_updated']),
    );
  }

  @override
  $SavingsTable createAlias(String alias) {
    return $SavingsTable(attachedDatabase, alias);
  }
}

class Saving extends DataClass implements Insertable<Saving> {
  final int id;
  final double amount;
  final int vaultId;
  final double? goalAmount;
  final DateTime? goalEndDate;
  final DateTime dateCreated;
  final DateTime? dateUpdated;
  const Saving(
      {required this.id,
      required this.amount,
      required this.vaultId,
      this.goalAmount,
      this.goalEndDate,
      required this.dateCreated,
      this.dateUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['vault_id'] = Variable<int>(vaultId);
    if (!nullToAbsent || goalAmount != null) {
      map['goal_amount'] = Variable<double>(goalAmount);
    }
    if (!nullToAbsent || goalEndDate != null) {
      map['goal_end_date'] = Variable<DateTime>(goalEndDate);
    }
    map['date_created'] = Variable<DateTime>(dateCreated);
    if (!nullToAbsent || dateUpdated != null) {
      map['date_updated'] = Variable<DateTime>(dateUpdated);
    }
    return map;
  }

  SavingsCompanion toCompanion(bool nullToAbsent) {
    return SavingsCompanion(
      id: Value(id),
      amount: Value(amount),
      vaultId: Value(vaultId),
      goalAmount: goalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(goalAmount),
      goalEndDate: goalEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(goalEndDate),
      dateCreated: Value(dateCreated),
      dateUpdated: dateUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateUpdated),
    );
  }

  factory Saving.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Saving(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      vaultId: serializer.fromJson<int>(json['vaultId']),
      goalAmount: serializer.fromJson<double?>(json['goalAmount']),
      goalEndDate: serializer.fromJson<DateTime?>(json['goalEndDate']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateUpdated: serializer.fromJson<DateTime?>(json['dateUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'vaultId': serializer.toJson<int>(vaultId),
      'goalAmount': serializer.toJson<double?>(goalAmount),
      'goalEndDate': serializer.toJson<DateTime?>(goalEndDate),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateUpdated': serializer.toJson<DateTime?>(dateUpdated),
    };
  }

  Saving copyWith(
          {int? id,
          double? amount,
          int? vaultId,
          Value<double?> goalAmount = const Value.absent(),
          Value<DateTime?> goalEndDate = const Value.absent(),
          DateTime? dateCreated,
          Value<DateTime?> dateUpdated = const Value.absent()}) =>
      Saving(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        vaultId: vaultId ?? this.vaultId,
        goalAmount: goalAmount.present ? goalAmount.value : this.goalAmount,
        goalEndDate: goalEndDate.present ? goalEndDate.value : this.goalEndDate,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated.present ? dateUpdated.value : this.dateUpdated,
      );
  @override
  String toString() {
    return (StringBuffer('Saving(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('vaultId: $vaultId, ')
          ..write('goalAmount: $goalAmount, ')
          ..write('goalEndDate: $goalEndDate, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, amount, vaultId, goalAmount, goalEndDate, dateCreated, dateUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Saving &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.vaultId == this.vaultId &&
          other.goalAmount == this.goalAmount &&
          other.goalEndDate == this.goalEndDate &&
          other.dateCreated == this.dateCreated &&
          other.dateUpdated == this.dateUpdated);
}

class SavingsCompanion extends UpdateCompanion<Saving> {
  final Value<int> id;
  final Value<double> amount;
  final Value<int> vaultId;
  final Value<double?> goalAmount;
  final Value<DateTime?> goalEndDate;
  final Value<DateTime> dateCreated;
  final Value<DateTime?> dateUpdated;
  const SavingsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.vaultId = const Value.absent(),
    this.goalAmount = const Value.absent(),
    this.goalEndDate = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
  });
  SavingsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required int vaultId,
    this.goalAmount = const Value.absent(),
    this.goalEndDate = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
  })  : amount = Value(amount),
        vaultId = Value(vaultId);
  static Insertable<Saving> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<int>? vaultId,
    Expression<double>? goalAmount,
    Expression<DateTime>? goalEndDate,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (vaultId != null) 'vault_id': vaultId,
      if (goalAmount != null) 'goal_amount': goalAmount,
      if (goalEndDate != null) 'goal_end_date': goalEndDate,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateUpdated != null) 'date_updated': dateUpdated,
    });
  }

  SavingsCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<int>? vaultId,
      Value<double?>? goalAmount,
      Value<DateTime?>? goalEndDate,
      Value<DateTime>? dateCreated,
      Value<DateTime?>? dateUpdated}) {
    return SavingsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      vaultId: vaultId ?? this.vaultId,
      goalAmount: goalAmount ?? this.goalAmount,
      goalEndDate: goalEndDate ?? this.goalEndDate,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (vaultId.present) {
      map['vault_id'] = Variable<int>(vaultId.value);
    }
    if (goalAmount.present) {
      map['goal_amount'] = Variable<double>(goalAmount.value);
    }
    if (goalEndDate.present) {
      map['goal_end_date'] = Variable<DateTime>(goalEndDate.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<DateTime>(dateUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('vaultId: $vaultId, ')
          ..write('goalAmount: $goalAmount, ')
          ..write('goalEndDate: $goalEndDate, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated')
          ..write(')'))
        .toString();
  }
}

class $SavingsLogsTable extends SavingsLogs
    with TableInfo<$SavingsLogsTable, SavingsLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _dateUpdatedMeta =
      const VerificationMeta('dateUpdated');
  @override
  late final GeneratedColumn<DateTime> dateUpdated = GeneratedColumn<DateTime>(
      'date_updated', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<SavingTransactionTypes, int>
      type = GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<SavingTransactionTypes>(
              $SavingsLogsTable.$convertertype);
  @override
  List<GeneratedColumn> get $columns =>
      [id, amount, date, dateCreated, dateUpdated, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_logs';
  @override
  VerificationContext validateIntegrity(Insertable<SavingsLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    if (data.containsKey('date_updated')) {
      context.handle(
          _dateUpdatedMeta,
          dateUpdated.isAcceptableOrUnknown(
              data['date_updated']!, _dateUpdatedMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_updated']),
      type: $SavingsLogsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
    );
  }

  @override
  $SavingsLogsTable createAlias(String alias) {
    return $SavingsLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SavingTransactionTypes, int, int> $convertertype =
      const EnumIndexConverter<SavingTransactionTypes>(
          SavingTransactionTypes.values);
}

class SavingsLog extends DataClass implements Insertable<SavingsLog> {
  final int id;
  final double amount;
  final DateTime date;
  final DateTime dateCreated;
  final DateTime? dateUpdated;
  final SavingTransactionTypes type;
  const SavingsLog(
      {required this.id,
      required this.amount,
      required this.date,
      required this.dateCreated,
      this.dateUpdated,
      required this.type});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['date_created'] = Variable<DateTime>(dateCreated);
    if (!nullToAbsent || dateUpdated != null) {
      map['date_updated'] = Variable<DateTime>(dateUpdated);
    }
    {
      map['type'] = Variable<int>($SavingsLogsTable.$convertertype.toSql(type));
    }
    return map;
  }

  SavingsLogsCompanion toCompanion(bool nullToAbsent) {
    return SavingsLogsCompanion(
      id: Value(id),
      amount: Value(amount),
      date: Value(date),
      dateCreated: Value(dateCreated),
      dateUpdated: dateUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(dateUpdated),
      type: Value(type),
    );
  }

  factory SavingsLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsLog(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateUpdated: serializer.fromJson<DateTime?>(json['dateUpdated']),
      type: $SavingsLogsTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateUpdated': serializer.toJson<DateTime?>(dateUpdated),
      'type':
          serializer.toJson<int>($SavingsLogsTable.$convertertype.toJson(type)),
    };
  }

  SavingsLog copyWith(
          {int? id,
          double? amount,
          DateTime? date,
          DateTime? dateCreated,
          Value<DateTime?> dateUpdated = const Value.absent(),
          SavingTransactionTypes? type}) =>
      SavingsLog(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        dateCreated: dateCreated ?? this.dateCreated,
        dateUpdated: dateUpdated.present ? dateUpdated.value : this.dateUpdated,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('SavingsLog(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, amount, date, dateCreated, dateUpdated, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsLog &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.dateCreated == this.dateCreated &&
          other.dateUpdated == this.dateUpdated &&
          other.type == this.type);
}

class SavingsLogsCompanion extends UpdateCompanion<SavingsLog> {
  final Value<int> id;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<DateTime> dateCreated;
  final Value<DateTime?> dateUpdated;
  final Value<SavingTransactionTypes> type;
  const SavingsLogsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    this.type = const Value.absent(),
  });
  SavingsLogsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    required DateTime date,
    this.dateCreated = const Value.absent(),
    this.dateUpdated = const Value.absent(),
    required SavingTransactionTypes type,
  })  : amount = Value(amount),
        date = Value(date),
        type = Value(type);
  static Insertable<SavingsLog> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateUpdated,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateUpdated != null) 'date_updated': dateUpdated,
      if (type != null) 'type': type,
    });
  }

  SavingsLogsCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<DateTime>? dateCreated,
      Value<DateTime?>? dateUpdated,
      Value<SavingTransactionTypes>? type}) {
    return SavingsLogsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      dateCreated: dateCreated ?? this.dateCreated,
      dateUpdated: dateUpdated ?? this.dateUpdated,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<DateTime>(dateUpdated.value);
    }
    if (type.present) {
      map['type'] =
          Variable<int>($SavingsLogsTable.$convertertype.toSql(type.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsLogsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateUpdated: $dateUpdated, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $SavingsInsTable extends SavingsIns
    with TableInfo<$SavingsInsTable, SavingsIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _savingsLogIdMeta =
      const VerificationMeta('savingsLogId');
  @override
  late final GeneratedColumn<int> savingsLogId = GeneratedColumn<int>(
      'savings_log_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES savings_logs(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _savingsIdMeta =
      const VerificationMeta('savingsId');
  @override
  late final GeneratedColumn<int> savingsId = GeneratedColumn<int>(
      'savings_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES savings(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES sources(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, savingsLogId, savingsId, sourceId, amount, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_ins';
  @override
  VerificationContext validateIntegrity(Insertable<SavingsIn> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('savings_log_id')) {
      context.handle(
          _savingsLogIdMeta,
          savingsLogId.isAcceptableOrUnknown(
              data['savings_log_id']!, _savingsLogIdMeta));
    } else if (isInserting) {
      context.missing(_savingsLogIdMeta);
    }
    if (data.containsKey('savings_id')) {
      context.handle(_savingsIdMeta,
          savingsId.isAcceptableOrUnknown(data['savings_id']!, _savingsIdMeta));
    } else if (isInserting) {
      context.missing(_savingsIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsIn(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      savingsLogId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}savings_log_id'])!,
      savingsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}savings_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $SavingsInsTable createAlias(String alias) {
    return $SavingsInsTable(attachedDatabase, alias);
  }
}

class SavingsIn extends DataClass implements Insertable<SavingsIn> {
  final int id;
  final int savingsLogId;
  final int savingsId;
  final int sourceId;
  final double amount;
  final DateTime date;
  const SavingsIn(
      {required this.id,
      required this.savingsLogId,
      required this.savingsId,
      required this.sourceId,
      required this.amount,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['savings_log_id'] = Variable<int>(savingsLogId);
    map['savings_id'] = Variable<int>(savingsId);
    map['source_id'] = Variable<int>(sourceId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  SavingsInsCompanion toCompanion(bool nullToAbsent) {
    return SavingsInsCompanion(
      id: Value(id),
      savingsLogId: Value(savingsLogId),
      savingsId: Value(savingsId),
      sourceId: Value(sourceId),
      amount: Value(amount),
      date: Value(date),
    );
  }

  factory SavingsIn.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsIn(
      id: serializer.fromJson<int>(json['id']),
      savingsLogId: serializer.fromJson<int>(json['savingsLogId']),
      savingsId: serializer.fromJson<int>(json['savingsId']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'savingsLogId': serializer.toJson<int>(savingsLogId),
      'savingsId': serializer.toJson<int>(savingsId),
      'sourceId': serializer.toJson<int>(sourceId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  SavingsIn copyWith(
          {int? id,
          int? savingsLogId,
          int? savingsId,
          int? sourceId,
          double? amount,
          DateTime? date}) =>
      SavingsIn(
        id: id ?? this.id,
        savingsLogId: savingsLogId ?? this.savingsLogId,
        savingsId: savingsId ?? this.savingsId,
        sourceId: sourceId ?? this.sourceId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('SavingsIn(')
          ..write('id: $id, ')
          ..write('savingsLogId: $savingsLogId, ')
          ..write('savingsId: $savingsId, ')
          ..write('sourceId: $sourceId, ')
          ..write('amount: $amount, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, savingsLogId, savingsId, sourceId, amount, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsIn &&
          other.id == this.id &&
          other.savingsLogId == this.savingsLogId &&
          other.savingsId == this.savingsId &&
          other.sourceId == this.sourceId &&
          other.amount == this.amount &&
          other.date == this.date);
}

class SavingsInsCompanion extends UpdateCompanion<SavingsIn> {
  final Value<int> id;
  final Value<int> savingsLogId;
  final Value<int> savingsId;
  final Value<int> sourceId;
  final Value<double> amount;
  final Value<DateTime> date;
  const SavingsInsCompanion({
    this.id = const Value.absent(),
    this.savingsLogId = const Value.absent(),
    this.savingsId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
  });
  SavingsInsCompanion.insert({
    this.id = const Value.absent(),
    required int savingsLogId,
    required int savingsId,
    required int sourceId,
    required double amount,
    required DateTime date,
  })  : savingsLogId = Value(savingsLogId),
        savingsId = Value(savingsId),
        sourceId = Value(sourceId),
        amount = Value(amount),
        date = Value(date);
  static Insertable<SavingsIn> custom({
    Expression<int>? id,
    Expression<int>? savingsLogId,
    Expression<int>? savingsId,
    Expression<int>? sourceId,
    Expression<double>? amount,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (savingsLogId != null) 'savings_log_id': savingsLogId,
      if (savingsId != null) 'savings_id': savingsId,
      if (sourceId != null) 'source_id': sourceId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
    });
  }

  SavingsInsCompanion copyWith(
      {Value<int>? id,
      Value<int>? savingsLogId,
      Value<int>? savingsId,
      Value<int>? sourceId,
      Value<double>? amount,
      Value<DateTime>? date}) {
    return SavingsInsCompanion(
      id: id ?? this.id,
      savingsLogId: savingsLogId ?? this.savingsLogId,
      savingsId: savingsId ?? this.savingsId,
      sourceId: sourceId ?? this.sourceId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (savingsLogId.present) {
      map['savings_log_id'] = Variable<int>(savingsLogId.value);
    }
    if (savingsId.present) {
      map['savings_id'] = Variable<int>(savingsId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsInsCompanion(')
          ..write('id: $id, ')
          ..write('savingsLogId: $savingsLogId, ')
          ..write('savingsId: $savingsId, ')
          ..write('sourceId: $sourceId, ')
          ..write('amount: $amount, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $SavingsOutsTable extends SavingsOuts
    with TableInfo<$SavingsOutsTable, SavingsOut> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsOutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _savingsLogIdMeta =
      const VerificationMeta('savingsLogId');
  @override
  late final GeneratedColumn<int> savingsLogId = GeneratedColumn<int>(
      'savings_log_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES savings_logs(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _savingsIdMeta =
      const VerificationMeta('savingsId');
  @override
  late final GeneratedColumn<int> savingsId = GeneratedColumn<int>(
      'savings_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES savings(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<int> sourceId = GeneratedColumn<int>(
      'source_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES sources(id) ON DELETE CASCADE NOT NULL');
  @override
  List<GeneratedColumn> get $columns => [id, savingsLogId, savingsId, sourceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_outs';
  @override
  VerificationContext validateIntegrity(Insertable<SavingsOut> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('savings_log_id')) {
      context.handle(
          _savingsLogIdMeta,
          savingsLogId.isAcceptableOrUnknown(
              data['savings_log_id']!, _savingsLogIdMeta));
    } else if (isInserting) {
      context.missing(_savingsLogIdMeta);
    }
    if (data.containsKey('savings_id')) {
      context.handle(_savingsIdMeta,
          savingsId.isAcceptableOrUnknown(data['savings_id']!, _savingsIdMeta));
    } else if (isInserting) {
      context.missing(_savingsIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsOut map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsOut(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      savingsLogId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}savings_log_id'])!,
      savingsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}savings_id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_id'])!,
    );
  }

  @override
  $SavingsOutsTable createAlias(String alias) {
    return $SavingsOutsTable(attachedDatabase, alias);
  }
}

class SavingsOut extends DataClass implements Insertable<SavingsOut> {
  final int id;
  final int savingsLogId;
  final int savingsId;
  final int sourceId;
  const SavingsOut(
      {required this.id,
      required this.savingsLogId,
      required this.savingsId,
      required this.sourceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['savings_log_id'] = Variable<int>(savingsLogId);
    map['savings_id'] = Variable<int>(savingsId);
    map['source_id'] = Variable<int>(sourceId);
    return map;
  }

  SavingsOutsCompanion toCompanion(bool nullToAbsent) {
    return SavingsOutsCompanion(
      id: Value(id),
      savingsLogId: Value(savingsLogId),
      savingsId: Value(savingsId),
      sourceId: Value(sourceId),
    );
  }

  factory SavingsOut.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsOut(
      id: serializer.fromJson<int>(json['id']),
      savingsLogId: serializer.fromJson<int>(json['savingsLogId']),
      savingsId: serializer.fromJson<int>(json['savingsId']),
      sourceId: serializer.fromJson<int>(json['sourceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'savingsLogId': serializer.toJson<int>(savingsLogId),
      'savingsId': serializer.toJson<int>(savingsId),
      'sourceId': serializer.toJson<int>(sourceId),
    };
  }

  SavingsOut copyWith(
          {int? id, int? savingsLogId, int? savingsId, int? sourceId}) =>
      SavingsOut(
        id: id ?? this.id,
        savingsLogId: savingsLogId ?? this.savingsLogId,
        savingsId: savingsId ?? this.savingsId,
        sourceId: sourceId ?? this.sourceId,
      );
  @override
  String toString() {
    return (StringBuffer('SavingsOut(')
          ..write('id: $id, ')
          ..write('savingsLogId: $savingsLogId, ')
          ..write('savingsId: $savingsId, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, savingsLogId, savingsId, sourceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsOut &&
          other.id == this.id &&
          other.savingsLogId == this.savingsLogId &&
          other.savingsId == this.savingsId &&
          other.sourceId == this.sourceId);
}

class SavingsOutsCompanion extends UpdateCompanion<SavingsOut> {
  final Value<int> id;
  final Value<int> savingsLogId;
  final Value<int> savingsId;
  final Value<int> sourceId;
  const SavingsOutsCompanion({
    this.id = const Value.absent(),
    this.savingsLogId = const Value.absent(),
    this.savingsId = const Value.absent(),
    this.sourceId = const Value.absent(),
  });
  SavingsOutsCompanion.insert({
    this.id = const Value.absent(),
    required int savingsLogId,
    required int savingsId,
    required int sourceId,
  })  : savingsLogId = Value(savingsLogId),
        savingsId = Value(savingsId),
        sourceId = Value(sourceId);
  static Insertable<SavingsOut> custom({
    Expression<int>? id,
    Expression<int>? savingsLogId,
    Expression<int>? savingsId,
    Expression<int>? sourceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (savingsLogId != null) 'savings_log_id': savingsLogId,
      if (savingsId != null) 'savings_id': savingsId,
      if (sourceId != null) 'source_id': sourceId,
    });
  }

  SavingsOutsCompanion copyWith(
      {Value<int>? id,
      Value<int>? savingsLogId,
      Value<int>? savingsId,
      Value<int>? sourceId}) {
    return SavingsOutsCompanion(
      id: id ?? this.id,
      savingsLogId: savingsLogId ?? this.savingsLogId,
      savingsId: savingsId ?? this.savingsId,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (savingsLogId.present) {
      map['savings_log_id'] = Variable<int>(savingsLogId.value);
    }
    if (savingsId.present) {
      map['savings_id'] = Variable<int>(savingsId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<int>(sourceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsOutsCompanion(')
          ..write('id: $id, ')
          ..write('savingsLogId: $savingsLogId, ')
          ..write('savingsId: $savingsId, ')
          ..write('sourceId: $sourceId')
          ..write(')'))
        .toString();
  }
}

class $SavingsTransfersTable extends SavingsTransfers
    with TableInfo<$SavingsTransfersTable, SavingsTransfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsTransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _savingsLogIdMeta =
      const VerificationMeta('savingsLogId');
  @override
  late final GeneratedColumn<int> savingsLogId = GeneratedColumn<int>(
      'savings_log_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints:
          'REFERENCES savings_logs(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _fromSavingsIdMeta =
      const VerificationMeta('fromSavingsId');
  @override
  late final GeneratedColumn<int> fromSavingsId = GeneratedColumn<int>(
      'from_savings_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES savings(id) ON DELETE CASCADE NOT NULL');
  static const VerificationMeta _toSavingsIdMeta =
      const VerificationMeta('toSavingsId');
  @override
  late final GeneratedColumn<int> toSavingsId = GeneratedColumn<int>(
      'to_savings_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES savings(id) ON DELETE CASCADE NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, savingsLogId, fromSavingsId, toSavingsId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_transfers';
  @override
  VerificationContext validateIntegrity(Insertable<SavingsTransfer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('savings_log_id')) {
      context.handle(
          _savingsLogIdMeta,
          savingsLogId.isAcceptableOrUnknown(
              data['savings_log_id']!, _savingsLogIdMeta));
    } else if (isInserting) {
      context.missing(_savingsLogIdMeta);
    }
    if (data.containsKey('from_savings_id')) {
      context.handle(
          _fromSavingsIdMeta,
          fromSavingsId.isAcceptableOrUnknown(
              data['from_savings_id']!, _fromSavingsIdMeta));
    } else if (isInserting) {
      context.missing(_fromSavingsIdMeta);
    }
    if (data.containsKey('to_savings_id')) {
      context.handle(
          _toSavingsIdMeta,
          toSavingsId.isAcceptableOrUnknown(
              data['to_savings_id']!, _toSavingsIdMeta));
    } else if (isInserting) {
      context.missing(_toSavingsIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsTransfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsTransfer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      savingsLogId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}savings_log_id'])!,
      fromSavingsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}from_savings_id'])!,
      toSavingsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}to_savings_id'])!,
    );
  }

  @override
  $SavingsTransfersTable createAlias(String alias) {
    return $SavingsTransfersTable(attachedDatabase, alias);
  }
}

class SavingsTransfer extends DataClass implements Insertable<SavingsTransfer> {
  final int id;
  final int savingsLogId;
  final int fromSavingsId;
  final int toSavingsId;
  const SavingsTransfer(
      {required this.id,
      required this.savingsLogId,
      required this.fromSavingsId,
      required this.toSavingsId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['savings_log_id'] = Variable<int>(savingsLogId);
    map['from_savings_id'] = Variable<int>(fromSavingsId);
    map['to_savings_id'] = Variable<int>(toSavingsId);
    return map;
  }

  SavingsTransfersCompanion toCompanion(bool nullToAbsent) {
    return SavingsTransfersCompanion(
      id: Value(id),
      savingsLogId: Value(savingsLogId),
      fromSavingsId: Value(fromSavingsId),
      toSavingsId: Value(toSavingsId),
    );
  }

  factory SavingsTransfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsTransfer(
      id: serializer.fromJson<int>(json['id']),
      savingsLogId: serializer.fromJson<int>(json['savingsLogId']),
      fromSavingsId: serializer.fromJson<int>(json['fromSavingsId']),
      toSavingsId: serializer.fromJson<int>(json['toSavingsId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'savingsLogId': serializer.toJson<int>(savingsLogId),
      'fromSavingsId': serializer.toJson<int>(fromSavingsId),
      'toSavingsId': serializer.toJson<int>(toSavingsId),
    };
  }

  SavingsTransfer copyWith(
          {int? id, int? savingsLogId, int? fromSavingsId, int? toSavingsId}) =>
      SavingsTransfer(
        id: id ?? this.id,
        savingsLogId: savingsLogId ?? this.savingsLogId,
        fromSavingsId: fromSavingsId ?? this.fromSavingsId,
        toSavingsId: toSavingsId ?? this.toSavingsId,
      );
  @override
  String toString() {
    return (StringBuffer('SavingsTransfer(')
          ..write('id: $id, ')
          ..write('savingsLogId: $savingsLogId, ')
          ..write('fromSavingsId: $fromSavingsId, ')
          ..write('toSavingsId: $toSavingsId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, savingsLogId, fromSavingsId, toSavingsId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsTransfer &&
          other.id == this.id &&
          other.savingsLogId == this.savingsLogId &&
          other.fromSavingsId == this.fromSavingsId &&
          other.toSavingsId == this.toSavingsId);
}

class SavingsTransfersCompanion extends UpdateCompanion<SavingsTransfer> {
  final Value<int> id;
  final Value<int> savingsLogId;
  final Value<int> fromSavingsId;
  final Value<int> toSavingsId;
  const SavingsTransfersCompanion({
    this.id = const Value.absent(),
    this.savingsLogId = const Value.absent(),
    this.fromSavingsId = const Value.absent(),
    this.toSavingsId = const Value.absent(),
  });
  SavingsTransfersCompanion.insert({
    this.id = const Value.absent(),
    required int savingsLogId,
    required int fromSavingsId,
    required int toSavingsId,
  })  : savingsLogId = Value(savingsLogId),
        fromSavingsId = Value(fromSavingsId),
        toSavingsId = Value(toSavingsId);
  static Insertable<SavingsTransfer> custom({
    Expression<int>? id,
    Expression<int>? savingsLogId,
    Expression<int>? fromSavingsId,
    Expression<int>? toSavingsId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (savingsLogId != null) 'savings_log_id': savingsLogId,
      if (fromSavingsId != null) 'from_savings_id': fromSavingsId,
      if (toSavingsId != null) 'to_savings_id': toSavingsId,
    });
  }

  SavingsTransfersCompanion copyWith(
      {Value<int>? id,
      Value<int>? savingsLogId,
      Value<int>? fromSavingsId,
      Value<int>? toSavingsId}) {
    return SavingsTransfersCompanion(
      id: id ?? this.id,
      savingsLogId: savingsLogId ?? this.savingsLogId,
      fromSavingsId: fromSavingsId ?? this.fromSavingsId,
      toSavingsId: toSavingsId ?? this.toSavingsId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (savingsLogId.present) {
      map['savings_log_id'] = Variable<int>(savingsLogId.value);
    }
    if (fromSavingsId.present) {
      map['from_savings_id'] = Variable<int>(fromSavingsId.value);
    }
    if (toSavingsId.present) {
      map['to_savings_id'] = Variable<int>(toSavingsId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsTransfersCompanion(')
          ..write('id: $id, ')
          ..write('savingsLogId: $savingsLogId, ')
          ..write('fromSavingsId: $fromSavingsId, ')
          ..write('toSavingsId: $toSavingsId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SourcesTable sources = $SourcesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransfersTable transfers = $TransfersTable(this);
  late final $IncomesTable incomes = $IncomesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $PeriodsTable periods = $PeriodsTable(this);
  late final $VaultsTable vaults = $VaultsTable(this);
  late final $SavingsTable savings = $SavingsTable(this);
  late final $SavingsLogsTable savingsLogs = $SavingsLogsTable(this);
  late final $SavingsInsTable savingsIns = $SavingsInsTable(this);
  late final $SavingsOutsTable savingsOuts = $SavingsOutsTable(this);
  late final $SavingsTransfersTable savingsTransfers =
      $SavingsTransfersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        sources,
        transactions,
        transfers,
        incomes,
        expenses,
        periods,
        vaults,
        savings,
        savingsLogs,
        savingsIns,
        savingsOuts,
        savingsTransfers
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('transactions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('transfers', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('sources',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('transfers', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('sources',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('transfers', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('transactions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('incomes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('sources',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('incomes', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('transactions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expenses', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('sources',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expenses', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expenses', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('vaults',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('savings_logs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings_ins', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('savings',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings_ins', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('sources',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings_ins', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('savings_logs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings_outs', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('savings',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings_outs', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('sources',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings_outs', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('savings_logs',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings_transfers', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('savings',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings_transfers', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('savings',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('savings_transfers', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
