import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/quiz_engine/quiz_models.dart';
import '../providers/contenido_providers.dart';
import 'quiz_screen.dart';

class TemasScreen extends ConsumerWidget {
  const TemasScreen({
    super.key,
    required this.materiaId,
    required this.materiaNombre,
  });

  final int materiaId;
  final String materiaNombre;

  Future<QuizFiltro?> _mostrarConfiguracionQuiz(
    BuildContext context, {
    required int temaId,
    required int maximoDisponible,
  }) {
    final maximo = maximoDisponible.clamp(1, 200);
    var cantidad = maximo < 10 ? maximo : 10;
    var conTiempo = false;
    var minutos = 15;

    return showDialog<QuizFiltro>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Configurar práctica'),
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
                    onChanged: (valor) =>
                        setState(() => cantidad = valor.round()),
                  ),
                  Text('$cantidad preguntas'),
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
                      cantidadPreguntas: cantidad,
                      tiempoLimiteSegundos: conTiempo ? minutos * 60 : null,
                      tipo: 'practica_tema',
                    ),
                  ),
                  child: const Text('Empezar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _iniciarQuiz(
    BuildContext context,
    WidgetRef ref,
    int temaId,
  ) async {
    final cantidadAsync = ref.read(cantidadPreguntasProvider(temaId));
    final maximo = cantidadAsync.hasValue ? cantidadAsync.requireValue : 50;

    final filtro = await _mostrarConfiguracionQuiz(
      context,
      temaId: temaId,
      maximoDisponible: maximo,
    );

    if (filtro != null && context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => QuizScreen(filtro: filtro)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temas = ref.watch(temasProvider(materiaId));

    return Scaffold(
      appBar: AppBar(title: Text(materiaNombre)),
      body: temas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('No hay temas en esta materia.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final tema = lista[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.topic),
                  title: Text(tema.nombre),
                  subtitle: Consumer(
                    builder: (context, ref, _) {
                      final cantidad = ref.watch(
                        cantidadPreguntasProvider(tema.id),
                      );
                      return cantidad.when(
                        loading: () => const Text('...'),
                        error: (_, _) => const Text('—'),
                        data: (n) => Text('$n preguntas'),
                      );
                    },
                  ),
                  onTap: () => _iniciarQuiz(context, ref, tema.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
