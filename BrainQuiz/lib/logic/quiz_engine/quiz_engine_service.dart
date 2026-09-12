import '../../data/repositories/quiz_repository.dart';
import 'quiz_engine.dart';
import 'quiz_models.dart';

class PreguntasInsuficientesException implements Exception {
  final int disponibles;
  final int solicitadas;
  final String? contexto;

  PreguntasInsuficientesException(
    this.disponibles,
    this.solicitadas, {
    this.contexto,
  });

  @override
  String toString() {
    final mensaje =
        'Solo hay $disponibles preguntas disponibles, se pidieron $solicitadas.';
    return contexto == null ? mensaje : '$contexto\n$mensaje';
  }
}

/// Orquesta filtros, selección de candidatas y creación de la sesión.
class QuizEngineService {
  QuizEngineService(this._repository);
  final QuizRepository _repository;

  Future<QuizSession> iniciarSesion(QuizFiltro filtro) async {
    if (filtro.cantidadPreguntas <= 0) {
      throw ArgumentError.value(
        filtro.cantidadPreguntas,
        'cantidadPreguntas',
        'Debe ser mayor que cero.',
      );
    }
    final candidatas = await _repository.obtenerPreguntasCandidatas(filtro);

    if (candidatas.length < filtro.cantidadPreguntas) {
      throw PreguntasInsuficientesException(
        candidatas.length,
        filtro.cantidadPreguntas,
      );
    }

    candidatas.shuffle();
    final seleccionadas = candidatas.take(filtro.cantidadPreguntas).toList();

    return QuizSession(preguntas: seleccionadas, filtro: filtro);
  }

  Future<QuizSession> iniciarSesionDistribuida(QuizFiltro filtro) async {
    if (!filtro.tieneDistribucion) return iniciarSesion(filtro);

    final seleccionadas = <PreguntaConOpciones>[];
    for (final item in filtro.distribucion) {
      if (item.cantidad <= 0) continue;
      final subFiltro = QuizFiltro(
        facultadId: filtro.facultadId,
        materiaId: item.materiaId,
        temaId: item.temaId,
        dificultades: filtro.dificultades,
        cantidadPreguntas: item.cantidad,
        tipo: filtro.tipo,
      );
      final candidatas = await _repository.obtenerPreguntasCandidatas(
        subFiltro,
      );
      if (candidatas.length < item.cantidad) {
        throw PreguntasInsuficientesException(
          candidatas.length,
          item.cantidad,
          contexto: item.temaId == null
              ? 'No hay suficientes preguntas en la materia seleccionada.'
              : 'No hay suficientes preguntas en el tema seleccionado.',
        );
      }
      candidatas.shuffle();
      seleccionadas.addAll(candidatas.take(item.cantidad));
    }

    if (seleccionadas.isEmpty) {
      throw ArgumentError(
        'Selecciona al menos una materia con una cantidad mayor que cero.',
      );
    }

    final filtroFinal = QuizFiltro(
      facultadId: filtro.facultadId,
      dificultades: filtro.dificultades,
      cantidadPreguntas: seleccionadas.length,
      tiempoLimiteSegundos: filtro.tiempoLimiteSegundos,
      tipo: filtro.tipo,
      distribucion: filtro.distribucion,
    );
    seleccionadas.shuffle();
    return QuizSession(preguntas: seleccionadas, filtro: filtroFinal);
  }
}
