import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/contenido_providers.dart';

class TemasScreen extends ConsumerWidget {
  const TemasScreen({
    super.key,
    required this.materiaId,
    required this.materiaNombre,
  });

  final int materiaId;
  final String materiaNombre;

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
                  // Fase 2 conectará esto al motor de quiz.
                  onTap: null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
