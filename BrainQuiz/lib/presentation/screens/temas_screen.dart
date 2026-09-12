import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/contenido_providers.dart';
import '../widgets/nombre_dialog.dart';
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
    if (maximo == 0) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este tema todavía no tiene preguntas.'),
          ),
        );
      }
      return;
    }
    final filtro = await mostrarConfiguracionQuizDialog(
      context,
      tipo: 'practica_tema',
      temaId: temaId,
      maximoDisponible: maximo,
    );

    if (filtro != null && context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => QuizScreen(filtro: filtro)));
    }
  }

  Future<void> _crearTema(BuildContext context, WidgetRef ref) async {
    final nombre = await mostrarDialogoNombre(
      context,
      titulo: 'Nuevo tema',
      labelCampo: 'Nombre del tema',
    );
    if (nombre == null || !context.mounted) return;
    try {
      await ref
          .read(contenidoRepositoryProvider)
          .crearTema(materiaId: materiaId, nombre: nombre);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo crear el tema: $error')),
        );
      }
    }
  }

  Future<void> _editarTema(
    BuildContext context,
    WidgetRef ref,
    int id,
    String nombreActual,
  ) async {
    final nombre = await mostrarDialogoNombre(
      context,
      titulo: 'Editar tema',
      inicial: nombreActual,
      labelCampo: 'Nombre del tema',
    );
    if (nombre == null || !context.mounted) return;
    try {
      await ref.read(contenidoRepositoryProvider).actualizarTema(id, nombre);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo editar el tema: $error')),
        );
      }
    }
  }

  Future<void> _eliminarTema(
    BuildContext context,
    WidgetRef ref,
    int id,
    String nombre,
  ) async {
    final ok = await confirmarEliminacion(
      context,
      mensaje: '¿Eliminar "$nombre" y todas sus preguntas?',
    );
    if (!ok || !context.mounted) return;
    try {
      await ref.read(contenidoRepositoryProvider).eliminarTema(id);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo eliminar el tema: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temas = ref.watch(temasProvider(materiaId));

    return Scaffold(
      appBar: AppBar(title: Text(materiaNombre)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _crearTema(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Tema'),
      ),
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
                key: ValueKey('tema-${tema.id}'),
                child: ListTile(
                  leading: const Icon(Icons.topic),
                  title: Text(tema.nombre),
                  subtitle: Consumer(
                    key: ValueKey('cantidad-tema-${tema.id}'),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  IconButton(
                    tooltip: 'Editar nombre',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        _editarTema(context, ref, tema.id, tema.nombre),
                  ),
                  IconButton(
                    tooltip: 'Eliminar tema',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        _eliminarTema(context, ref, tema.id, tema.nombre),
                  ),
                    ],
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
