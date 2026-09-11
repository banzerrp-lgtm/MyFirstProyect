import 'package:drift/drift.dart';

// ─────────────────────────────────────────────
// Jerarquía académica: Facultad → Materia → Tema → Pregunta → Opción
// ─────────────────────────────────────────────

class Facultades extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 200)();
}

class Materias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get facultadId =>
      integer().references(Facultades, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text().withLength(min: 1, max: 200)();
}

class Temas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get materiaId =>
      integer().references(Materias, #id, onDelete: KeyAction.cascade)();
  TextColumn get nombre => text().withLength(min: 1, max: 200)();
}

/// dificultad: 'facil' | 'media' | 'dificil' (validado en capa de dominio)
@TableIndex(name: 'idx_preguntas_tema', columns: {#temaId})
@TableIndex(name: 'idx_preguntas_dificultad', columns: {#dificultad})
class Preguntas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get temaId =>
      integer().references(Temas, #id, onDelete: KeyAction.cascade)();
  TextColumn get enunciado => text()();
  TextColumn get explicacion => text().nullable()();
  TextColumn get dificultad => text().withLength(min: 1, max: 20)();
}

class Opciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get preguntaId =>
      integer().references(Preguntas, #id, onDelete: KeyAction.cascade)();
  TextColumn get texto => text()();
  BoolColumn get esCorrecta => boolean().withDefault(const Constant(false))();
  IntColumn get orden => integer()();
}

// ─────────────────────────────────────────────
// Historial de uso
// ─────────────────────────────────────────────

/// tipo: 'practica_tema' | 'practica_materia' | 'simulacro'
class Intentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get fecha => dateTime()();
  TextColumn get tipo => text().withLength(min: 1, max: 30)();
  TextColumn get configJson => text()();
  IntColumn get correctas => integer()();
  IntColumn get incorrectas => integer()();
  IntColumn get tiempoUsado => integer()(); // segundos
}

class RespuestasIntento extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get intentoId =>
      integer().references(Intentos, #id, onDelete: KeyAction.cascade)();
  IntColumn get preguntaId =>
      integer().references(Preguntas, #id, onDelete: KeyAction.cascade)();
  IntColumn get opcionElegidaId => integer().nullable().references(
    Opciones,
    #id,
    onDelete: KeyAction.setNull,
  )();
  BoolColumn get esCorrecta => boolean()();
}

class QuizzesGuardados extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 200)();
  TextColumn get configJson => text()();
}
