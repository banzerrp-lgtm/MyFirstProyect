import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/contenido_providers.dart';
import '../widgets/nombre_dialog.dart';
import '../widgets/quiz_config_dialog.dart';
import 'materias_screen.dart';
import 'quiz_screen.dart';
import 'progreso_screen.dart';
import 'banco_preguntas_screen.dart';
import 'import_export_screen.dart';
import 'prompt_generator_screen.dart';
import 'ai_import_screen.dart';

class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  Future<void> _iniciarSimulacro(
    BuildContext context,
    WidgetRef ref,
    int facultadId,
    String facultadNombre,
  ) async {
    final cantidadAsync = ref.read(
      cantidadPreguntasFacultadProvider(facultadId),
    );
    final maximo = cantidadAsync.hasValue ? cantidadAsync.requireValue : 50;

    if (maximo == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todavía no hay preguntas cargadas para simular.'),
        ),
      );
      return;
    }

    final filtro = await mostrarConfiguracionQuizDialog(
      context,
      tipo: 'simulacro',
      facultadId: facultadId,
      maximoDisponible: maximo,
      tituloDialogo: 'Simulacro: $facultadNombre',
    );

    if (filtro != null && context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => QuizScreen(filtro: filtro)));
    }
  }

  Future<void> _crearFacultad(BuildContext context, WidgetRef ref) async {
    final nombre = await mostrarDialogoNombre(
      context,
      titulo: 'Nueva facultad',
      labelCampo: 'Nombre de la facultad',
    );
    if (nombre == null || !context.mounted) return;
    try {
      await ref.read(contenidoRepositoryProvider).crearFacultad(nombre: nombre);
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo crear la facultad: $error')),
        );
      }
    }
  }

  Future<void> _editarFacultad(
      BuildContext context,
      WidgetRef ref,
      int id,
      String nombreActual,
    ) async {
      final nombre = await mostrarDialogoNombre(
        context,
        titulo: 'Editar facultad',
        inicial: nombreActual,
        labelCampo: 'Nombre de la facultad',
      );
      if (nombre == null || !context.mounted) return;
      try {
        await ref.read(contenidoRepositoryProvider).actualizarFacultad(id, nombre);
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo editar la facultad: $error')),
          );
        }
      }
    }

  Future<void> _eliminarFacultad(
      BuildContext context,
      WidgetRef ref,
      int id,
      String nombre,
    ) async {
      final ok = await confirmarEliminacion(
        context,
        mensaje:
            '¿Eliminar "$nombre" y todo su contenido?\nSe perderán sus materias, temas y preguntas.',
      );
      if (!ok || !context.mounted) return;
      try {
        await ref.read(contenidoRepositoryProvider).eliminarFacultad(id);
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo eliminar la facultad: $error')),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facultades = ref.watch(facultadesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BrainQuiz'),
        actions: [
          IconButton(
            tooltip: 'Mi progreso',
            icon: const Icon(Icons.insights),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProgresoScreen())),
          ),
          IconButton(
            tooltip: 'Administrar banco de preguntas',
            icon: const Icon(Icons.library_books_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BancoPreguntasScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Importar y exportar contenido',
            icon: const Icon(Icons.import_export),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ImportExportScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Generador de prompts para IA',
            icon: const Icon(Icons.smart_toy_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PromptGeneratorScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Importar preguntas de IA',
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AiImportScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _crearFacultad(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Facultad'),
      ),
      body: facultades.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('No hay facultades cargadas.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final facultad = lista[i];
              return Card(
                key: ValueKey('facultad-${facultad.id}'),
                child: ListTile(
                  leading: const Icon(Icons.school),
                  title: Text(facultad.nombre),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Simulacro general',
                        icon: const Icon(Icons.timer_outlined),
                        onPressed: () => _iniciarSimulacro(
                          context,
                          ref,
                          facultad.id,
                          facultad.nombre,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Editar nombre',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _editarFacultad(
                          context,
                          ref,
                          facultad.id,
                          facultad.nombre,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Eliminar facultad',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _eliminarFacultad(
                          context,
                          ref,
                          facultad.id,
                          facultad.nombre,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MateriasScreen(
                          facultadId: facultad.id,
                          facultadNombre: facultad.nombre,
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
