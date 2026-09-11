// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FacultadesTable extends Facultades
    with TableInfo<$FacultadesTable, Facultade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FacultadesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'facultades';
  @override
  VerificationContext validateIntegrity(
    Insertable<Facultade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Facultade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Facultade(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $FacultadesTable createAlias(String alias) {
    return $FacultadesTable(attachedDatabase, alias);
  }
}

class Facultade extends DataClass implements Insertable<Facultade> {
  final int id;
  final String nombre;
  const Facultade({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  FacultadesCompanion toCompanion(bool nullToAbsent) {
    return FacultadesCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory Facultade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Facultade(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  Facultade copyWith({int? id, String? nombre}) =>
      Facultade(id: id ?? this.id, nombre: nombre ?? this.nombre);
  Facultade copyWithCompanion(FacultadesCompanion data) {
    return Facultade(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Facultade(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Facultade &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class FacultadesCompanion extends UpdateCompanion<Facultade> {
  final Value<int> id;
  final Value<String> nombre;
  const FacultadesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  FacultadesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<Facultade> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  FacultadesCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return FacultadesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FacultadesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $MateriasTable extends Materias with TableInfo<$MateriasTable, Materia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MateriasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _facultadIdMeta = const VerificationMeta(
    'facultadId',
  );
  @override
  late final GeneratedColumn<int> facultadId = GeneratedColumn<int>(
    'facultad_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES facultades (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, facultadId, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'materias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Materia> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('facultad_id')) {
      context.handle(
        _facultadIdMeta,
        facultadId.isAcceptableOrUnknown(data['facultad_id']!, _facultadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_facultadIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Materia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Materia(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      facultadId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}facultad_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $MateriasTable createAlias(String alias) {
    return $MateriasTable(attachedDatabase, alias);
  }
}

class Materia extends DataClass implements Insertable<Materia> {
  final int id;
  final int facultadId;
  final String nombre;
  const Materia({
    required this.id,
    required this.facultadId,
    required this.nombre,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['facultad_id'] = Variable<int>(facultadId);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  MateriasCompanion toCompanion(bool nullToAbsent) {
    return MateriasCompanion(
      id: Value(id),
      facultadId: Value(facultadId),
      nombre: Value(nombre),
    );
  }

  factory Materia.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Materia(
      id: serializer.fromJson<int>(json['id']),
      facultadId: serializer.fromJson<int>(json['facultadId']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'facultadId': serializer.toJson<int>(facultadId),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  Materia copyWith({int? id, int? facultadId, String? nombre}) => Materia(
    id: id ?? this.id,
    facultadId: facultadId ?? this.facultadId,
    nombre: nombre ?? this.nombre,
  );
  Materia copyWithCompanion(MateriasCompanion data) {
    return Materia(
      id: data.id.present ? data.id.value : this.id,
      facultadId: data.facultadId.present
          ? data.facultadId.value
          : this.facultadId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Materia(')
          ..write('id: $id, ')
          ..write('facultadId: $facultadId, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, facultadId, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Materia &&
          other.id == this.id &&
          other.facultadId == this.facultadId &&
          other.nombre == this.nombre);
}

class MateriasCompanion extends UpdateCompanion<Materia> {
  final Value<int> id;
  final Value<int> facultadId;
  final Value<String> nombre;
  const MateriasCompanion({
    this.id = const Value.absent(),
    this.facultadId = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  MateriasCompanion.insert({
    this.id = const Value.absent(),
    required int facultadId,
    required String nombre,
  }) : facultadId = Value(facultadId),
       nombre = Value(nombre);
  static Insertable<Materia> custom({
    Expression<int>? id,
    Expression<int>? facultadId,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (facultadId != null) 'facultad_id': facultadId,
      if (nombre != null) 'nombre': nombre,
    });
  }

  MateriasCompanion copyWith({
    Value<int>? id,
    Value<int>? facultadId,
    Value<String>? nombre,
  }) {
    return MateriasCompanion(
      id: id ?? this.id,
      facultadId: facultadId ?? this.facultadId,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (facultadId.present) {
      map['facultad_id'] = Variable<int>(facultadId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MateriasCompanion(')
          ..write('id: $id, ')
          ..write('facultadId: $facultadId, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $TemasTable extends Temas with TableInfo<$TemasTable, Tema> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _materiaIdMeta = const VerificationMeta(
    'materiaId',
  );
  @override
  late final GeneratedColumn<int> materiaId = GeneratedColumn<int>(
    'materia_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES materias (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, materiaId, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'temas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tema> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('materia_id')) {
      context.handle(
        _materiaIdMeta,
        materiaId.isAcceptableOrUnknown(data['materia_id']!, _materiaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_materiaIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tema map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tema(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      materiaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}materia_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  $TemasTable createAlias(String alias) {
    return $TemasTable(attachedDatabase, alias);
  }
}

class Tema extends DataClass implements Insertable<Tema> {
  final int id;
  final int materiaId;
  final String nombre;
  const Tema({required this.id, required this.materiaId, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['materia_id'] = Variable<int>(materiaId);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  TemasCompanion toCompanion(bool nullToAbsent) {
    return TemasCompanion(
      id: Value(id),
      materiaId: Value(materiaId),
      nombre: Value(nombre),
    );
  }

  factory Tema.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tema(
      id: serializer.fromJson<int>(json['id']),
      materiaId: serializer.fromJson<int>(json['materiaId']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'materiaId': serializer.toJson<int>(materiaId),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  Tema copyWith({int? id, int? materiaId, String? nombre}) => Tema(
    id: id ?? this.id,
    materiaId: materiaId ?? this.materiaId,
    nombre: nombre ?? this.nombre,
  );
  Tema copyWithCompanion(TemasCompanion data) {
    return Tema(
      id: data.id.present ? data.id.value : this.id,
      materiaId: data.materiaId.present ? data.materiaId.value : this.materiaId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tema(')
          ..write('id: $id, ')
          ..write('materiaId: $materiaId, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, materiaId, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tema &&
          other.id == this.id &&
          other.materiaId == this.materiaId &&
          other.nombre == this.nombre);
}

class TemasCompanion extends UpdateCompanion<Tema> {
  final Value<int> id;
  final Value<int> materiaId;
  final Value<String> nombre;
  const TemasCompanion({
    this.id = const Value.absent(),
    this.materiaId = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  TemasCompanion.insert({
    this.id = const Value.absent(),
    required int materiaId,
    required String nombre,
  }) : materiaId = Value(materiaId),
       nombre = Value(nombre);
  static Insertable<Tema> custom({
    Expression<int>? id,
    Expression<int>? materiaId,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (materiaId != null) 'materia_id': materiaId,
      if (nombre != null) 'nombre': nombre,
    });
  }

  TemasCompanion copyWith({
    Value<int>? id,
    Value<int>? materiaId,
    Value<String>? nombre,
  }) {
    return TemasCompanion(
      id: id ?? this.id,
      materiaId: materiaId ?? this.materiaId,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (materiaId.present) {
      map['materia_id'] = Variable<int>(materiaId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemasCompanion(')
          ..write('id: $id, ')
          ..write('materiaId: $materiaId, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class $PreguntasTable extends Preguntas
    with TableInfo<$PreguntasTable, Pregunta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreguntasTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _temaIdMeta = const VerificationMeta('temaId');
  @override
  late final GeneratedColumn<int> temaId = GeneratedColumn<int>(
    'tema_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES temas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _enunciadoMeta = const VerificationMeta(
    'enunciado',
  );
  @override
  late final GeneratedColumn<String> enunciado = GeneratedColumn<String>(
    'enunciado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explicacionMeta = const VerificationMeta(
    'explicacion',
  );
  @override
  late final GeneratedColumn<String> explicacion = GeneratedColumn<String>(
    'explicacion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dificultadMeta = const VerificationMeta(
    'dificultad',
  );
  @override
  late final GeneratedColumn<String> dificultad = GeneratedColumn<String>(
    'dificultad',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    temaId,
    enunciado,
    explicacion,
    dificultad,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preguntas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pregunta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tema_id')) {
      context.handle(
        _temaIdMeta,
        temaId.isAcceptableOrUnknown(data['tema_id']!, _temaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_temaIdMeta);
    }
    if (data.containsKey('enunciado')) {
      context.handle(
        _enunciadoMeta,
        enunciado.isAcceptableOrUnknown(data['enunciado']!, _enunciadoMeta),
      );
    } else if (isInserting) {
      context.missing(_enunciadoMeta);
    }
    if (data.containsKey('explicacion')) {
      context.handle(
        _explicacionMeta,
        explicacion.isAcceptableOrUnknown(
          data['explicacion']!,
          _explicacionMeta,
        ),
      );
    }
    if (data.containsKey('dificultad')) {
      context.handle(
        _dificultadMeta,
        dificultad.isAcceptableOrUnknown(data['dificultad']!, _dificultadMeta),
      );
    } else if (isInserting) {
      context.missing(_dificultadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pregunta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pregunta(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      temaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tema_id'],
      )!,
      enunciado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enunciado'],
      )!,
      explicacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explicacion'],
      ),
      dificultad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dificultad'],
      )!,
    );
  }

  @override
  $PreguntasTable createAlias(String alias) {
    return $PreguntasTable(attachedDatabase, alias);
  }
}

class Pregunta extends DataClass implements Insertable<Pregunta> {
  final int id;
  final int temaId;
  final String enunciado;
  final String? explicacion;
  final String dificultad;
  const Pregunta({
    required this.id,
    required this.temaId,
    required this.enunciado,
    this.explicacion,
    required this.dificultad,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tema_id'] = Variable<int>(temaId);
    map['enunciado'] = Variable<String>(enunciado);
    if (!nullToAbsent || explicacion != null) {
      map['explicacion'] = Variable<String>(explicacion);
    }
    map['dificultad'] = Variable<String>(dificultad);
    return map;
  }

  PreguntasCompanion toCompanion(bool nullToAbsent) {
    return PreguntasCompanion(
      id: Value(id),
      temaId: Value(temaId),
      enunciado: Value(enunciado),
      explicacion: explicacion == null && nullToAbsent
          ? const Value.absent()
          : Value(explicacion),
      dificultad: Value(dificultad),
    );
  }

  factory Pregunta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pregunta(
      id: serializer.fromJson<int>(json['id']),
      temaId: serializer.fromJson<int>(json['temaId']),
      enunciado: serializer.fromJson<String>(json['enunciado']),
      explicacion: serializer.fromJson<String?>(json['explicacion']),
      dificultad: serializer.fromJson<String>(json['dificultad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'temaId': serializer.toJson<int>(temaId),
      'enunciado': serializer.toJson<String>(enunciado),
      'explicacion': serializer.toJson<String?>(explicacion),
      'dificultad': serializer.toJson<String>(dificultad),
    };
  }

  Pregunta copyWith({
    int? id,
    int? temaId,
    String? enunciado,
    Value<String?> explicacion = const Value.absent(),
    String? dificultad,
  }) => Pregunta(
    id: id ?? this.id,
    temaId: temaId ?? this.temaId,
    enunciado: enunciado ?? this.enunciado,
    explicacion: explicacion.present ? explicacion.value : this.explicacion,
    dificultad: dificultad ?? this.dificultad,
  );
  Pregunta copyWithCompanion(PreguntasCompanion data) {
    return Pregunta(
      id: data.id.present ? data.id.value : this.id,
      temaId: data.temaId.present ? data.temaId.value : this.temaId,
      enunciado: data.enunciado.present ? data.enunciado.value : this.enunciado,
      explicacion: data.explicacion.present
          ? data.explicacion.value
          : this.explicacion,
      dificultad: data.dificultad.present
          ? data.dificultad.value
          : this.dificultad,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pregunta(')
          ..write('id: $id, ')
          ..write('temaId: $temaId, ')
          ..write('enunciado: $enunciado, ')
          ..write('explicacion: $explicacion, ')
          ..write('dificultad: $dificultad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, temaId, enunciado, explicacion, dificultad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pregunta &&
          other.id == this.id &&
          other.temaId == this.temaId &&
          other.enunciado == this.enunciado &&
          other.explicacion == this.explicacion &&
          other.dificultad == this.dificultad);
}

class PreguntasCompanion extends UpdateCompanion<Pregunta> {
  final Value<int> id;
  final Value<int> temaId;
  final Value<String> enunciado;
  final Value<String?> explicacion;
  final Value<String> dificultad;
  const PreguntasCompanion({
    this.id = const Value.absent(),
    this.temaId = const Value.absent(),
    this.enunciado = const Value.absent(),
    this.explicacion = const Value.absent(),
    this.dificultad = const Value.absent(),
  });
  PreguntasCompanion.insert({
    this.id = const Value.absent(),
    required int temaId,
    required String enunciado,
    this.explicacion = const Value.absent(),
    required String dificultad,
  }) : temaId = Value(temaId),
       enunciado = Value(enunciado),
       dificultad = Value(dificultad);
  static Insertable<Pregunta> custom({
    Expression<int>? id,
    Expression<int>? temaId,
    Expression<String>? enunciado,
    Expression<String>? explicacion,
    Expression<String>? dificultad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (temaId != null) 'tema_id': temaId,
      if (enunciado != null) 'enunciado': enunciado,
      if (explicacion != null) 'explicacion': explicacion,
      if (dificultad != null) 'dificultad': dificultad,
    });
  }

  PreguntasCompanion copyWith({
    Value<int>? id,
    Value<int>? temaId,
    Value<String>? enunciado,
    Value<String?>? explicacion,
    Value<String>? dificultad,
  }) {
    return PreguntasCompanion(
      id: id ?? this.id,
      temaId: temaId ?? this.temaId,
      enunciado: enunciado ?? this.enunciado,
      explicacion: explicacion ?? this.explicacion,
      dificultad: dificultad ?? this.dificultad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (temaId.present) {
      map['tema_id'] = Variable<int>(temaId.value);
    }
    if (enunciado.present) {
      map['enunciado'] = Variable<String>(enunciado.value);
    }
    if (explicacion.present) {
      map['explicacion'] = Variable<String>(explicacion.value);
    }
    if (dificultad.present) {
      map['dificultad'] = Variable<String>(dificultad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreguntasCompanion(')
          ..write('id: $id, ')
          ..write('temaId: $temaId, ')
          ..write('enunciado: $enunciado, ')
          ..write('explicacion: $explicacion, ')
          ..write('dificultad: $dificultad')
          ..write(')'))
        .toString();
  }
}

class $OpcionesTable extends Opciones with TableInfo<$OpcionesTable, Opcione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OpcionesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _preguntaIdMeta = const VerificationMeta(
    'preguntaId',
  );
  @override
  late final GeneratedColumn<int> preguntaId = GeneratedColumn<int>(
    'pregunta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES preguntas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _textoMeta = const VerificationMeta('texto');
  @override
  late final GeneratedColumn<String> texto = GeneratedColumn<String>(
    'texto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _esCorrectaMeta = const VerificationMeta(
    'esCorrecta',
  );
  @override
  late final GeneratedColumn<bool> esCorrecta = GeneratedColumn<bool>(
    'es_correcta',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_correcta" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ordenMeta = const VerificationMeta('orden');
  @override
  late final GeneratedColumn<int> orden = GeneratedColumn<int>(
    'orden',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    preguntaId,
    texto,
    esCorrecta,
    orden,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'opciones';
  @override
  VerificationContext validateIntegrity(
    Insertable<Opcione> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pregunta_id')) {
      context.handle(
        _preguntaIdMeta,
        preguntaId.isAcceptableOrUnknown(data['pregunta_id']!, _preguntaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_preguntaIdMeta);
    }
    if (data.containsKey('texto')) {
      context.handle(
        _textoMeta,
        texto.isAcceptableOrUnknown(data['texto']!, _textoMeta),
      );
    } else if (isInserting) {
      context.missing(_textoMeta);
    }
    if (data.containsKey('es_correcta')) {
      context.handle(
        _esCorrectaMeta,
        esCorrecta.isAcceptableOrUnknown(data['es_correcta']!, _esCorrectaMeta),
      );
    }
    if (data.containsKey('orden')) {
      context.handle(
        _ordenMeta,
        orden.isAcceptableOrUnknown(data['orden']!, _ordenMeta),
      );
    } else if (isInserting) {
      context.missing(_ordenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Opcione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Opcione(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      preguntaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pregunta_id'],
      )!,
      texto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}texto'],
      )!,
      esCorrecta: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_correcta'],
      )!,
      orden: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}orden'],
      )!,
    );
  }

  @override
  $OpcionesTable createAlias(String alias) {
    return $OpcionesTable(attachedDatabase, alias);
  }
}

class Opcione extends DataClass implements Insertable<Opcione> {
  final int id;
  final int preguntaId;
  final String texto;
  final bool esCorrecta;
  final int orden;
  const Opcione({
    required this.id,
    required this.preguntaId,
    required this.texto,
    required this.esCorrecta,
    required this.orden,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pregunta_id'] = Variable<int>(preguntaId);
    map['texto'] = Variable<String>(texto);
    map['es_correcta'] = Variable<bool>(esCorrecta);
    map['orden'] = Variable<int>(orden);
    return map;
  }

  OpcionesCompanion toCompanion(bool nullToAbsent) {
    return OpcionesCompanion(
      id: Value(id),
      preguntaId: Value(preguntaId),
      texto: Value(texto),
      esCorrecta: Value(esCorrecta),
      orden: Value(orden),
    );
  }

  factory Opcione.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Opcione(
      id: serializer.fromJson<int>(json['id']),
      preguntaId: serializer.fromJson<int>(json['preguntaId']),
      texto: serializer.fromJson<String>(json['texto']),
      esCorrecta: serializer.fromJson<bool>(json['esCorrecta']),
      orden: serializer.fromJson<int>(json['orden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'preguntaId': serializer.toJson<int>(preguntaId),
      'texto': serializer.toJson<String>(texto),
      'esCorrecta': serializer.toJson<bool>(esCorrecta),
      'orden': serializer.toJson<int>(orden),
    };
  }

  Opcione copyWith({
    int? id,
    int? preguntaId,
    String? texto,
    bool? esCorrecta,
    int? orden,
  }) => Opcione(
    id: id ?? this.id,
    preguntaId: preguntaId ?? this.preguntaId,
    texto: texto ?? this.texto,
    esCorrecta: esCorrecta ?? this.esCorrecta,
    orden: orden ?? this.orden,
  );
  Opcione copyWithCompanion(OpcionesCompanion data) {
    return Opcione(
      id: data.id.present ? data.id.value : this.id,
      preguntaId: data.preguntaId.present
          ? data.preguntaId.value
          : this.preguntaId,
      texto: data.texto.present ? data.texto.value : this.texto,
      esCorrecta: data.esCorrecta.present
          ? data.esCorrecta.value
          : this.esCorrecta,
      orden: data.orden.present ? data.orden.value : this.orden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Opcione(')
          ..write('id: $id, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('texto: $texto, ')
          ..write('esCorrecta: $esCorrecta, ')
          ..write('orden: $orden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, preguntaId, texto, esCorrecta, orden);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Opcione &&
          other.id == this.id &&
          other.preguntaId == this.preguntaId &&
          other.texto == this.texto &&
          other.esCorrecta == this.esCorrecta &&
          other.orden == this.orden);
}

class OpcionesCompanion extends UpdateCompanion<Opcione> {
  final Value<int> id;
  final Value<int> preguntaId;
  final Value<String> texto;
  final Value<bool> esCorrecta;
  final Value<int> orden;
  const OpcionesCompanion({
    this.id = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.texto = const Value.absent(),
    this.esCorrecta = const Value.absent(),
    this.orden = const Value.absent(),
  });
  OpcionesCompanion.insert({
    this.id = const Value.absent(),
    required int preguntaId,
    required String texto,
    this.esCorrecta = const Value.absent(),
    required int orden,
  }) : preguntaId = Value(preguntaId),
       texto = Value(texto),
       orden = Value(orden);
  static Insertable<Opcione> custom({
    Expression<int>? id,
    Expression<int>? preguntaId,
    Expression<String>? texto,
    Expression<bool>? esCorrecta,
    Expression<int>? orden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preguntaId != null) 'pregunta_id': preguntaId,
      if (texto != null) 'texto': texto,
      if (esCorrecta != null) 'es_correcta': esCorrecta,
      if (orden != null) 'orden': orden,
    });
  }

  OpcionesCompanion copyWith({
    Value<int>? id,
    Value<int>? preguntaId,
    Value<String>? texto,
    Value<bool>? esCorrecta,
    Value<int>? orden,
  }) {
    return OpcionesCompanion(
      id: id ?? this.id,
      preguntaId: preguntaId ?? this.preguntaId,
      texto: texto ?? this.texto,
      esCorrecta: esCorrecta ?? this.esCorrecta,
      orden: orden ?? this.orden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (preguntaId.present) {
      map['pregunta_id'] = Variable<int>(preguntaId.value);
    }
    if (texto.present) {
      map['texto'] = Variable<String>(texto.value);
    }
    if (esCorrecta.present) {
      map['es_correcta'] = Variable<bool>(esCorrecta.value);
    }
    if (orden.present) {
      map['orden'] = Variable<int>(orden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpcionesCompanion(')
          ..write('id: $id, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('texto: $texto, ')
          ..write('esCorrecta: $esCorrecta, ')
          ..write('orden: $orden')
          ..write(')'))
        .toString();
  }
}

class $IntentosTable extends Intentos with TableInfo<$IntentosTable, Intento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntentosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctasMeta = const VerificationMeta(
    'correctas',
  );
  @override
  late final GeneratedColumn<int> correctas = GeneratedColumn<int>(
    'correctas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _incorrectasMeta = const VerificationMeta(
    'incorrectas',
  );
  @override
  late final GeneratedColumn<int> incorrectas = GeneratedColumn<int>(
    'incorrectas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tiempoUsadoMeta = const VerificationMeta(
    'tiempoUsado',
  );
  @override
  late final GeneratedColumn<int> tiempoUsado = GeneratedColumn<int>(
    'tiempo_usado',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fecha,
    tipo,
    configJson,
    correctas,
    incorrectas,
    tiempoUsado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Intento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_configJsonMeta);
    }
    if (data.containsKey('correctas')) {
      context.handle(
        _correctasMeta,
        correctas.isAcceptableOrUnknown(data['correctas']!, _correctasMeta),
      );
    } else if (isInserting) {
      context.missing(_correctasMeta);
    }
    if (data.containsKey('incorrectas')) {
      context.handle(
        _incorrectasMeta,
        incorrectas.isAcceptableOrUnknown(
          data['incorrectas']!,
          _incorrectasMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incorrectasMeta);
    }
    if (data.containsKey('tiempo_usado')) {
      context.handle(
        _tiempoUsadoMeta,
        tiempoUsado.isAcceptableOrUnknown(
          data['tiempo_usado']!,
          _tiempoUsadoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tiempoUsadoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Intento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Intento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      configJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_json'],
      )!,
      correctas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correctas'],
      )!,
      incorrectas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}incorrectas'],
      )!,
      tiempoUsado: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tiempo_usado'],
      )!,
    );
  }

  @override
  $IntentosTable createAlias(String alias) {
    return $IntentosTable(attachedDatabase, alias);
  }
}

class Intento extends DataClass implements Insertable<Intento> {
  final int id;
  final DateTime fecha;
  final String tipo;
  final String configJson;
  final int correctas;
  final int incorrectas;
  final int tiempoUsado;
  const Intento({
    required this.id,
    required this.fecha,
    required this.tipo,
    required this.configJson,
    required this.correctas,
    required this.incorrectas,
    required this.tiempoUsado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha'] = Variable<DateTime>(fecha);
    map['tipo'] = Variable<String>(tipo);
    map['config_json'] = Variable<String>(configJson);
    map['correctas'] = Variable<int>(correctas);
    map['incorrectas'] = Variable<int>(incorrectas);
    map['tiempo_usado'] = Variable<int>(tiempoUsado);
    return map;
  }

  IntentosCompanion toCompanion(bool nullToAbsent) {
    return IntentosCompanion(
      id: Value(id),
      fecha: Value(fecha),
      tipo: Value(tipo),
      configJson: Value(configJson),
      correctas: Value(correctas),
      incorrectas: Value(incorrectas),
      tiempoUsado: Value(tiempoUsado),
    );
  }

  factory Intento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Intento(
      id: serializer.fromJson<int>(json['id']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      tipo: serializer.fromJson<String>(json['tipo']),
      configJson: serializer.fromJson<String>(json['configJson']),
      correctas: serializer.fromJson<int>(json['correctas']),
      incorrectas: serializer.fromJson<int>(json['incorrectas']),
      tiempoUsado: serializer.fromJson<int>(json['tiempoUsado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fecha': serializer.toJson<DateTime>(fecha),
      'tipo': serializer.toJson<String>(tipo),
      'configJson': serializer.toJson<String>(configJson),
      'correctas': serializer.toJson<int>(correctas),
      'incorrectas': serializer.toJson<int>(incorrectas),
      'tiempoUsado': serializer.toJson<int>(tiempoUsado),
    };
  }

  Intento copyWith({
    int? id,
    DateTime? fecha,
    String? tipo,
    String? configJson,
    int? correctas,
    int? incorrectas,
    int? tiempoUsado,
  }) => Intento(
    id: id ?? this.id,
    fecha: fecha ?? this.fecha,
    tipo: tipo ?? this.tipo,
    configJson: configJson ?? this.configJson,
    correctas: correctas ?? this.correctas,
    incorrectas: incorrectas ?? this.incorrectas,
    tiempoUsado: tiempoUsado ?? this.tiempoUsado,
  );
  Intento copyWithCompanion(IntentosCompanion data) {
    return Intento(
      id: data.id.present ? data.id.value : this.id,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      configJson: data.configJson.present
          ? data.configJson.value
          : this.configJson,
      correctas: data.correctas.present ? data.correctas.value : this.correctas,
      incorrectas: data.incorrectas.present
          ? data.incorrectas.value
          : this.incorrectas,
      tiempoUsado: data.tiempoUsado.present
          ? data.tiempoUsado.value
          : this.tiempoUsado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Intento(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('configJson: $configJson, ')
          ..write('correctas: $correctas, ')
          ..write('incorrectas: $incorrectas, ')
          ..write('tiempoUsado: $tiempoUsado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fecha,
    tipo,
    configJson,
    correctas,
    incorrectas,
    tiempoUsado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Intento &&
          other.id == this.id &&
          other.fecha == this.fecha &&
          other.tipo == this.tipo &&
          other.configJson == this.configJson &&
          other.correctas == this.correctas &&
          other.incorrectas == this.incorrectas &&
          other.tiempoUsado == this.tiempoUsado);
}

class IntentosCompanion extends UpdateCompanion<Intento> {
  final Value<int> id;
  final Value<DateTime> fecha;
  final Value<String> tipo;
  final Value<String> configJson;
  final Value<int> correctas;
  final Value<int> incorrectas;
  final Value<int> tiempoUsado;
  const IntentosCompanion({
    this.id = const Value.absent(),
    this.fecha = const Value.absent(),
    this.tipo = const Value.absent(),
    this.configJson = const Value.absent(),
    this.correctas = const Value.absent(),
    this.incorrectas = const Value.absent(),
    this.tiempoUsado = const Value.absent(),
  });
  IntentosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime fecha,
    required String tipo,
    required String configJson,
    required int correctas,
    required int incorrectas,
    required int tiempoUsado,
  }) : fecha = Value(fecha),
       tipo = Value(tipo),
       configJson = Value(configJson),
       correctas = Value(correctas),
       incorrectas = Value(incorrectas),
       tiempoUsado = Value(tiempoUsado);
  static Insertable<Intento> custom({
    Expression<int>? id,
    Expression<DateTime>? fecha,
    Expression<String>? tipo,
    Expression<String>? configJson,
    Expression<int>? correctas,
    Expression<int>? incorrectas,
    Expression<int>? tiempoUsado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fecha != null) 'fecha': fecha,
      if (tipo != null) 'tipo': tipo,
      if (configJson != null) 'config_json': configJson,
      if (correctas != null) 'correctas': correctas,
      if (incorrectas != null) 'incorrectas': incorrectas,
      if (tiempoUsado != null) 'tiempo_usado': tiempoUsado,
    });
  }

  IntentosCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? fecha,
    Value<String>? tipo,
    Value<String>? configJson,
    Value<int>? correctas,
    Value<int>? incorrectas,
    Value<int>? tiempoUsado,
  }) {
    return IntentosCompanion(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      configJson: configJson ?? this.configJson,
      correctas: correctas ?? this.correctas,
      incorrectas: incorrectas ?? this.incorrectas,
      tiempoUsado: tiempoUsado ?? this.tiempoUsado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (correctas.present) {
      map['correctas'] = Variable<int>(correctas.value);
    }
    if (incorrectas.present) {
      map['incorrectas'] = Variable<int>(incorrectas.value);
    }
    if (tiempoUsado.present) {
      map['tiempo_usado'] = Variable<int>(tiempoUsado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntentosCompanion(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('tipo: $tipo, ')
          ..write('configJson: $configJson, ')
          ..write('correctas: $correctas, ')
          ..write('incorrectas: $incorrectas, ')
          ..write('tiempoUsado: $tiempoUsado')
          ..write(')'))
        .toString();
  }
}

class $RespuestasIntentoTable extends RespuestasIntento
    with TableInfo<$RespuestasIntentoTable, RespuestasIntentoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RespuestasIntentoTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _intentoIdMeta = const VerificationMeta(
    'intentoId',
  );
  @override
  late final GeneratedColumn<int> intentoId = GeneratedColumn<int>(
    'intento_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES intentos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _preguntaIdMeta = const VerificationMeta(
    'preguntaId',
  );
  @override
  late final GeneratedColumn<int> preguntaId = GeneratedColumn<int>(
    'pregunta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES preguntas (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _opcionElegidaIdMeta = const VerificationMeta(
    'opcionElegidaId',
  );
  @override
  late final GeneratedColumn<int> opcionElegidaId = GeneratedColumn<int>(
    'opcion_elegida_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES opciones (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _esCorrectaMeta = const VerificationMeta(
    'esCorrecta',
  );
  @override
  late final GeneratedColumn<bool> esCorrecta = GeneratedColumn<bool>(
    'es_correcta',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_correcta" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    intentoId,
    preguntaId,
    opcionElegidaId,
    esCorrecta,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'respuestas_intento';
  @override
  VerificationContext validateIntegrity(
    Insertable<RespuestasIntentoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('intento_id')) {
      context.handle(
        _intentoIdMeta,
        intentoId.isAcceptableOrUnknown(data['intento_id']!, _intentoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_intentoIdMeta);
    }
    if (data.containsKey('pregunta_id')) {
      context.handle(
        _preguntaIdMeta,
        preguntaId.isAcceptableOrUnknown(data['pregunta_id']!, _preguntaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_preguntaIdMeta);
    }
    if (data.containsKey('opcion_elegida_id')) {
      context.handle(
        _opcionElegidaIdMeta,
        opcionElegidaId.isAcceptableOrUnknown(
          data['opcion_elegida_id']!,
          _opcionElegidaIdMeta,
        ),
      );
    }
    if (data.containsKey('es_correcta')) {
      context.handle(
        _esCorrectaMeta,
        esCorrecta.isAcceptableOrUnknown(data['es_correcta']!, _esCorrectaMeta),
      );
    } else if (isInserting) {
      context.missing(_esCorrectaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RespuestasIntentoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RespuestasIntentoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      intentoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intento_id'],
      )!,
      preguntaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pregunta_id'],
      )!,
      opcionElegidaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opcion_elegida_id'],
      ),
      esCorrecta: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_correcta'],
      )!,
    );
  }

  @override
  $RespuestasIntentoTable createAlias(String alias) {
    return $RespuestasIntentoTable(attachedDatabase, alias);
  }
}

class RespuestasIntentoData extends DataClass
    implements Insertable<RespuestasIntentoData> {
  final int id;
  final int intentoId;
  final int preguntaId;
  final int? opcionElegidaId;
  final bool esCorrecta;
  const RespuestasIntentoData({
    required this.id,
    required this.intentoId,
    required this.preguntaId,
    this.opcionElegidaId,
    required this.esCorrecta,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['intento_id'] = Variable<int>(intentoId);
    map['pregunta_id'] = Variable<int>(preguntaId);
    if (!nullToAbsent || opcionElegidaId != null) {
      map['opcion_elegida_id'] = Variable<int>(opcionElegidaId);
    }
    map['es_correcta'] = Variable<bool>(esCorrecta);
    return map;
  }

  RespuestasIntentoCompanion toCompanion(bool nullToAbsent) {
    return RespuestasIntentoCompanion(
      id: Value(id),
      intentoId: Value(intentoId),
      preguntaId: Value(preguntaId),
      opcionElegidaId: opcionElegidaId == null && nullToAbsent
          ? const Value.absent()
          : Value(opcionElegidaId),
      esCorrecta: Value(esCorrecta),
    );
  }

  factory RespuestasIntentoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RespuestasIntentoData(
      id: serializer.fromJson<int>(json['id']),
      intentoId: serializer.fromJson<int>(json['intentoId']),
      preguntaId: serializer.fromJson<int>(json['preguntaId']),
      opcionElegidaId: serializer.fromJson<int?>(json['opcionElegidaId']),
      esCorrecta: serializer.fromJson<bool>(json['esCorrecta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'intentoId': serializer.toJson<int>(intentoId),
      'preguntaId': serializer.toJson<int>(preguntaId),
      'opcionElegidaId': serializer.toJson<int?>(opcionElegidaId),
      'esCorrecta': serializer.toJson<bool>(esCorrecta),
    };
  }

  RespuestasIntentoData copyWith({
    int? id,
    int? intentoId,
    int? preguntaId,
    Value<int?> opcionElegidaId = const Value.absent(),
    bool? esCorrecta,
  }) => RespuestasIntentoData(
    id: id ?? this.id,
    intentoId: intentoId ?? this.intentoId,
    preguntaId: preguntaId ?? this.preguntaId,
    opcionElegidaId: opcionElegidaId.present
        ? opcionElegidaId.value
        : this.opcionElegidaId,
    esCorrecta: esCorrecta ?? this.esCorrecta,
  );
  RespuestasIntentoData copyWithCompanion(RespuestasIntentoCompanion data) {
    return RespuestasIntentoData(
      id: data.id.present ? data.id.value : this.id,
      intentoId: data.intentoId.present ? data.intentoId.value : this.intentoId,
      preguntaId: data.preguntaId.present
          ? data.preguntaId.value
          : this.preguntaId,
      opcionElegidaId: data.opcionElegidaId.present
          ? data.opcionElegidaId.value
          : this.opcionElegidaId,
      esCorrecta: data.esCorrecta.present
          ? data.esCorrecta.value
          : this.esCorrecta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RespuestasIntentoData(')
          ..write('id: $id, ')
          ..write('intentoId: $intentoId, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('opcionElegidaId: $opcionElegidaId, ')
          ..write('esCorrecta: $esCorrecta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, intentoId, preguntaId, opcionElegidaId, esCorrecta);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RespuestasIntentoData &&
          other.id == this.id &&
          other.intentoId == this.intentoId &&
          other.preguntaId == this.preguntaId &&
          other.opcionElegidaId == this.opcionElegidaId &&
          other.esCorrecta == this.esCorrecta);
}

class RespuestasIntentoCompanion
    extends UpdateCompanion<RespuestasIntentoData> {
  final Value<int> id;
  final Value<int> intentoId;
  final Value<int> preguntaId;
  final Value<int?> opcionElegidaId;
  final Value<bool> esCorrecta;
  const RespuestasIntentoCompanion({
    this.id = const Value.absent(),
    this.intentoId = const Value.absent(),
    this.preguntaId = const Value.absent(),
    this.opcionElegidaId = const Value.absent(),
    this.esCorrecta = const Value.absent(),
  });
  RespuestasIntentoCompanion.insert({
    this.id = const Value.absent(),
    required int intentoId,
    required int preguntaId,
    this.opcionElegidaId = const Value.absent(),
    required bool esCorrecta,
  }) : intentoId = Value(intentoId),
       preguntaId = Value(preguntaId),
       esCorrecta = Value(esCorrecta);
  static Insertable<RespuestasIntentoData> custom({
    Expression<int>? id,
    Expression<int>? intentoId,
    Expression<int>? preguntaId,
    Expression<int>? opcionElegidaId,
    Expression<bool>? esCorrecta,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (intentoId != null) 'intento_id': intentoId,
      if (preguntaId != null) 'pregunta_id': preguntaId,
      if (opcionElegidaId != null) 'opcion_elegida_id': opcionElegidaId,
      if (esCorrecta != null) 'es_correcta': esCorrecta,
    });
  }

  RespuestasIntentoCompanion copyWith({
    Value<int>? id,
    Value<int>? intentoId,
    Value<int>? preguntaId,
    Value<int?>? opcionElegidaId,
    Value<bool>? esCorrecta,
  }) {
    return RespuestasIntentoCompanion(
      id: id ?? this.id,
      intentoId: intentoId ?? this.intentoId,
      preguntaId: preguntaId ?? this.preguntaId,
      opcionElegidaId: opcionElegidaId ?? this.opcionElegidaId,
      esCorrecta: esCorrecta ?? this.esCorrecta,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (intentoId.present) {
      map['intento_id'] = Variable<int>(intentoId.value);
    }
    if (preguntaId.present) {
      map['pregunta_id'] = Variable<int>(preguntaId.value);
    }
    if (opcionElegidaId.present) {
      map['opcion_elegida_id'] = Variable<int>(opcionElegidaId.value);
    }
    if (esCorrecta.present) {
      map['es_correcta'] = Variable<bool>(esCorrecta.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RespuestasIntentoCompanion(')
          ..write('id: $id, ')
          ..write('intentoId: $intentoId, ')
          ..write('preguntaId: $preguntaId, ')
          ..write('opcionElegidaId: $opcionElegidaId, ')
          ..write('esCorrecta: $esCorrecta')
          ..write(')'))
        .toString();
  }
}

class $QuizzesGuardadosTable extends QuizzesGuardados
    with TableInfo<$QuizzesGuardadosTable, QuizzesGuardado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizzesGuardadosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, configJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quizzes_guardados';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizzesGuardado> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_configJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizzesGuardado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizzesGuardado(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      configJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_json'],
      )!,
    );
  }

  @override
  $QuizzesGuardadosTable createAlias(String alias) {
    return $QuizzesGuardadosTable(attachedDatabase, alias);
  }
}

class QuizzesGuardado extends DataClass implements Insertable<QuizzesGuardado> {
  final int id;
  final String nombre;
  final String configJson;
  const QuizzesGuardado({
    required this.id,
    required this.nombre,
    required this.configJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['config_json'] = Variable<String>(configJson);
    return map;
  }

  QuizzesGuardadosCompanion toCompanion(bool nullToAbsent) {
    return QuizzesGuardadosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      configJson: Value(configJson),
    );
  }

  factory QuizzesGuardado.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizzesGuardado(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      configJson: serializer.fromJson<String>(json['configJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'configJson': serializer.toJson<String>(configJson),
    };
  }

  QuizzesGuardado copyWith({int? id, String? nombre, String? configJson}) =>
      QuizzesGuardado(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        configJson: configJson ?? this.configJson,
      );
  QuizzesGuardado copyWithCompanion(QuizzesGuardadosCompanion data) {
    return QuizzesGuardado(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      configJson: data.configJson.present
          ? data.configJson.value
          : this.configJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizzesGuardado(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('configJson: $configJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, configJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizzesGuardado &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.configJson == this.configJson);
}

class QuizzesGuardadosCompanion extends UpdateCompanion<QuizzesGuardado> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> configJson;
  const QuizzesGuardadosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.configJson = const Value.absent(),
  });
  QuizzesGuardadosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String configJson,
  }) : nombre = Value(nombre),
       configJson = Value(configJson);
  static Insertable<QuizzesGuardado> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? configJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (configJson != null) 'config_json': configJson,
    });
  }

  QuizzesGuardadosCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? configJson,
  }) {
    return QuizzesGuardadosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      configJson: configJson ?? this.configJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizzesGuardadosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('configJson: $configJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FacultadesTable facultades = $FacultadesTable(this);
  late final $MateriasTable materias = $MateriasTable(this);
  late final $TemasTable temas = $TemasTable(this);
  late final $PreguntasTable preguntas = $PreguntasTable(this);
  late final $OpcionesTable opciones = $OpcionesTable(this);
  late final $IntentosTable intentos = $IntentosTable(this);
  late final $RespuestasIntentoTable respuestasIntento =
      $RespuestasIntentoTable(this);
  late final $QuizzesGuardadosTable quizzesGuardados = $QuizzesGuardadosTable(
    this,
  );
  late final Index idxPreguntasTema = Index(
    'idx_preguntas_tema',
    'CREATE INDEX idx_preguntas_tema ON preguntas (tema_id)',
  );
  late final Index idxPreguntasDificultad = Index(
    'idx_preguntas_dificultad',
    'CREATE INDEX idx_preguntas_dificultad ON preguntas (dificultad)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    facultades,
    materias,
    temas,
    preguntas,
    opciones,
    intentos,
    respuestasIntento,
    quizzesGuardados,
    idxPreguntasTema,
    idxPreguntasDificultad,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'facultades',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('materias', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'materias',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('temas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'temas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('preguntas', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'preguntas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('opciones', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'intentos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('respuestas_intento', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'preguntas',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('respuestas_intento', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'opciones',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('respuestas_intento', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$FacultadesTableCreateCompanionBuilder = FacultadesCompanion Function({
  Value<int> id,
  required String nombre,
});
typedef $$FacultadesTableUpdateCompanionBuilder = FacultadesCompanion Function({
  Value<int> id,
  Value<String> nombre,
});

final class $$FacultadesTableReferences
    extends BaseReferences<_$AppDatabase, $FacultadesTable, Facultade> {
  $$FacultadesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MateriasTable, List<Materia>> _materiasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.materias,
    aliasName: 'facultades__id__materias__facultad_id',
  );

  $$MateriasTableProcessedTableManager get materiasRefs {
    final manager = $$MateriasTableTableManager(
      $_db,
      $_db.materias,
    ).filter((f) => f.facultadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_materiasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FacultadesTableFilterComposer
    extends Composer<_$AppDatabase, $FacultadesTable> {
  $$FacultadesTableFilterComposer({
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

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> materiasRefs(
    Expression<bool> Function($$MateriasTableFilterComposer f) f,
  ) {
    final $$MateriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.facultadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableFilterComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FacultadesTableOrderingComposer
    extends Composer<_$AppDatabase, $FacultadesTable> {
  $$FacultadesTableOrderingComposer({
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

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FacultadesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FacultadesTable> {
  $$FacultadesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  Expression<T> materiasRefs<T extends Object>(
    Expression<T> Function($$MateriasTableAnnotationComposer a) f,
  ) {
    final $$MateriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.facultadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableAnnotationComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FacultadesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FacultadesTable,
          Facultade,
          $$FacultadesTableFilterComposer,
          $$FacultadesTableOrderingComposer,
          $$FacultadesTableAnnotationComposer,
          $$FacultadesTableCreateCompanionBuilder,
          $$FacultadesTableUpdateCompanionBuilder,
          (Facultade, $$FacultadesTableReferences),
          Facultade,
          PrefetchHooks Function({bool materiasRefs})
        > {
  $$FacultadesTableTableManager(_$AppDatabase db, $FacultadesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FacultadesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FacultadesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FacultadesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
          }) => FacultadesCompanion(id: id, nombre: nombre),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
          }) => FacultadesCompanion.insert(id: id, nombre: nombre),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FacultadesTable, Facultade>(table),
                  $$FacultadesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({materiasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (materiasRefs) db.materias],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (materiasRefs)
                    await $_getPrefetchedData<
                      Facultade,
                      $FacultadesTable,
                      Materia
                    >(
                      currentTable: table,
                      referencedTable: $$FacultadesTableReferences
                          ._materiasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FacultadesTableReferences(
                            db,
                            table,
                            p0,
                          ).materiasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.facultadId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FacultadesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FacultadesTable,
      Facultade,
      $$FacultadesTableFilterComposer,
      $$FacultadesTableOrderingComposer,
      $$FacultadesTableAnnotationComposer,
      $$FacultadesTableCreateCompanionBuilder,
      $$FacultadesTableUpdateCompanionBuilder,
      (Facultade, $$FacultadesTableReferences),
      Facultade,
      PrefetchHooks Function({bool materiasRefs})
    >;
typedef $$MateriasTableCreateCompanionBuilder = MateriasCompanion Function({
  Value<int> id,
  required int facultadId,
  required String nombre,
});
typedef $$MateriasTableUpdateCompanionBuilder = MateriasCompanion Function({
  Value<int> id,
  Value<int> facultadId,
  Value<String> nombre,
});

final class $$MateriasTableReferences
    extends BaseReferences<_$AppDatabase, $MateriasTable, Materia> {
  $$MateriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FacultadesTable _facultadIdTable(_$AppDatabase db) =>
      db.facultades.createAlias('materias__facultad_id__facultades__id');

  $$FacultadesTableProcessedTableManager get facultadId {
    final $_column = $_itemColumn<int>('facultad_id')!;

    final manager = $$FacultadesTableTableManager(
      $_db,
      $_db.facultades,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_facultadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TemasTable, List<Tema>> _temasRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.temas,
    aliasName: 'materias__id__temas__materia_id',
  );

  $$TemasTableProcessedTableManager get temasRefs {
    final manager = $$TemasTableTableManager(
      $_db,
      $_db.temas,
    ).filter((f) => f.materiaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_temasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MateriasTableFilterComposer
    extends Composer<_$AppDatabase, $MateriasTable> {
  $$MateriasTableFilterComposer({
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

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  $$FacultadesTableFilterComposer get facultadId {
    final $$FacultadesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.facultadId,
      referencedTable: $db.facultades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacultadesTableFilterComposer(
            $db: $db,
            $table: $db.facultades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> temasRefs(
    Expression<bool> Function($$TemasTableFilterComposer f) f,
  ) {
    final $$TemasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.temas,
      getReferencedColumn: (t) => t.materiaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemasTableFilterComposer(
            $db: $db,
            $table: $db.temas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MateriasTableOrderingComposer
    extends Composer<_$AppDatabase, $MateriasTable> {
  $$MateriasTableOrderingComposer({
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

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  $$FacultadesTableOrderingComposer get facultadId {
    final $$FacultadesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.facultadId,
      referencedTable: $db.facultades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacultadesTableOrderingComposer(
            $db: $db,
            $table: $db.facultades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MateriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $MateriasTable> {
  $$MateriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  $$FacultadesTableAnnotationComposer get facultadId {
    final $$FacultadesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.facultadId,
      referencedTable: $db.facultades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FacultadesTableAnnotationComposer(
            $db: $db,
            $table: $db.facultades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> temasRefs<T extends Object>(
    Expression<T> Function($$TemasTableAnnotationComposer a) f,
  ) {
    final $$TemasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.temas,
      getReferencedColumn: (t) => t.materiaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemasTableAnnotationComposer(
            $db: $db,
            $table: $db.temas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MateriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MateriasTable,
          Materia,
          $$MateriasTableFilterComposer,
          $$MateriasTableOrderingComposer,
          $$MateriasTableAnnotationComposer,
          $$MateriasTableCreateCompanionBuilder,
          $$MateriasTableUpdateCompanionBuilder,
          (Materia, $$MateriasTableReferences),
          Materia,
          PrefetchHooks Function({bool facultadId, bool temasRefs})
        > {
  $$MateriasTableTableManager(_$AppDatabase db, $MateriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MateriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MateriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MateriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> facultadId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
              }) => MateriasCompanion(
                id: id,
                facultadId: facultadId,
                nombre: nombre,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int facultadId,
                required String nombre,
              }) => MateriasCompanion.insert(
                id: id,
                facultadId: facultadId,
                nombre: nombre,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MateriasTable, Materia>(table),
                  $$MateriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({facultadId = false, temasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (temasRefs) db.temas],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (facultadId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.facultadId,
                        referencedTable: $$MateriasTableReferences
                            ._facultadIdTable(db),
                        referencedColumn: $$MateriasTableReferences
                            ._facultadIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (temasRefs)
                    await $_getPrefetchedData<Materia, $MateriasTable, Tema>(
                      currentTable: table,
                      referencedTable: $$MateriasTableReferences
                          ._temasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MateriasTableReferences(db, table, p0).temasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.materiaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MateriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MateriasTable,
      Materia,
      $$MateriasTableFilterComposer,
      $$MateriasTableOrderingComposer,
      $$MateriasTableAnnotationComposer,
      $$MateriasTableCreateCompanionBuilder,
      $$MateriasTableUpdateCompanionBuilder,
      (Materia, $$MateriasTableReferences),
      Materia,
      PrefetchHooks Function({bool facultadId, bool temasRefs})
    >;
typedef $$TemasTableCreateCompanionBuilder = TemasCompanion Function({
  Value<int> id,
  required int materiaId,
  required String nombre,
});
typedef $$TemasTableUpdateCompanionBuilder = TemasCompanion Function({
  Value<int> id,
  Value<int> materiaId,
  Value<String> nombre,
});

final class $$TemasTableReferences
    extends BaseReferences<_$AppDatabase, $TemasTable, Tema> {
  $$TemasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MateriasTable _materiaIdTable(_$AppDatabase db) =>
      db.materias.createAlias('temas__materia_id__materias__id');

  $$MateriasTableProcessedTableManager get materiaId {
    final $_column = $_itemColumn<int>('materia_id')!;

    final manager = $$MateriasTableTableManager(
      $_db,
      $_db.materias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_materiaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PreguntasTable, List<Pregunta>>
  _preguntasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.preguntas,
    aliasName: 'temas__id__preguntas__tema_id',
  );

  $$PreguntasTableProcessedTableManager get preguntasRefs {
    final manager = $$PreguntasTableTableManager(
      $_db,
      $_db.preguntas,
    ).filter((f) => f.temaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_preguntasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TemasTableFilterComposer extends Composer<_$AppDatabase, $TemasTable> {
  $$TemasTableFilterComposer({
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

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  $$MateriasTableFilterComposer get materiaId {
    final $$MateriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materiaId,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableFilterComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> preguntasRefs(
    Expression<bool> Function($$PreguntasTableFilterComposer f) f,
  ) {
    final $$PreguntasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preguntas,
      getReferencedColumn: (t) => t.temaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreguntasTableFilterComposer(
            $db: $db,
            $table: $db.preguntas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemasTableOrderingComposer
    extends Composer<_$AppDatabase, $TemasTable> {
  $$TemasTableOrderingComposer({
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

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  $$MateriasTableOrderingComposer get materiaId {
    final $$MateriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materiaId,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableOrderingComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemasTable> {
  $$TemasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  $$MateriasTableAnnotationComposer get materiaId {
    final $$MateriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materiaId,
      referencedTable: $db.materias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MateriasTableAnnotationComposer(
            $db: $db,
            $table: $db.materias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> preguntasRefs<T extends Object>(
    Expression<T> Function($$PreguntasTableAnnotationComposer a) f,
  ) {
    final $$PreguntasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.preguntas,
      getReferencedColumn: (t) => t.temaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreguntasTableAnnotationComposer(
            $db: $db,
            $table: $db.preguntas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemasTable,
          Tema,
          $$TemasTableFilterComposer,
          $$TemasTableOrderingComposer,
          $$TemasTableAnnotationComposer,
          $$TemasTableCreateCompanionBuilder,
          $$TemasTableUpdateCompanionBuilder,
          (Tema, $$TemasTableReferences),
          Tema,
          PrefetchHooks Function({bool materiaId, bool preguntasRefs})
        > {
  $$TemasTableTableManager(_$AppDatabase db, $TemasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> materiaId = const Value.absent(),
            Value<String> nombre = const Value.absent(),
          }) => TemasCompanion(id: id, materiaId: materiaId, nombre: nombre),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int materiaId,
                required String nombre,
              }) => TemasCompanion.insert(
                id: id,
                materiaId: materiaId,
                nombre: nombre,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TemasTable, Tema>(table),
                  $$TemasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({materiaId = false, preguntasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (preguntasRefs) db.preguntas],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (materiaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.materiaId,
                        referencedTable: $$TemasTableReferences._materiaIdTable(
                          db,
                        ),
                        referencedColumn: $$TemasTableReferences
                            ._materiaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (preguntasRefs)
                    await $_getPrefetchedData<Tema, $TemasTable, Pregunta>(
                      currentTable: table,
                      referencedTable: $$TemasTableReferences
                          ._preguntasRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TemasTableReferences(db, table, p0).preguntasRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.temaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TemasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemasTable,
      Tema,
      $$TemasTableFilterComposer,
      $$TemasTableOrderingComposer,
      $$TemasTableAnnotationComposer,
      $$TemasTableCreateCompanionBuilder,
      $$TemasTableUpdateCompanionBuilder,
      (Tema, $$TemasTableReferences),
      Tema,
      PrefetchHooks Function({bool materiaId, bool preguntasRefs})
    >;
typedef $$PreguntasTableCreateCompanionBuilder = PreguntasCompanion Function({
  Value<int> id,
  required int temaId,
  required String enunciado,
  Value<String?> explicacion,
  required String dificultad,
});
typedef $$PreguntasTableUpdateCompanionBuilder = PreguntasCompanion Function({
  Value<int> id,
  Value<int> temaId,
  Value<String> enunciado,
  Value<String?> explicacion,
  Value<String> dificultad,
});

final class $$PreguntasTableReferences
    extends BaseReferences<_$AppDatabase, $PreguntasTable, Pregunta> {
  $$PreguntasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TemasTable _temaIdTable(_$AppDatabase db) =>
      db.temas.createAlias('preguntas__tema_id__temas__id');

  $$TemasTableProcessedTableManager get temaId {
    final $_column = $_itemColumn<int>('tema_id')!;

    final manager = $$TemasTableTableManager(
      $_db,
      $_db.temas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_temaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OpcionesTable, List<Opcione>> _opcionesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.opciones,
    aliasName: 'preguntas__id__opciones__pregunta_id',
  );

  $$OpcionesTableProcessedTableManager get opcionesRefs {
    final manager = $$OpcionesTableTableManager(
      $_db,
      $_db.opciones,
    ).filter((f) => f.preguntaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_opcionesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RespuestasIntentoTable,
    List<RespuestasIntentoData>
  >
  _respuestasIntentoRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.respuestasIntento,
        aliasName: 'preguntas__id__respuestas_intento__pregunta_id',
      );

  $$RespuestasIntentoTableProcessedTableManager get respuestasIntentoRefs {
    final manager = $$RespuestasIntentoTableTableManager(
      $_db,
      $_db.respuestasIntento,
    ).filter((f) => f.preguntaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _respuestasIntentoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PreguntasTableFilterComposer
    extends Composer<_$AppDatabase, $PreguntasTable> {
  $$PreguntasTableFilterComposer({
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

  ColumnFilters<String> get enunciado => $composableBuilder(
    column: $table.enunciado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explicacion => $composableBuilder(
    column: $table.explicacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dificultad => $composableBuilder(
    column: $table.dificultad,
    builder: (column) => ColumnFilters(column),
  );

  $$TemasTableFilterComposer get temaId {
    final $$TemasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.temaId,
      referencedTable: $db.temas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemasTableFilterComposer(
            $db: $db,
            $table: $db.temas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> opcionesRefs(
    Expression<bool> Function($$OpcionesTableFilterComposer f) f,
  ) {
    final $$OpcionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.opciones,
      getReferencedColumn: (t) => t.preguntaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OpcionesTableFilterComposer(
            $db: $db,
            $table: $db.opciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> respuestasIntentoRefs(
    Expression<bool> Function($$RespuestasIntentoTableFilterComposer f) f,
  ) {
    final $$RespuestasIntentoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.respuestasIntento,
      getReferencedColumn: (t) => t.preguntaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RespuestasIntentoTableFilterComposer(
            $db: $db,
            $table: $db.respuestasIntento,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PreguntasTableOrderingComposer
    extends Composer<_$AppDatabase, $PreguntasTable> {
  $$PreguntasTableOrderingComposer({
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

  ColumnOrderings<String> get enunciado => $composableBuilder(
    column: $table.enunciado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explicacion => $composableBuilder(
    column: $table.explicacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dificultad => $composableBuilder(
    column: $table.dificultad,
    builder: (column) => ColumnOrderings(column),
  );

  $$TemasTableOrderingComposer get temaId {
    final $$TemasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.temaId,
      referencedTable: $db.temas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemasTableOrderingComposer(
            $db: $db,
            $table: $db.temas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PreguntasTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreguntasTable> {
  $$PreguntasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get enunciado =>
      $composableBuilder(column: $table.enunciado, builder: (column) => column);

  GeneratedColumn<String> get explicacion => $composableBuilder(
    column: $table.explicacion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dificultad => $composableBuilder(
    column: $table.dificultad,
    builder: (column) => column,
  );

  $$TemasTableAnnotationComposer get temaId {
    final $$TemasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.temaId,
      referencedTable: $db.temas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemasTableAnnotationComposer(
            $db: $db,
            $table: $db.temas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> opcionesRefs<T extends Object>(
    Expression<T> Function($$OpcionesTableAnnotationComposer a) f,
  ) {
    final $$OpcionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.opciones,
      getReferencedColumn: (t) => t.preguntaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OpcionesTableAnnotationComposer(
            $db: $db,
            $table: $db.opciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> respuestasIntentoRefs<T extends Object>(
    Expression<T> Function($$RespuestasIntentoTableAnnotationComposer a) f,
  ) {
    final $$RespuestasIntentoTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.respuestasIntento,
          getReferencedColumn: (t) => t.preguntaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RespuestasIntentoTableAnnotationComposer(
                $db: $db,
                $table: $db.respuestasIntento,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PreguntasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreguntasTable,
          Pregunta,
          $$PreguntasTableFilterComposer,
          $$PreguntasTableOrderingComposer,
          $$PreguntasTableAnnotationComposer,
          $$PreguntasTableCreateCompanionBuilder,
          $$PreguntasTableUpdateCompanionBuilder,
          (Pregunta, $$PreguntasTableReferences),
          Pregunta,
          PrefetchHooks Function({
            bool temaId,
            bool opcionesRefs,
            bool respuestasIntentoRefs,
          })
        > {
  $$PreguntasTableTableManager(_$AppDatabase db, $PreguntasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreguntasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreguntasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreguntasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> temaId = const Value.absent(),
                Value<String> enunciado = const Value.absent(),
                Value<String?> explicacion = const Value.absent(),
                Value<String> dificultad = const Value.absent(),
              }) => PreguntasCompanion(
                id: id,
                temaId: temaId,
                enunciado: enunciado,
                explicacion: explicacion,
                dificultad: dificultad,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int temaId,
                required String enunciado,
                Value<String?> explicacion = const Value.absent(),
                required String dificultad,
              }) => PreguntasCompanion.insert(
                id: id,
                temaId: temaId,
                enunciado: enunciado,
                explicacion: explicacion,
                dificultad: dificultad,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreguntasTable, Pregunta>(table),
                  $$PreguntasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                temaId = false,
                opcionesRefs = false,
                respuestasIntentoRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (opcionesRefs) db.opciones,
                    if (respuestasIntentoRefs) db.respuestasIntento,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (temaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.temaId,
                            referencedTable: $$PreguntasTableReferences
                                ._temaIdTable(db),
                            referencedColumn: $$PreguntasTableReferences
                                ._temaIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (opcionesRefs)
                        await $_getPrefetchedData<
                          Pregunta,
                          $PreguntasTable,
                          Opcione
                        >(
                          currentTable: table,
                          referencedTable: $$PreguntasTableReferences
                              ._opcionesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PreguntasTableReferences(
                                db,
                                table,
                                p0,
                              ).opcionesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.preguntaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (respuestasIntentoRefs)
                        await $_getPrefetchedData<
                          Pregunta,
                          $PreguntasTable,
                          RespuestasIntentoData
                        >(
                          currentTable: table,
                          referencedTable: $$PreguntasTableReferences
                              ._respuestasIntentoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PreguntasTableReferences(
                                db,
                                table,
                                p0,
                              ).respuestasIntentoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.preguntaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PreguntasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreguntasTable,
      Pregunta,
      $$PreguntasTableFilterComposer,
      $$PreguntasTableOrderingComposer,
      $$PreguntasTableAnnotationComposer,
      $$PreguntasTableCreateCompanionBuilder,
      $$PreguntasTableUpdateCompanionBuilder,
      (Pregunta, $$PreguntasTableReferences),
      Pregunta,
      PrefetchHooks Function({
        bool temaId,
        bool opcionesRefs,
        bool respuestasIntentoRefs,
      })
    >;
typedef $$OpcionesTableCreateCompanionBuilder = OpcionesCompanion Function({
  Value<int> id,
  required int preguntaId,
  required String texto,
  Value<bool> esCorrecta,
  required int orden,
});
typedef $$OpcionesTableUpdateCompanionBuilder = OpcionesCompanion Function({
  Value<int> id,
  Value<int> preguntaId,
  Value<String> texto,
  Value<bool> esCorrecta,
  Value<int> orden,
});

final class $$OpcionesTableReferences
    extends BaseReferences<_$AppDatabase, $OpcionesTable, Opcione> {
  $$OpcionesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PreguntasTable _preguntaIdTable(_$AppDatabase db) =>
      db.preguntas.createAlias('opciones__pregunta_id__preguntas__id');

  $$PreguntasTableProcessedTableManager get preguntaId {
    final $_column = $_itemColumn<int>('pregunta_id')!;

    final manager = $$PreguntasTableTableManager(
      $_db,
      $_db.preguntas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_preguntaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RespuestasIntentoTable,
    List<RespuestasIntentoData>
  >
  _respuestasIntentoRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.respuestasIntento,
        aliasName: 'opciones__id__respuestas_intento__opcion_elegida_id',
      );

  $$RespuestasIntentoTableProcessedTableManager get respuestasIntentoRefs {
    final manager = $$RespuestasIntentoTableTableManager(
      $_db,
      $_db.respuestasIntento,
    ).filter((f) => f.opcionElegidaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _respuestasIntentoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OpcionesTableFilterComposer
    extends Composer<_$AppDatabase, $OpcionesTable> {
  $$OpcionesTableFilterComposer({
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

  ColumnFilters<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esCorrecta => $composableBuilder(
    column: $table.esCorrecta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnFilters(column),
  );

  $$PreguntasTableFilterComposer get preguntaId {
    final $$PreguntasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preguntaId,
      referencedTable: $db.preguntas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreguntasTableFilterComposer(
            $db: $db,
            $table: $db.preguntas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> respuestasIntentoRefs(
    Expression<bool> Function($$RespuestasIntentoTableFilterComposer f) f,
  ) {
    final $$RespuestasIntentoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.respuestasIntento,
      getReferencedColumn: (t) => t.opcionElegidaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RespuestasIntentoTableFilterComposer(
            $db: $db,
            $table: $db.respuestasIntento,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OpcionesTableOrderingComposer
    extends Composer<_$AppDatabase, $OpcionesTable> {
  $$OpcionesTableOrderingComposer({
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

  ColumnOrderings<String> get texto => $composableBuilder(
    column: $table.texto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esCorrecta => $composableBuilder(
    column: $table.esCorrecta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orden => $composableBuilder(
    column: $table.orden,
    builder: (column) => ColumnOrderings(column),
  );

  $$PreguntasTableOrderingComposer get preguntaId {
    final $$PreguntasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preguntaId,
      referencedTable: $db.preguntas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreguntasTableOrderingComposer(
            $db: $db,
            $table: $db.preguntas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OpcionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OpcionesTable> {
  $$OpcionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get texto =>
      $composableBuilder(column: $table.texto, builder: (column) => column);

  GeneratedColumn<bool> get esCorrecta => $composableBuilder(
    column: $table.esCorrecta,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orden =>
      $composableBuilder(column: $table.orden, builder: (column) => column);

  $$PreguntasTableAnnotationComposer get preguntaId {
    final $$PreguntasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preguntaId,
      referencedTable: $db.preguntas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreguntasTableAnnotationComposer(
            $db: $db,
            $table: $db.preguntas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> respuestasIntentoRefs<T extends Object>(
    Expression<T> Function($$RespuestasIntentoTableAnnotationComposer a) f,
  ) {
    final $$RespuestasIntentoTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.respuestasIntento,
          getReferencedColumn: (t) => t.opcionElegidaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RespuestasIntentoTableAnnotationComposer(
                $db: $db,
                $table: $db.respuestasIntento,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OpcionesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OpcionesTable,
          Opcione,
          $$OpcionesTableFilterComposer,
          $$OpcionesTableOrderingComposer,
          $$OpcionesTableAnnotationComposer,
          $$OpcionesTableCreateCompanionBuilder,
          $$OpcionesTableUpdateCompanionBuilder,
          (Opcione, $$OpcionesTableReferences),
          Opcione,
          PrefetchHooks Function({bool preguntaId, bool respuestasIntentoRefs})
        > {
  $$OpcionesTableTableManager(_$AppDatabase db, $OpcionesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OpcionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OpcionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OpcionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> preguntaId = const Value.absent(),
                Value<String> texto = const Value.absent(),
                Value<bool> esCorrecta = const Value.absent(),
                Value<int> orden = const Value.absent(),
              }) => OpcionesCompanion(
                id: id,
                preguntaId: preguntaId,
                texto: texto,
                esCorrecta: esCorrecta,
                orden: orden,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int preguntaId,
                required String texto,
                Value<bool> esCorrecta = const Value.absent(),
                required int orden,
              }) => OpcionesCompanion.insert(
                id: id,
                preguntaId: preguntaId,
                texto: texto,
                esCorrecta: esCorrecta,
                orden: orden,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OpcionesTable, Opcione>(table),
                  $$OpcionesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({preguntaId = false, respuestasIntentoRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (respuestasIntentoRefs) db.respuestasIntento,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (preguntaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.preguntaId,
                            referencedTable: $$OpcionesTableReferences
                                ._preguntaIdTable(db),
                            referencedColumn: $$OpcionesTableReferences
                                ._preguntaIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (respuestasIntentoRefs)
                        await $_getPrefetchedData<
                          Opcione,
                          $OpcionesTable,
                          RespuestasIntentoData
                        >(
                          currentTable: table,
                          referencedTable: $$OpcionesTableReferences
                              ._respuestasIntentoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OpcionesTableReferences(
                                db,
                                table,
                                p0,
                              ).respuestasIntentoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.opcionElegidaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OpcionesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OpcionesTable,
      Opcione,
      $$OpcionesTableFilterComposer,
      $$OpcionesTableOrderingComposer,
      $$OpcionesTableAnnotationComposer,
      $$OpcionesTableCreateCompanionBuilder,
      $$OpcionesTableUpdateCompanionBuilder,
      (Opcione, $$OpcionesTableReferences),
      Opcione,
      PrefetchHooks Function({bool preguntaId, bool respuestasIntentoRefs})
    >;
typedef $$IntentosTableCreateCompanionBuilder = IntentosCompanion Function({
  Value<int> id,
  required DateTime fecha,
  required String tipo,
  required String configJson,
  required int correctas,
  required int incorrectas,
  required int tiempoUsado,
});
typedef $$IntentosTableUpdateCompanionBuilder = IntentosCompanion Function({
  Value<int> id,
  Value<DateTime> fecha,
  Value<String> tipo,
  Value<String> configJson,
  Value<int> correctas,
  Value<int> incorrectas,
  Value<int> tiempoUsado,
});

final class $$IntentosTableReferences
    extends BaseReferences<_$AppDatabase, $IntentosTable, Intento> {
  $$IntentosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $RespuestasIntentoTable,
    List<RespuestasIntentoData>
  >
  _respuestasIntentoRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.respuestasIntento,
        aliasName: 'intentos__id__respuestas_intento__intento_id',
      );

  $$RespuestasIntentoTableProcessedTableManager get respuestasIntentoRefs {
    final manager = $$RespuestasIntentoTableTableManager(
      $_db,
      $_db.respuestasIntento,
    ).filter((f) => f.intentoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _respuestasIntentoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IntentosTableFilterComposer
    extends Composer<_$AppDatabase, $IntentosTable> {
  $$IntentosTableFilterComposer({
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

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctas => $composableBuilder(
    column: $table.correctas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incorrectas => $composableBuilder(
    column: $table.incorrectas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tiempoUsado => $composableBuilder(
    column: $table.tiempoUsado,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> respuestasIntentoRefs(
    Expression<bool> Function($$RespuestasIntentoTableFilterComposer f) f,
  ) {
    final $$RespuestasIntentoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.respuestasIntento,
      getReferencedColumn: (t) => t.intentoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RespuestasIntentoTableFilterComposer(
            $db: $db,
            $table: $db.respuestasIntento,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IntentosTableOrderingComposer
    extends Composer<_$AppDatabase, $IntentosTable> {
  $$IntentosTableOrderingComposer({
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

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctas => $composableBuilder(
    column: $table.correctas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incorrectas => $composableBuilder(
    column: $table.incorrectas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tiempoUsado => $composableBuilder(
    column: $table.tiempoUsado,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IntentosTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntentosTable> {
  $$IntentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctas =>
      $composableBuilder(column: $table.correctas, builder: (column) => column);

  GeneratedColumn<int> get incorrectas => $composableBuilder(
    column: $table.incorrectas,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tiempoUsado => $composableBuilder(
    column: $table.tiempoUsado,
    builder: (column) => column,
  );

  Expression<T> respuestasIntentoRefs<T extends Object>(
    Expression<T> Function($$RespuestasIntentoTableAnnotationComposer a) f,
  ) {
    final $$RespuestasIntentoTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.respuestasIntento,
          getReferencedColumn: (t) => t.intentoId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RespuestasIntentoTableAnnotationComposer(
                $db: $db,
                $table: $db.respuestasIntento,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$IntentosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IntentosTable,
          Intento,
          $$IntentosTableFilterComposer,
          $$IntentosTableOrderingComposer,
          $$IntentosTableAnnotationComposer,
          $$IntentosTableCreateCompanionBuilder,
          $$IntentosTableUpdateCompanionBuilder,
          (Intento, $$IntentosTableReferences),
          Intento,
          PrefetchHooks Function({bool respuestasIntentoRefs})
        > {
  $$IntentosTableTableManager(_$AppDatabase db, $IntentosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<int> correctas = const Value.absent(),
                Value<int> incorrectas = const Value.absent(),
                Value<int> tiempoUsado = const Value.absent(),
              }) => IntentosCompanion(
                id: id,
                fecha: fecha,
                tipo: tipo,
                configJson: configJson,
                correctas: correctas,
                incorrectas: incorrectas,
                tiempoUsado: tiempoUsado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime fecha,
                required String tipo,
                required String configJson,
                required int correctas,
                required int incorrectas,
                required int tiempoUsado,
              }) => IntentosCompanion.insert(
                id: id,
                fecha: fecha,
                tipo: tipo,
                configJson: configJson,
                correctas: correctas,
                incorrectas: incorrectas,
                tiempoUsado: tiempoUsado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IntentosTable, Intento>(table),
                  $$IntentosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({respuestasIntentoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (respuestasIntentoRefs) db.respuestasIntento,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (respuestasIntentoRefs)
                    await $_getPrefetchedData<
                      Intento,
                      $IntentosTable,
                      RespuestasIntentoData
                    >(
                      currentTable: table,
                      referencedTable: $$IntentosTableReferences
                          ._respuestasIntentoRefsTable(db),
                      managerFromTypedResult: (p0) => $$IntentosTableReferences(
                        db,
                        table,
                        p0,
                      ).respuestasIntentoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.intentoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$IntentosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IntentosTable,
      Intento,
      $$IntentosTableFilterComposer,
      $$IntentosTableOrderingComposer,
      $$IntentosTableAnnotationComposer,
      $$IntentosTableCreateCompanionBuilder,
      $$IntentosTableUpdateCompanionBuilder,
      (Intento, $$IntentosTableReferences),
      Intento,
      PrefetchHooks Function({bool respuestasIntentoRefs})
    >;
typedef $$RespuestasIntentoTableCreateCompanionBuilder =
    RespuestasIntentoCompanion Function({
      Value<int> id,
      required int intentoId,
      required int preguntaId,
      Value<int?> opcionElegidaId,
      required bool esCorrecta,
    });
typedef $$RespuestasIntentoTableUpdateCompanionBuilder =
    RespuestasIntentoCompanion Function({
      Value<int> id,
      Value<int> intentoId,
      Value<int> preguntaId,
      Value<int?> opcionElegidaId,
      Value<bool> esCorrecta,
    });

final class $$RespuestasIntentoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RespuestasIntentoTable,
          RespuestasIntentoData
        > {
  $$RespuestasIntentoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IntentosTable _intentoIdTable(_$AppDatabase db) =>
      db.intentos.createAlias('respuestas_intento__intento_id__intentos__id');

  $$IntentosTableProcessedTableManager get intentoId {
    final $_column = $_itemColumn<int>('intento_id')!;

    final manager = $$IntentosTableTableManager(
      $_db,
      $_db.intentos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_intentoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PreguntasTable _preguntaIdTable(_$AppDatabase db) => db.preguntas
      .createAlias('respuestas_intento__pregunta_id__preguntas__id');

  $$PreguntasTableProcessedTableManager get preguntaId {
    final $_column = $_itemColumn<int>('pregunta_id')!;

    final manager = $$PreguntasTableTableManager(
      $_db,
      $_db.preguntas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_preguntaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OpcionesTable _opcionElegidaIdTable(_$AppDatabase db) => db.opciones
      .createAlias('respuestas_intento__opcion_elegida_id__opciones__id');

  $$OpcionesTableProcessedTableManager? get opcionElegidaId {
    final $_column = $_itemColumn<int>('opcion_elegida_id');
    if ($_column == null) return null;
    final manager = $$OpcionesTableTableManager(
      $_db,
      $_db.opciones,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_opcionElegidaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RespuestasIntentoTableFilterComposer
    extends Composer<_$AppDatabase, $RespuestasIntentoTable> {
  $$RespuestasIntentoTableFilterComposer({
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

  ColumnFilters<bool> get esCorrecta => $composableBuilder(
    column: $table.esCorrecta,
    builder: (column) => ColumnFilters(column),
  );

  $$IntentosTableFilterComposer get intentoId {
    final $$IntentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.intentoId,
      referencedTable: $db.intentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntentosTableFilterComposer(
            $db: $db,
            $table: $db.intentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PreguntasTableFilterComposer get preguntaId {
    final $$PreguntasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preguntaId,
      referencedTable: $db.preguntas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreguntasTableFilterComposer(
            $db: $db,
            $table: $db.preguntas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OpcionesTableFilterComposer get opcionElegidaId {
    final $$OpcionesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.opcionElegidaId,
      referencedTable: $db.opciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OpcionesTableFilterComposer(
            $db: $db,
            $table: $db.opciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RespuestasIntentoTableOrderingComposer
    extends Composer<_$AppDatabase, $RespuestasIntentoTable> {
  $$RespuestasIntentoTableOrderingComposer({
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

  ColumnOrderings<bool> get esCorrecta => $composableBuilder(
    column: $table.esCorrecta,
    builder: (column) => ColumnOrderings(column),
  );

  $$IntentosTableOrderingComposer get intentoId {
    final $$IntentosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.intentoId,
      referencedTable: $db.intentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntentosTableOrderingComposer(
            $db: $db,
            $table: $db.intentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PreguntasTableOrderingComposer get preguntaId {
    final $$PreguntasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preguntaId,
      referencedTable: $db.preguntas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreguntasTableOrderingComposer(
            $db: $db,
            $table: $db.preguntas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OpcionesTableOrderingComposer get opcionElegidaId {
    final $$OpcionesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.opcionElegidaId,
      referencedTable: $db.opciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OpcionesTableOrderingComposer(
            $db: $db,
            $table: $db.opciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RespuestasIntentoTableAnnotationComposer
    extends Composer<_$AppDatabase, $RespuestasIntentoTable> {
  $$RespuestasIntentoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get esCorrecta => $composableBuilder(
    column: $table.esCorrecta,
    builder: (column) => column,
  );

  $$IntentosTableAnnotationComposer get intentoId {
    final $$IntentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.intentoId,
      referencedTable: $db.intentos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IntentosTableAnnotationComposer(
            $db: $db,
            $table: $db.intentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PreguntasTableAnnotationComposer get preguntaId {
    final $$PreguntasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preguntaId,
      referencedTable: $db.preguntas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PreguntasTableAnnotationComposer(
            $db: $db,
            $table: $db.preguntas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OpcionesTableAnnotationComposer get opcionElegidaId {
    final $$OpcionesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.opcionElegidaId,
      referencedTable: $db.opciones,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OpcionesTableAnnotationComposer(
            $db: $db,
            $table: $db.opciones,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RespuestasIntentoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RespuestasIntentoTable,
          RespuestasIntentoData,
          $$RespuestasIntentoTableFilterComposer,
          $$RespuestasIntentoTableOrderingComposer,
          $$RespuestasIntentoTableAnnotationComposer,
          $$RespuestasIntentoTableCreateCompanionBuilder,
          $$RespuestasIntentoTableUpdateCompanionBuilder,
          (RespuestasIntentoData, $$RespuestasIntentoTableReferences),
          RespuestasIntentoData,
          PrefetchHooks Function({
            bool intentoId,
            bool preguntaId,
            bool opcionElegidaId,
          })
        > {
  $$RespuestasIntentoTableTableManager(
    _$AppDatabase db,
    $RespuestasIntentoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RespuestasIntentoTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RespuestasIntentoTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RespuestasIntentoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> intentoId = const Value.absent(),
                Value<int> preguntaId = const Value.absent(),
                Value<int?> opcionElegidaId = const Value.absent(),
                Value<bool> esCorrecta = const Value.absent(),
              }) => RespuestasIntentoCompanion(
                id: id,
                intentoId: intentoId,
                preguntaId: preguntaId,
                opcionElegidaId: opcionElegidaId,
                esCorrecta: esCorrecta,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int intentoId,
                required int preguntaId,
                Value<int?> opcionElegidaId = const Value.absent(),
                required bool esCorrecta,
              }) => RespuestasIntentoCompanion.insert(
                id: id,
                intentoId: intentoId,
                preguntaId: preguntaId,
                opcionElegidaId: opcionElegidaId,
                esCorrecta: esCorrecta,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RespuestasIntentoTable, RespuestasIntentoData>(
                    table,
                  ),
                  $$RespuestasIntentoTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                intentoId = false,
                preguntaId = false,
                opcionElegidaId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (intentoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.intentoId,
                            referencedTable: $$RespuestasIntentoTableReferences
                                ._intentoIdTable(db),
                            referencedColumn: $$RespuestasIntentoTableReferences
                                ._intentoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (preguntaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.preguntaId,
                            referencedTable: $$RespuestasIntentoTableReferences
                                ._preguntaIdTable(db),
                            referencedColumn: $$RespuestasIntentoTableReferences
                                ._preguntaIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (opcionElegidaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.opcionElegidaId,
                            referencedTable: $$RespuestasIntentoTableReferences
                                ._opcionElegidaIdTable(db),
                            referencedColumn: $$RespuestasIntentoTableReferences
                                ._opcionElegidaIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RespuestasIntentoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RespuestasIntentoTable,
      RespuestasIntentoData,
      $$RespuestasIntentoTableFilterComposer,
      $$RespuestasIntentoTableOrderingComposer,
      $$RespuestasIntentoTableAnnotationComposer,
      $$RespuestasIntentoTableCreateCompanionBuilder,
      $$RespuestasIntentoTableUpdateCompanionBuilder,
      (RespuestasIntentoData, $$RespuestasIntentoTableReferences),
      RespuestasIntentoData,
      PrefetchHooks Function({
        bool intentoId,
        bool preguntaId,
        bool opcionElegidaId,
      })
    >;
typedef $$QuizzesGuardadosTableCreateCompanionBuilder =
    QuizzesGuardadosCompanion Function({
      Value<int> id,
      required String nombre,
      required String configJson,
    });
typedef $$QuizzesGuardadosTableUpdateCompanionBuilder =
    QuizzesGuardadosCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> configJson,
    });

class $$QuizzesGuardadosTableFilterComposer
    extends Composer<_$AppDatabase, $QuizzesGuardadosTable> {
  $$QuizzesGuardadosTableFilterComposer({
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

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizzesGuardadosTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizzesGuardadosTable> {
  $$QuizzesGuardadosTableOrderingComposer({
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

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizzesGuardadosTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizzesGuardadosTable> {
  $$QuizzesGuardadosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );
}

class $$QuizzesGuardadosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizzesGuardadosTable,
          QuizzesGuardado,
          $$QuizzesGuardadosTableFilterComposer,
          $$QuizzesGuardadosTableOrderingComposer,
          $$QuizzesGuardadosTableAnnotationComposer,
          $$QuizzesGuardadosTableCreateCompanionBuilder,
          $$QuizzesGuardadosTableUpdateCompanionBuilder,
          (
            QuizzesGuardado,
            BaseReferences<
              _$AppDatabase,
              $QuizzesGuardadosTable,
              QuizzesGuardado
            >,
          ),
          QuizzesGuardado,
          PrefetchHooks Function()
        > {
  $$QuizzesGuardadosTableTableManager(
    _$AppDatabase db,
    $QuizzesGuardadosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizzesGuardadosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizzesGuardadosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizzesGuardadosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> configJson = const Value.absent(),
              }) => QuizzesGuardadosCompanion(
                id: id,
                nombre: nombre,
                configJson: configJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String configJson,
              }) => QuizzesGuardadosCompanion.insert(
                id: id,
                nombre: nombre,
                configJson: configJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuizzesGuardadosTable, QuizzesGuardado>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $QuizzesGuardadosTable,
                    QuizzesGuardado
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizzesGuardadosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizzesGuardadosTable,
      QuizzesGuardado,
      $$QuizzesGuardadosTableFilterComposer,
      $$QuizzesGuardadosTableOrderingComposer,
      $$QuizzesGuardadosTableAnnotationComposer,
      $$QuizzesGuardadosTableCreateCompanionBuilder,
      $$QuizzesGuardadosTableUpdateCompanionBuilder,
      (
        QuizzesGuardado,
        BaseReferences<_$AppDatabase, $QuizzesGuardadosTable, QuizzesGuardado>,
      ),
      QuizzesGuardado,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FacultadesTableTableManager get facultades =>
      $$FacultadesTableTableManager(_db, _db.facultades);
  $$MateriasTableTableManager get materias =>
      $$MateriasTableTableManager(_db, _db.materias);
  $$TemasTableTableManager get temas =>
      $$TemasTableTableManager(_db, _db.temas);
  $$PreguntasTableTableManager get preguntas =>
      $$PreguntasTableTableManager(_db, _db.preguntas);
  $$OpcionesTableTableManager get opciones =>
      $$OpcionesTableTableManager(_db, _db.opciones);
  $$IntentosTableTableManager get intentos =>
      $$IntentosTableTableManager(_db, _db.intentos);
  $$RespuestasIntentoTableTableManager get respuestasIntento =>
      $$RespuestasIntentoTableTableManager(_db, _db.respuestasIntento);
  $$QuizzesGuardadosTableTableManager get quizzesGuardados =>
      $$QuizzesGuardadosTableTableManager(_db, _db.quizzesGuardados);
}
