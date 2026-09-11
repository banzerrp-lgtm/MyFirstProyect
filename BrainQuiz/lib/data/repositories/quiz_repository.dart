import 'dart:convert';

import 'package:drift/drift.dart';

import '../../logic/quiz_engine/quiz_models.dart';
import '../database/database.dart';

class QuizRepository {
  QuizRepository(this._db);
  final AppDatabase _db;

  Future<List<PreguntaConOpciones>> obtenerPreguntasCandidatas(
    QuizFiltro filtro,
  ) async {
    final joins = <Join>[
      innerJoin(_db.temas, _db.temas.id.equalsExp(_db.preguntas.temaId)),
    ];
    if (filtro.temaId == null &&
        filtro.materiaId == null &&
        filtro.facultadId != null) {
      joins.add(
        innerJoin(
          _db.materias,
          _db.materias.id.equalsExp(_db.temas.materiaId),
        ),
      );
    }

    final query = _db.select(_db.preguntas).join(joins);

    if (filtro.temaId != null) {
      query.where(_db.preguntas.temaId.equals(filtro.temaId!));
    } else if (filtro.materiaId != null) {
      query.where(_db.temas.materiaId.equals(filtro.materiaId!));
    } else if (filtro.facultadId != null) {
      query.where(_db.materias.facultadId.equals(filtro.facultadId!));
    }

    if (filtro.dificultades.isNotEmpty) {
      query.where(_db.preguntas.dificultad.isIn(filtro.dificultades));
    }

    final filas = await query.get();
    final preguntas = filas.map((f) => f.readTable(_db.preguntas)).toList();
    if (preguntas.isEmpty) return [];

    final ids = preguntas.map((pregunta) => pregunta.id).toList();
    final opcionesQuery = _db.select(_db.opciones)
      ..where((opcion) => opcion.preguntaId.isIn(ids))
      ..orderBy([(opcion) => OrderingTerm.asc(opcion.orden)]);
    final opciones = await opcionesQuery.get();

    return preguntas.map((pregunta) {
      final ops = opciones
          .where((opcion) => opcion.preguntaId == pregunta.id)
          .map(
            (opcion) => OpcionModel(
              id: opcion.id,
              texto: opcion.texto,
              esCorrecta: opcion.esCorrecta,
              orden: opcion.orden,
            ),
          )
          .toList();
      return PreguntaConOpciones(
        id: pregunta.id,
        temaId: pregunta.temaId,
        enunciado: pregunta.enunciado,
        explicacion: pregunta.explicacion,
        dificultad: pregunta.dificultad,
        opciones: ops,
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

      final intentoId = await _db.into(_db.intentos).insert(
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
        await _db.into(_db.respuestasIntento).insert(
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
}
