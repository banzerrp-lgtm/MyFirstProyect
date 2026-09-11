import 'package:flutter/material.dart';

import '../../logic/quiz_engine/quiz_models.dart';

/// Resultado completo de un intento, incluyendo el repaso de cada pregunta.
class QuizResultadoScreen extends StatelessWidget {
  const QuizResultadoScreen({super.key, required this.resultado});

  final QuizResultado resultado;

  String _tiempo(int segundos) {
    final minutos = segundos ~/ 60;
    final segs = segundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final respuestas = {
      for (final respuesta in resultado.respuestas)
        respuesta.preguntaId: respuesta,
    };
    final temas = <String, List<PreguntaConOpciones>>{};
    final materias = <String, List<PreguntaConOpciones>>{};
    for (final pregunta in resultado.preguntas) {
      temas
          .putIfAbsent(
            pregunta.temaNombre ?? 'Tema ${pregunta.temaId}',
            () => [],
          )
          .add(pregunta);
      if (pregunta.materiaId != null) {
        materias
            .putIfAbsent(
              pregunta.materiaNombre ?? 'Materia ${pregunta.materiaId}',
              () => [],
            )
            .add(pregunta);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '${resultado.porcentaje.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${resultado.correctas} correctas de ${resultado.totalPreguntas}',
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _dato(
                        context,
                        Icons.check_circle,
                        'Correctas',
                        resultado.correctas,
                        Colors.green,
                      ),
                      _dato(
                        context,
                        Icons.cancel,
                        'Incorrectas',
                        resultado.incorrectas,
                        Colors.red,
                      ),
                      _dato(
                        context,
                        Icons.remove_circle,
                        'Sin responder',
                        resultado.sinResponder,
                        Colors.grey,
                      ),
                      _dato(
                        context,
                        Icons.timer,
                        'Tiempo',
                        _tiempo(resultado.tiempoUsadoSegundos),
                        null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (materias.isNotEmpty) ...[
            _titulo('Por materia'),
            ...materias.entries.map(
              (entry) => _desglose(entry.key, entry.value, respuestas),
            ),
          ],
          _titulo('Por tema'),
          ...temas.entries.map(
            (entry) => _desglose(entry.key, entry.value, respuestas),
          ),
          _titulo('Revisión pregunta por pregunta'),
          if (resultado.preguntas.isEmpty)
            const Text('No hay datos de revisión disponibles.')
          else
            ...resultado.preguntas.asMap().entries.map(
              (entry) => _revision(
                entry.key + 1,
                entry.value,
                respuestas[entry.value.id],
              ),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  Widget _titulo(String texto) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      texto,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _dato(
    BuildContext context,
    IconData icon,
    String etiqueta,
    Object valor,
    Color? color,
  ) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: 18,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(width: 4),
      Text('$etiqueta: $valor'),
    ],
  );

  Widget _desglose(
    String nombre,
    List<PreguntaConOpciones> preguntas,
    Map<int, RespuestaRegistrada> respuestas,
  ) {
    final correctas = preguntas
        .where((p) => respuestas[p.id]?.esCorrecta ?? false)
        .length;
    final porcentaje = preguntas.isEmpty
        ? 0.0
        : correctas * 100 / preguntas.length;
    return Card(
      child: ListTile(
        title: Text(nombre),
        subtitle: LinearProgressIndicator(value: porcentaje / 100),
        trailing: Text(
          '$correctas/${preguntas.length}\n${porcentaje.toStringAsFixed(0)}%',
        ),
      ),
    );
  }

  Widget _revision(
    int numero,
    PreguntaConOpciones pregunta,
    RespuestaRegistrada? respuesta,
  ) {
    final elegida = respuesta?.opcionElegidaId == null
        ? null
        : pregunta.opciones
              .where((opcion) => opcion.id == respuesta!.opcionElegidaId)
              .firstOrNull;
    final correcta = pregunta.opciones
        .where((opcion) => opcion.esCorrecta)
        .firstOrNull;
    final color = respuesta == null || respuesta.opcionElegidaId == null
        ? Colors.grey
        : respuesta.esCorrecta
        ? Colors.green
        : Colors.red;
    return Card(
      child: ExpansionTile(
        leading: Icon(
          respuesta?.esCorrecta == true ? Icons.check_circle : Icons.error,
          color: color,
        ),
        title: Text('$numero. ${pregunta.enunciado}'),
        subtitle: Text(
          elegida == null ? 'Sin responder' : 'Elegida: ${elegida.texto}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Respuesta correcta: ${correcta?.texto ?? 'No definida'}',
            ),
          ),
          if (elegida != null && !elegida.esCorrecta)
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Tu respuesta: ${elegida.texto}'),
            ),
          if (pregunta.explicacion?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Explicación: ${pregunta.explicacion}'),
            ),
          ],
        ],
      ),
    );
  }
}
