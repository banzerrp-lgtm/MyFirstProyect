import '../../logic/quiz_engine/quiz_models.dart';

class PromptGenerationRequest {
  const PromptGenerationRequest({
    required this.facultadNombre,
    required this.materiaNombre,
    required this.temaNombre,
    required this.objetivo,
    required this.cantidad,
    required this.dificultad,
    required this.ejemplos,
  });

  final String facultadNombre;
  final String materiaNombre;
  final String temaNombre;
  final String objetivo;
  final int cantidad;
  final String dificultad;
  final List<PreguntaConOpciones> ejemplos;
}

class PromptGeneratorService {
  String buildPrompt(PromptGenerationRequest request) {
    final contexto = <String>[
      'Actúa como experto(a) en preparación para admisión de Odontología.',
      'Contexto académico:',
      '- Facultad: ${request.facultadNombre}',
      '- Materia: ${request.materiaNombre}',
      '- Tema: ${request.temaNombre}',
      '',
      'Objetivo principal:',
      request.objetivo,
      '',
      'Instrucciones obligatorias:',
      '- Genera exactamente ${request.cantidad} preguntas nuevas.',
      '- Prioriza nivel de dificultad: ${request.dificultad}.',
      '- Cada pregunta debe ser clara, técnica y alineada con admisión odontológica.',
      '- Usa formato de examen con 4 opciones, una sola correcta.',
      '- Incluye solo el enunciado, opciones y respuesta correcta.',
      '- Si existe una explicación útil, añádela al final.',
      '- Evita repetir el mismo enunciado o patrones idénticos.',
      '',
      'Formato de salida esperado:',
      '1) Enunciado',
      'A) ...',
      'B) ...',
      'C) ...',
      'D) ...',
      'Respuesta correcta: B',
      'Explicación: ...',
      '',
      'Reglas especiales:',
      '- Mantén un nivel académico de pregrado y enfoque para admisión.',
      '- Si se trata de un tema clínico, prioriza precisión y terminología correcta.',
      '- No des respuestas en blanco ni menciones de “como AI”.',
    ];

    final ejemplos = request.ejemplos;
    if (ejemplos.isNotEmpty) {
      contexto.add('');
      contexto.add(
        'Referencia de estilo (solo como ejemplo, no repitas estos textos):',
      );
      for (var i = 0; i < ejemplos.length && i < 3; i++) {
        final pregunta = ejemplos[i];
        contexto.add('Ejemplo ${i + 1}: ${pregunta.enunciado}');
        for (var j = 0; j < pregunta.opciones.length; j++) {
          final opcion = pregunta.opciones[j];
          final letra = String.fromCharCode(65 + j);
          contexto.add(
            '$letra) ${opcion.texto}${opcion.esCorrecta ? ' ✅' : ''}',
          );
        }
      }
    }

    return contexto.join('\n');
  }
}
