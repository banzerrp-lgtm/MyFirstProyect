import 'dart:math';

import 'quiz_models.dart';

enum EstadoSesion { enCurso, finalizada }

/// Motor puro (sin Flutter/Drift) para gestionar una sesión de quiz.
class QuizSession {
  QuizSession({
    required List<PreguntaConOpciones> preguntas,
    required this.filtro,
    Random? random,
  }) : preguntas = List.unmodifiable(
         List<PreguntaConOpciones>.from(preguntas)..shuffle(random ?? Random()),
       ),
       _respuestas = {},
       _pendientes = {};

  final List<PreguntaConOpciones> preguntas;
  final QuizFiltro filtro;

  int _indiceActual = 0;
  final Map<int, RespuestaRegistrada> _respuestas;
  final Set<int> _pendientes;
  EstadoSesion estado = EstadoSesion.enCurso;

  int get indiceActual => _indiceActual;
  int get total => preguntas.length;
  PreguntaConOpciones get preguntaActual => preguntas[_indiceActual];
  bool get esUltima => _indiceActual == preguntas.length - 1;
  bool get esPrimera => _indiceActual == 0;
  int get respondidas => _respuestas.length;

  RespuestaRegistrada? respuestaDe(int preguntaId) => _respuestas[preguntaId];
  bool estaPendiente(int preguntaId) => _pendientes.contains(preguntaId);

  void responder(int opcionId) {
    if (estado == EstadoSesion.finalizada) return;
    final pregunta = preguntaActual;
    final opcion = pregunta.opciones.firstWhere((o) => o.id == opcionId);
    _respuestas[pregunta.id] = RespuestaRegistrada(
      preguntaId: pregunta.id,
      opcionElegidaId: opcion.id,
      esCorrecta: opcion.esCorrecta,
    );
    _pendientes.remove(pregunta.id);
  }

  void marcarPendiente() {
    if (estado == EstadoSesion.enCurso) _pendientes.add(preguntaActual.id);
  }

  void desmarcarPendiente() {
    if (estado == EstadoSesion.enCurso) _pendientes.remove(preguntaActual.id);
  }

  void siguiente() {
    if (estado == EstadoSesion.enCurso && !esUltima) _indiceActual++;
  }

  void anterior() {
    if (estado == EstadoSesion.enCurso && !esPrimera) _indiceActual--;
  }

  void irA(int indice) {
    if (estado == EstadoSesion.enCurso &&
        indice >= 0 &&
        indice < preguntas.length) {
      _indiceActual = indice;
    }
  }

  QuizResultado finalizar({required int tiempoUsadoSegundos}) {
    if (estado == EstadoSesion.finalizada) {
      throw StateError('La sesión ya fue finalizada.');
    }
    estado = EstadoSesion.finalizada;

    final correctas = _respuestas.values.where((r) => r.esCorrecta).length;
    final incorrectas = _respuestas.values
        .where((r) => !r.esCorrecta && r.opcionElegidaId != null)
        .length;
    final sinResponder = preguntas.length - _respuestas.length;

    final porTema = <int, ({int correctas, int total})>{};
    final porMateria = <int, ({int correctas, int total})>{};
    for (final pregunta in preguntas) {
      final actual = porTema[pregunta.temaId] ?? (correctas: 0, total: 0);
      final respuesta = _respuestas[pregunta.id];
      porTema[pregunta.temaId] = (
        correctas:
            actual.correctas + ((respuesta?.esCorrecta ?? false) ? 1 : 0),
        total: actual.total + 1,
      );
      final materiaId = pregunta.materiaId;
      if (materiaId != null) {
        final materiaActual = porMateria[materiaId] ?? (correctas: 0, total: 0);
        porMateria[materiaId] = (
          correctas:
              materiaActual.correctas +
              ((respuesta?.esCorrecta ?? false) ? 1 : 0),
          total: materiaActual.total + 1,
        );
      }
    }

    final respuestasCompletas = preguntas
        .map(
          (pregunta) =>
              _respuestas[pregunta.id] ??
              RespuestaRegistrada(
                preguntaId: pregunta.id,
                opcionElegidaId: null,
                esCorrecta: false,
              ),
        )
        .toList();

    return QuizResultado(
      totalPreguntas: preguntas.length,
      correctas: correctas,
      incorrectas: incorrectas,
      sinResponder: sinResponder,
      tiempoUsadoSegundos: tiempoUsadoSegundos,
      respuestas: respuestasCompletas,
      porTema: porTema,
      porMateria: porMateria,
      preguntas: preguntas,
    );
  }
}
