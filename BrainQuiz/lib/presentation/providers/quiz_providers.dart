import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/quiz_repository.dart';
import '../../logic/quiz_engine/quiz_engine.dart';
import '../../logic/quiz_engine/quiz_engine_service.dart';
import '../../logic/quiz_engine/quiz_models.dart';
import 'database_provider.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(ref.watch(databaseProvider));
});

final progresoProvider = FutureProvider<ProgresoData>((ref) {
  return ref.watch(quizRepositoryProvider).obtenerProgreso();
});

final quizEngineServiceProvider = Provider<QuizEngineService>((ref) {
  return QuizEngineService(ref.watch(quizRepositoryProvider));
});

/// Expone un snapshot inmutable de la sesión activa.
class QuizSessionNotifier extends Notifier<QuizUiState?> {
  QuizSession? _session;

  @override
  QuizUiState? build() => null;

  Future<void> iniciar(QuizFiltro filtro) async {
    final service = ref.read(quizEngineServiceProvider);
    _session = await service.iniciarSesion(filtro);
    _actualizarEstado();
  }

  void responder(int opcionId) {
    _session?.responder(opcionId);
    _actualizarEstado();
  }

  void siguiente() {
    _session?.siguiente();
    _actualizarEstado();
  }

  void anterior() {
    _session?.anterior();
    _actualizarEstado();
  }

  void marcarPendiente() {
    _session?.marcarPendiente();
    _actualizarEstado();
  }

  void alternarPendiente() {
    final session = _session;
    if (session == null) return;
    final id = session.preguntaActual.id;
    if (session.estaPendiente(id)) {
      session.desmarcarPendiente();
    } else {
      session.marcarPendiente();
    }
    _actualizarEstado();
  }

  void irA(int indice) {
    _session?.irA(indice);
    _actualizarEstado();
  }

  Future<QuizResultado?> finalizar({required int tiempoUsadoSegundos}) async {
    final session = _session;
    if (session == null) return null;

    final resultado = session.finalizar(
      tiempoUsadoSegundos: tiempoUsadoSegundos,
    );

    await ref
        .read(quizRepositoryProvider)
        .guardarIntento(
          filtro: session.filtro,
          respuestas: resultado.respuestas,
          tiempoUsadoSegundos: tiempoUsadoSegundos,
        );

    ref.invalidate(progresoProvider);
    return resultado;
  }

  void limpiar() {
    _session = null;
    state = null;
  }

  void _actualizarEstado() {
    final session = _session;
    if (session == null) {
      state = null;
      return;
    }

    final pregunta = session.preguntaActual;
    state = QuizUiState(
      pregunta: pregunta,
      indice: session.indiceActual,
      total: session.total,
      respuestaActual: session.respuestaDe(pregunta.id),
      marcada: session.estaPendiente(pregunta.id),
      esPrimera: session.esPrimera,
      esUltima: session.esUltima,
    );
  }
}

final quizSessionProvider = NotifierProvider<QuizSessionNotifier, QuizUiState?>(
  QuizSessionNotifier.new,
);
