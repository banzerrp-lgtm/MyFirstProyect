import 'dart:convert';

import 'package:drift/drift.dart';

import '../../logic/quiz_engine/quiz_models.dart';
import '../database/database.dart';

class IntentoResumen {
  const IntentoResumen({
    required this.fecha,
    required this.tipo,
    required this.correctas,
    required this.incorrectas,
    required this.tiempoUsado,
  });

  final DateTime fecha;
  final String tipo;
  final int correctas;
  final int incorrectas;
  final int tiempoUsado;

  int get total => correctas + incorrectas;
  double get porcentaje => total == 0 ? 0 : correctas * 100 / total;
}

class ErrorPreguntaResumen {
  const ErrorPreguntaResumen({
    required this.preguntaId,
    required this.enunciado,
    required this.tema,
    required this.materia,
    required this.errores,
    required this.intentos,
  });

  final int preguntaId;
  final String enunciado;
  final String tema;
  final String materia;
  final int errores;
  final int intentos;
}

class ProgresoData {
  const ProgresoData({
    required this.intentos,
    required this.errores,
    required this.totalPreguntas,
    required this.totalCorrectas,
    required this.totalIncorrectas,
    required this.puntosEvolucion,
  });

  final List<IntentoResumen> intentos;
  final List<ErrorPreguntaResumen> errores;
  final int totalPreguntas;
  final int totalCorrectas;
  final int totalIncorrectas;
  final List<({DateTime fecha, double porcentaje})> puntosEvolucion;

  double get porcentaje =>
      totalPreguntas == 0 ? 0 : totalCorrectas * 100 / totalPreguntas;
}

class QuizRepository {
  QuizRepository(this._db);
  final AppDatabase _db;

  Future<List<PreguntaConOpciones>> obtenerPreguntasCandidatas(
    QuizFiltro filtro,
  ) async {
    final joins = <Join>[
      innerJoin(_db.temas, _db.temas.id.equalsExp(_db.preguntas.temaId)),
      innerJoin(_db.materias, _db.materias.id.equalsExp(_db.temas.materiaId)),
    ];

    final query = _db.select(_db.preguntas).join(joins);

    if (filtro.temaId != null) {
      query.where(_db.preguntas.temaId.equals(filtro.temaId!));
    }
    if (filtro.materiaId != null) {
      query.where(_db.temas.materiaId.equals(filtro.materiaId!));
    }
    if (filtro.facultadId != null) {
      query.where(_db.materias.facultadId.equals(filtro.facultadId!));
    }

    if (filtro.dificultades.isNotEmpty) {
      query.where(_db.preguntas.dificultad.isIn(filtro.dificultades));
    }

    final filas = await query.get();
    if (filas.isEmpty) return const [];

    final preguntas = <Pregunta>[];
    final materiaIdPorPregunta = <int, int>{};
    final temaNombrePorPregunta = <int, String>{};
    final materiaNombrePorPregunta = <int, String>{};

    for (final fila in filas) {
      final pregunta = fila.readTable(_db.preguntas);
      final tema = fila.readTable(_db.temas);
      final materia = fila.readTable(_db.materias);
      preguntas.add(pregunta);
      materiaIdPorPregunta[pregunta.id] = materia.id;
      temaNombrePorPregunta[pregunta.id] = tema.nombre;
      materiaNombrePorPregunta[pregunta.id] = materia.nombre;
    }

    final ids = preguntas.map((pregunta) => pregunta.id).toList();
    final opcionesQuery = _db.select(_db.opciones)
      ..where((opcion) => opcion.preguntaId.isIn(ids))
      ..orderBy([(opcion) => OrderingTerm.asc(opcion.orden)]);
    final opciones = await opcionesQuery.get();

    final opcionesPorPregunta = <int, List<OpcionModel>>{};
    for (final opcion in opciones) {
      opcionesPorPregunta.putIfAbsent(opcion.preguntaId, () => []).add(
        OpcionModel(
          id: opcion.id,
          texto: opcion.texto,
          esCorrecta: opcion.esCorrecta,
          orden: opcion.orden,
        ),
      );
    }

    return preguntas.map((pregunta) {
      return PreguntaConOpciones(
        id: pregunta.id,
        temaId: pregunta.temaId,
        materiaId: materiaIdPorPregunta[pregunta.id],
        temaNombre: temaNombrePorPregunta[pregunta.id],
        materiaNombre: materiaNombrePorPregunta[pregunta.id],
        enunciado: pregunta.enunciado,
        explicacion: pregunta.explicacion,
        dificultad: pregunta.dificultad,
        opciones: opcionesPorPregunta[pregunta.id] ?? const [],
      );
    }).toList();
  }

  Future<int> guardarIntento({
    required QuizFiltro filtro,
    required List<RespuestaRegistrada> respuestas,
    required int tiempoUsadoSegundos,
  }) {
    return _db.transaction(() async {
      final correctas = respuestas.where((r) => r.esCorrecta).length;
      final incorrectas = respuestas
          .where((r) => !r.esCorrecta && r.opcionElegidaId != null)
          .length;

      final intentoId = await _db
          .into(_db.intentos)
          .insert(
            IntentosCompanion.insert(
              fecha: DateTime.now(),
              tipo: filtro.tipo,
              configJson: jsonEncode(filtro.toJson()),
              correctas: correctas,
              incorrectas: incorrectas,
              tiempoUsado: tiempoUsadoSegundos,
            ),
          );

      for (final respuesta in respuestas) {
        await _db
            .into(_db.respuestasIntento)
            .insert(
              RespuestasIntentoCompanion.insert(
                intentoId: intentoId,
                preguntaId: respuesta.preguntaId,
                opcionElegidaId: Value(respuesta.opcionElegidaId),
                esCorrecta: respuesta.esCorrecta,
              ),
            );
      }

      return intentoId;
    });
  }

  Future<ProgresoData> obtenerProgreso() async {
    final intentos = await (_db.select(
      _db.intentos,
    )..orderBy([(i) => OrderingTerm.desc(i.fecha)])).get();
    if (intentos.isEmpty) {
      return const ProgresoData(
        intentos: [],
        errores: [],
        totalPreguntas: 0,
        totalCorrectas: 0,
        totalIncorrectas: 0,
        puntosEvolucion: [],
      );
    }

    final resumen = intentos
        .map(
          (i) => IntentoResumen(
            fecha: i.fecha,
            tipo: i.tipo,
            correctas: i.correctas,
            incorrectas: i.incorrectas,
            tiempoUsado: i.tiempoUsado,
          ),
        )
        .toList();
    final respuestaRows = await (_db.select(
      _db.respuestasIntento,
    )..where((r) => r.intentoId.isIn(intentos.map((i) => i.id)))).get();
    final preguntaIds = respuestaRows.map((r) => r.preguntaId).toSet().toList();
    final errores = <ErrorPreguntaResumen>[];
    if (preguntaIds.isNotEmpty) {
      final rows = await (_db.select(_db.preguntas).join([
        innerJoin(_db.temas, _db.temas.id.equalsExp(_db.preguntas.temaId)),
        innerJoin(_db.materias, _db.materias.id.equalsExp(_db.temas.materiaId)),
      ])..where(_db.preguntas.id.isIn(preguntaIds))).get();
      for (final row in rows) {
        final pregunta = row.readTable(_db.preguntas);
        final respuestas = respuestaRows.where(
          (respuesta) => respuesta.preguntaId == pregunta.id,
        );
        final fallos = respuestas
            .where((respuesta) => !respuesta.esCorrecta)
            .length;
        if (fallos > 0) {
          errores.add(
            ErrorPreguntaResumen(
              preguntaId: pregunta.id,
              enunciado: pregunta.enunciado,
              tema: row.readTable(_db.temas).nombre,
              materia: row.readTable(_db.materias).nombre,
              errores: fallos,
              intentos: respuestas.length,
            ),
          );
        }
      }
      errores.sort((a, b) => b.errores.compareTo(a.errores));
    }
    final puntos = resumen.reversed
        .map((i) => (fecha: i.fecha, porcentaje: i.porcentaje))
        .toList();
    return ProgresoData(
      intentos: resumen,
      errores: errores,
      totalPreguntas: resumen.fold(0, (sum, i) => sum + i.total),
      totalCorrectas: resumen.fold(0, (sum, i) => sum + i.correctas),
      totalIncorrectas: resumen.fold(0, (sum, i) => sum + i.incorrectas),
      puntosEvolucion: puntos,
    );
  }
}
