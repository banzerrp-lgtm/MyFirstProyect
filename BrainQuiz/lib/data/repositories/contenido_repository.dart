import 'package:drift/drift.dart';

import '../database/database.dart';

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

  /// Cantidad de preguntas por tema (para mostrar "42 preguntas" en la lista).
  Stream<int> watchCantidadPreguntas(int temaId) {
    final query = _db.select(_db.preguntas)
      ..where((t) => t.temaId.equals(temaId));
    return query.watch().map((rows) => rows.length);
  }
}
