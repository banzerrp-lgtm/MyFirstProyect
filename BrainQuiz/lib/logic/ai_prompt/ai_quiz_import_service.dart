import 'dart:convert';

import '../../data/repositories/contenido_repository.dart';

class OpcionImportada {
  const OpcionImportada({required this.texto, required this.correcta});

  final String texto;
  final bool correcta;
}

class PreguntaImportada {
  const PreguntaImportada({
    required this.enunciado,
    this.explicacion,
    required this.dificultad,
    required this.opciones,
  });

  final String enunciado;
  final String? explicacion;
  final String dificultad;
  final List<OpcionImportada> opciones;
}

class AiImportParseResult {
  const AiImportParseResult({
    required this.preguntas,
    required this.advertencias,
  });

  final List<PreguntaImportada> preguntas;
  final List<String> advertencias;
}

class AiImportException implements Exception {
  const AiImportException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AiQuizImportService {
  AiQuizImportService(this._repo);

  final ContenidoRepository _repo;
  static const _dificultadesValidas = {'facil', 'media', 'dificil'};

  AiImportParseResult parsear(String contenido) {
    final texto = _limpiarTexto(contenido);
    if (texto.isEmpty) {
      throw const AiImportException('Pega el JSON o carga un archivo.');
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(texto);
    } catch (_) {
      throw const AiImportException(
        'El contenido no es JSON válido. Elimina texto adicional o markdown.',
      );
    }
    if (decoded is! Map) {
      throw const AiImportException('El JSON debe ser un objeto.');
    }

    final rawPreguntas = decoded['preguntas'];
    if (rawPreguntas is! List || rawPreguntas.isEmpty) {
      throw const AiImportException(
        'El JSON debe incluir una lista "preguntas" no vacía.',
      );
    }

    final preguntas = <PreguntaImportada>[];
    final advertencias = <String>[];
    for (var i = 0; i < rawPreguntas.length; i++) {
      final numero = i + 1;
      final raw = rawPreguntas[i];
      if (raw is! Map) {
        advertencias.add('Pregunta $numero: objeto inválido, omitida.');
        continue;
      }
      final map = Map<String, dynamic>.from(raw);
      final enunciado = '${map['enunciado'] ?? ''}'.trim();
      if (enunciado.isEmpty) {
        advertencias.add('Pregunta $numero: falta el enunciado, omitida.');
        continue;
      }

      var dificultad = '${map['dificultad'] ?? 'media'}'.trim().toLowerCase();
      if (!_dificultadesValidas.contains(dificultad)) {
        advertencias.add(
          'Pregunta $numero: dificultad inválida, se usó "media".',
        );
        dificultad = 'media';
      }

      final explicacionTexto = '${map['explicacion'] ?? ''}'.trim();
      final rawOpciones = map['opciones'];
      if (rawOpciones is! List || rawOpciones.length < 2) {
        advertencias.add('Pregunta $numero: necesita al menos 2 opciones.');
        continue;
      }

      final opciones = <OpcionImportada>[];
      for (final rawOpcion in rawOpciones) {
        if (rawOpcion is! Map) continue;
        final opcion = Map<String, dynamic>.from(rawOpcion);
        final textoOpcion = '${opcion['texto'] ?? ''}'.trim();
        if (textoOpcion.isNotEmpty) {
          opciones.add(
            OpcionImportada(
              texto: textoOpcion,
              correcta: opcion['correcta'] == true,
            ),
          );
        }
      }

      final correctas = opciones.where((opcion) => opcion.correcta).length;
      final textos = opciones.map((opcion) => opcion.texto.toLowerCase());
      if (opciones.length < 2 || correctas != 1) {
        advertencias.add(
          'Pregunta $numero: debe tener al menos 2 opciones y una correcta.',
        );
        continue;
      }
      if (textos.toSet().length != opciones.length) {
        advertencias.add('Pregunta $numero: tiene opciones repetidas.');
        continue;
      }

      preguntas.add(
        PreguntaImportada(
          enunciado: enunciado,
          explicacion: explicacionTexto.isEmpty ? null : explicacionTexto,
          dificultad: dificultad,
          opciones: opciones,
        ),
      );
    }

    if (preguntas.isEmpty) {
      throw const AiImportException('No hay preguntas válidas para importar.');
    }
    return AiImportParseResult(
      preguntas: preguntas,
      advertencias: advertencias,
    );
  }

  Future<int> importarATema({
    required int temaId,
    required List<PreguntaImportada> preguntas,
  }) async {
    var insertadas = 0;
    for (final pregunta in preguntas) {
      await _repo.crearPregunta(
        temaId: temaId,
        enunciado: pregunta.enunciado,
        explicacion: pregunta.explicacion,
        dificultad: pregunta.dificultad,
        opciones: [
          for (final opcion in pregunta.opciones)
            (texto: opcion.texto, correcta: opcion.correcta),
        ],
      );
      insertadas++;
    }
    return insertadas;
  }

  String _limpiarTexto(String texto) {
    var resultado = texto.trim();
    if (resultado.startsWith('```')) {
      final salto = resultado.indexOf('\n');
      if (salto >= 0) resultado = resultado.substring(salto + 1);
      if (resultado.endsWith('```')) {
        resultado = resultado.substring(0, resultado.length - 3);
      }
    }
    return resultado.trim();
  }
}
