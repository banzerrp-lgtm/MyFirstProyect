// Modelos de dominio del motor de quiz (independientes de Drift/Flutter).

class QuizFiltro {
  final int? facultadId;
  final int? materiaId;
  final int? temaId;
  final Set<String> dificultades;
  final int cantidadPreguntas;
  final int? tiempoLimiteSegundos;
  final String tipo;

  const QuizFiltro({
    this.facultadId,
    this.materiaId,
    this.temaId,
    this.dificultades = const {},
    required this.cantidadPreguntas,
    this.tiempoLimiteSegundos,
    required this.tipo,
  });

  Map<String, dynamic> toJson() => {
    'facultadId': facultadId,
    'materiaId': materiaId,
    'temaId': temaId,
    'dificultades': dificultades.toList(),
    'cantidadPreguntas': cantidadPreguntas,
    'tiempoLimiteSegundos': tiempoLimiteSegundos,
    'tipo': tipo,
  };
}

class OpcionModel {
  final int id;
  final String texto;
  final bool esCorrecta;
  final int orden;

  const OpcionModel({
    required this.id,
    required this.texto,
    required this.esCorrecta,
    required this.orden,
  });
}

class PreguntaConOpciones {
  final int id;
  final int temaId;
  final int? materiaId;
  final String? temaNombre;
  final String? materiaNombre;
  final String enunciado;
  final String? explicacion;
  final String dificultad;
  final List<OpcionModel> opciones;

  const PreguntaConOpciones({
    required this.id,
    required this.temaId,
    this.materiaId,
    this.temaNombre,
    this.materiaNombre,
    required this.enunciado,
    required this.explicacion,
    required this.dificultad,
    required this.opciones,
  });
}

class RespuestaRegistrada {
  final int preguntaId;
  final int? opcionElegidaId;
  final bool esCorrecta;

  const RespuestaRegistrada({
    required this.preguntaId,
    required this.opcionElegidaId,
    required this.esCorrecta,
  });
}

class QuizResultado {
  final int totalPreguntas;
  final int correctas;
  final int incorrectas;
  final int sinResponder;
  final int tiempoUsadoSegundos;
  final List<RespuestaRegistrada> respuestas;
  final Map<int, ({int correctas, int total})> porTema;
  final Map<int, ({int correctas, int total})> porMateria;
  final List<PreguntaConOpciones> preguntas;

  const QuizResultado({
    required this.totalPreguntas,
    required this.correctas,
    required this.incorrectas,
    required this.sinResponder,
    required this.tiempoUsadoSegundos,
    required this.respuestas,
    required this.porTema,
    this.porMateria = const {},
    this.preguntas = const [],
  });

  double get porcentaje =>
      totalPreguntas == 0 ? 0 : (correctas / totalPreguntas) * 100;
}

class QuizUiState {
  final PreguntaConOpciones pregunta;
  final int indice;
  final int total;
  final RespuestaRegistrada? respuestaActual;
  final bool marcada;
  final bool esPrimera;
  final bool esUltima;

  const QuizUiState({
    required this.pregunta,
    required this.indice,
    required this.total,
    required this.respuestaActual,
    required this.marcada,
    required this.esPrimera,
    required this.esUltima,
  });
}
