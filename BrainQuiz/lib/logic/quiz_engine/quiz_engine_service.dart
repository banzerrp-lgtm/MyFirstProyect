import '../../data/repositories/quiz_repository.dart';
import 'quiz_engine.dart';
import 'quiz_models.dart';

class PreguntasInsuficientesException implements Exception {
  final int disponibles;
  final int solicitadas;

  PreguntasInsuficientesException(this.disponibles, this.solicitadas);

  @override
  String toString() =>
      'Solo hay $disponibles preguntas disponibles, se pidieron $solicitadas.';
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
}
