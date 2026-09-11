import 'package:flutter/material.dart';

import '../../logic/quiz_engine/quiz_models.dart';

/// Diálogo de configuración reutilizable para los modos de quiz disponibles.
Future<QuizFiltro?> mostrarConfiguracionQuizDialog(
  BuildContext context, {
  required String tipo,
  required int maximoDisponible,
  int? temaId,
  int? materiaId,
  int? facultadId,
  String tituloDialogo = 'Configurar quiz',
}) {
  final maximo = maximoDisponible.clamp(1, 200);
  var cantidad = maximo < 10 ? maximo : 10;
  var conTiempo = false;
  var minutos = 15;
  final dificultades = <String>{};

  return showDialog<QuizFiltro>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(tituloDialogo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cantidad de preguntas (máx. $maximo):'),
            Slider(
              value: cantidad.toDouble(),
              min: 1,
              max: maximo.toDouble(),
              divisions: maximo > 1 ? maximo - 1 : null,
              label: '$cantidad',
              onChanged: (valor) => setState(() => cantidad = valor.round()),
            ),
            Text('$cantidad preguntas'),
            const SizedBox(height: 12),
            const Text('Dificultad (todas si no seleccionas ninguna):'),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: [
                for (final dificultad in const [
                  ('facil', 'Fácil'),
                  ('media', 'Media'),
                  ('dificil', 'Difícil'),
                ])
                  FilterChip(
                    label: Text(dificultad.$2),
                    selected: dificultades.contains(dificultad.$1),
                    onSelected: (seleccionada) => setState(() {
                      if (seleccionada) {
                        dificultades.add(dificultad.$1);
                      } else {
                        dificultades.remove(dificultad.$1);
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Con límite de tiempo'),
              value: conTiempo,
              onChanged: (valor) => setState(() => conTiempo = valor),
            ),
            if (conTiempo)
              Row(
                children: [
                  const Text('Minutos:'),
                  Expanded(
                    child: Slider(
                      value: minutos.toDouble(),
                      min: 1,
                      max: 60,
                      divisions: 59,
                      label: '$minutos',
                      onChanged: (valor) =>
                          setState(() => minutos = valor.round()),
                    ),
                  ),
                  Text('$minutos'),
                ],
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(
              QuizFiltro(
                temaId: temaId,
                materiaId: materiaId,
                facultadId: facultadId,
                dificultades: dificultades,
                cantidadPreguntas: cantidad,
                tiempoLimiteSegundos: conTiempo ? minutos * 60 : null,
                tipo: tipo,
              ),
            ),
            child: const Text('Empezar'),
          ),
        ],
      ),
    ),
  );
}
