import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/contenido_providers.dart';
import '../widgets/quiz_config_dialog.dart';
import 'quiz_screen.dart';

class TemasScreen extends ConsumerWidget {
  const TemasScreen({
    super.key,
    required this.materiaId,
    required this.materiaNombre,
  });

  final int materiaId;
  final String materiaNombre;

  Future<void> _iniciarQuiz(
    BuildContext context,
    WidgetRef ref,
    int temaId,
  ) async {
    final cantidadAsync = ref.read(cantidadPreguntasProvider(temaId));
    final maximo = cantidadAsync.hasValue ? cantidadAsync.requireValue : 50;
    final filtro = await mostrarConfiguracionQuizDialog(
      context,
      tipo: 'practica_tema',
      temaId: temaId,
      maximoDisponible: maximo,
    );

    if (filtro != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => QuizScreen(filtro: filtro)),
      );
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
                      final cantidad =
                          ref.watch(cantidadPreguntasProvider(tema.id));
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
