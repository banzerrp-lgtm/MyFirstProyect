import 'package:drift/drift.dart';

import '../database/database.dart';
import '../../logic/quiz_engine/quiz_models.dart';

/// Lecturas de la jerarquía académica (Facultad → Materia → Tema).
class ContenidoRepository {
  ContenidoRepository(this._db);
  final AppDatabase _db;

  Stream<List<Facultade>> watchFacultades() =>
      _db.select(_db.facultades).watch();

  Stream<List<Materia>> watchMaterias(int facultadId) {
    final query = _db.select(_db.materias)
      ..where((t) => t.facultadId.equals(facultadId))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return query.watch();
  }

  Stream<List<Tema>> watchTemas(int materiaId) {
    final query = _db.select(_db.temas)
      ..where((t) => t.materiaId.equals(materiaId))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return query.watch();
  }

  Stream<Materia?> watchMateria(int id) {
    final query = _db.select(_db.materias)..where((m) => m.id.equals(id));
    return query.watchSingleOrNull();
  }

  Stream<Tema?> watchTema(int id) {
    final query = _db.select(_db.temas)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull();
  }

  /// Cantidad de preguntas por tema (para mostrar "42 preguntas" en la lista).
  Stream<int> watchCantidadPreguntas(int temaId) {
    final query = _db.select(_db.preguntas)
      ..where((t) => t.temaId.equals(temaId));
    return query.watch().map((rows) => rows.length);
  }

  Stream<int> watchCantidadPreguntasMateria(int materiaId) {
    final query = _db.select(_db.preguntas).join([
      innerJoin(_db.temas, _db.temas.id.equalsExp(_db.preguntas.temaId)),
    ])..where(_db.temas.materiaId.equals(materiaId));
    return query.watch().map((rows) => rows.length);
  }

  Stream<int> watchCantidadPreguntasFacultad(int facultadId) {
    final query = _db.select(_db.preguntas).join([
      innerJoin(_db.temas, _db.temas.id.equalsExp(_db.preguntas.temaId)),
      innerJoin(_db.materias, _db.materias.id.equalsExp(_db.temas.materiaId)),
    ])..where(_db.materias.facultadId.equals(facultadId));
    return query.watch().map((rows) => rows.length);
  }

  Stream<List<PreguntaConOpciones>> watchPreguntas(int temaId) {
    final query = _db.select(_db.preguntas)
      ..where((p) => p.temaId.equals(temaId))
      ..orderBy([(p) => OrderingTerm.asc(p.id)]);
    return query.watch().asyncMap((preguntas) async {
      final tema = await (_db.select(
        _db.temas,
      )..where((t) => t.id.equals(temaId))).getSingleOrNull();
      if (tema == null) return const <PreguntaConOpciones>[];

      final materia = await (_db.select(
        _db.materias,
      )..where((m) => m.id.equals(tema.materiaId))).getSingleOrNull();
      if (materia == null) return const <PreguntaConOpciones>[];

      if (preguntas.isEmpty) return const <PreguntaConOpciones>[];

      final ids = preguntas.map((p) => p.id).toList();
      final todasOpciones = await (_db.select(_db.opciones)
            ..where((o) => o.preguntaId.isIn(ids))
            ..orderBy([(o) => OrderingTerm.asc(o.orden)]))
          .get();

      final opcionesPorPregunta = <int, List<OpcionModel>>{};
      for (final o in todasOpciones) {
        opcionesPorPregunta.putIfAbsent(o.preguntaId, () => []).add(
          OpcionModel(
            id: o.id,
            texto: o.texto,
            esCorrecta: o.esCorrecta,
            orden: o.orden,
          ),
        );
      }

      return preguntas
          .map(
            (pregunta) => PreguntaConOpciones(
              id: pregunta.id,
              temaId: pregunta.temaId,
              materiaId: materia.id,
              temaNombre: tema.nombre,
              materiaNombre: materia.nombre,
              enunciado: pregunta.enunciado,
              explicacion: pregunta.explicacion,
              dificultad: pregunta.dificultad,
              opciones: opcionesPorPregunta[pregunta.id] ?? const [],
            ),
          )
          .toList();
    });
  }

  Future<int> crearFacultad({required String nombre}) => _db
      .into(_db.facultades)
      .insert(FacultadesCompanion.insert(nombre: nombre));

  Future<void> actualizarFacultad(int id, String nombre) async {
    await (_db.update(_db.facultades)..where((f) => f.id.equals(id))).write(
      FacultadesCompanion(nombre: Value(nombre)),
    );
  }

  Future<void> eliminarFacultad(int id) async {
    await (_db.delete(_db.facultades)..where((f) => f.id.equals(id))).go();
  }

  Future<int> crearMateria({required int facultadId, required String nombre}) =>
      _db
          .into(_db.materias)
          .insert(
            MateriasCompanion.insert(facultadId: facultadId, nombre: nombre),
          );

  Future<void> actualizarMateria(int id, String nombre) async {
    await (_db.update(_db.materias)..where((m) => m.id.equals(id))).write(
      MateriasCompanion(nombre: Value(nombre)),
    );
  }

  Future<void> eliminarMateria(int id) async {
    await (_db.delete(_db.materias)..where((m) => m.id.equals(id))).go();
  }

  Future<int> crearTema({required int materiaId, required String nombre}) => _db
      .into(_db.temas)
      .insert(TemasCompanion.insert(materiaId: materiaId, nombre: nombre));

  Future<void> actualizarTema(int id, String nombre) async {
    await (_db.update(_db.temas)..where((t) => t.id.equals(id))).write(
      TemasCompanion(nombre: Value(nombre)),
    );
  }

  Future<void> eliminarTema(int id) async {
    await (_db.delete(_db.temas)..where((t) => t.id.equals(id))).go();
  }

  Future<int> crearPregunta({
    required int temaId,
    required String enunciado,
    required String? explicacion,
    required String dificultad,
    required List<({String texto, bool correcta})> opciones,
  }) async {
    return _db.transaction(() async {
      final id = await _db
          .into(_db.preguntas)
          .insert(
            PreguntasCompanion.insert(
              temaId: temaId,
              enunciado: enunciado,
              explicacion: Value(explicacion),
              dificultad: dificultad,
            ),
          );
      await _insertarOpciones(id, opciones);
      return id;
    });
  }

  Future<void> actualizarPregunta({
    required int id,
    required int temaId,
    required String enunciado,
    required String? explicacion,
    required String dificultad,
    required List<({String texto, bool correcta})> opciones,
  }) async {
    await _db.transaction(() async {
      await (_db.update(_db.preguntas)..where((p) => p.id.equals(id))).write(
        PreguntasCompanion(
          temaId: Value(temaId),
          enunciado: Value(enunciado),
          explicacion: Value(explicacion),
          dificultad: Value(dificultad),
        ),
      );
      await (_db.delete(
        _db.opciones,
      )..where((o) => o.preguntaId.equals(id))).go();
      await _insertarOpciones(id, opciones);
    });
  }

  Future<void> _insertarOpciones(
    int preguntaId,
    List<({String texto, bool correcta})> opciones,
  ) async {
    for (var i = 0; i < opciones.length; i++) {
      final opcion = opciones[i];
      await _db
          .into(_db.opciones)
          .insert(
            OpcionesCompanion.insert(
              preguntaId: preguntaId,
              texto: opcion.texto,
              esCorrecta: Value(opcion.correcta),
              orden: i,
            ),
          );
    }
  }

  Future<void> eliminarPregunta(int id) async {
    await (_db.delete(_db.preguntas)..where((p) => p.id.equals(id))).go();
  }
}
