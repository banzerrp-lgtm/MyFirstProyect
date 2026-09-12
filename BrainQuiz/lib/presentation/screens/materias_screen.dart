import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/contenido_providers.dart';
import '../widgets/nombre_dialog.dart';
import '../widgets/quiz_config_dialog.dart';
import 'quiz_screen.dart';
import 'temas_screen.dart';

class MateriasScreen extends ConsumerWidget {
  const MateriasScreen({
    super.key,
    required this.facultadId,
    required this.facultadNombre,
  });

  final int facultadId;
  final String facultadNombre;

  Future<void> _practicarMateria(
    BuildContext context,
    WidgetRef ref,
    int materiaId,
    String materiaNombre,
  ) async {
    final cantidadAsync =
        ref.read(cantidadPreguntasMateriaProvider(materiaId));
    final maximo = cantidadAsync.hasValue ? cantidadAsync.requireValue : 50;

    if (maximo == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta materia todavía no tiene preguntas.'),
        ),
      );
      return;
    }

    final filtro = await mostrarConfiguracionQuizDialog(
      context,
      tipo: 'practica_materia',
      materiaId: materiaId,
      maximoDisponible: maximo,
      tituloDialogo: 'Practicar $materiaNombre',
    );

    if (filtro != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => QuizScreen(filtro: filtro)),
      );
    }
  }

  Future<void> _crearMateria(BuildContext context, WidgetRef ref) async {
    final nombre = await mostrarDialogoNombre(
      context,
      titulo: 'Nueva materia',
      labelCampo: 'Nombre de la materia',
    );
    if (nombre == null || !context.mounted) return;
    try {
      await ref
          .read(contenidoRepositoryProvider)
          .crearMateria(facultadId: facultadId, nombre: nombre);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo crear la materia: $error')),
        );
      }
    }
  }

  Future<void> _editarMateria(
    BuildContext context,
    WidgetRef ref,
    int id,
    String nombreActual,
  ) async {
    final nombre = await mostrarDialogoNombre(
      context,
      titulo: 'Editar materia',
      inicial: nombreActual,
      labelCampo: 'Nombre de la materia',
    );
    if (nombre == null || !context.mounted) return;
    try {
      await ref.read(contenidoRepositoryProvider).actualizarMateria(id, nombre);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo editar la materia: $error')),
        );
      }
    }
  }

  Future<void> _eliminarMateria(
    BuildContext context,
    WidgetRef ref,
    int id,
    String nombre,
  ) async {
    final ok = await confirmarEliminacion(
      context,
      mensaje: '¿Eliminar "$nombre" y todos sus temas y preguntas?',
    );
    if (!ok || !context.mounted) return;
    try {
      await ref.read(contenidoRepositoryProvider).eliminarMateria(id);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo eliminar la materia: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materias = ref.watch(materiasProvider(facultadId));

    return Scaffold(
      appBar: AppBar(title: Text(facultadNombre)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _crearMateria(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Materia'),
      ),
      body: materias.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(
              child: Text('No hay materias en esta facultad.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final materia = lista[i];
              return Card(
                key: ValueKey('materia-${materia.id}'),
                child: ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(materia.nombre),
                  subtitle: Consumer(
                    key: ValueKey('cantidad-materia-${materia.id}'),
                    builder: (context, ref, _) {
                      final cantidad = ref.watch(
                        cantidadPreguntasMateriaProvider(materia.id),
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
                        tooltip: 'Practicar toda la materia',
                        icon: const Icon(Icons.play_circle_outline),
                        onPressed: () => _practicarMateria(
                          context,
                          ref,
                          materia.id,
                          materia.nombre,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Editar nombre',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _editarMateria(
                          context,
                          ref,
                          materia.id,
                          materia.nombre,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Eliminar materia',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _eliminarMateria(
                          context,
                          ref,
                          materia.id,
                          materia.nombre,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TemasScreen(
                          materiaId: materia.id,
                          materiaNombre: materia.nombre,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
