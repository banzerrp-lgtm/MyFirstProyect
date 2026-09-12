import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../providers/contenido_providers.dart';
import '../widgets/app_ui_kit.dart';
import '../widgets/nombre_dialog.dart';
import '../widgets/simulacro_config_dialog.dart';
import 'ai_import_screen.dart';
import 'banco_preguntas_screen.dart';
import 'import_export_screen.dart';
import 'materias_screen.dart';
import 'progreso_screen.dart';
import 'prompt_generator_screen.dart';
import 'quiz_screen.dart';

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
    final filtro = await mostrarConfiguracionSimulacroDialog(
      context,
      facultadId: facultadId,
      facultadNombre: facultadNombre,
    );
    if (filtro != null && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => QuizScreen(filtro: filtro)),
      );
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

  void _abrirMenuHerramientas(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              _herramientaTile(
                context,
                icon: Icons.library_books_outlined,
                titulo: 'Banco de preguntas',
                subtitulo: 'Crear, editar y organizar preguntas',
                onTap: () => _navegar(context, const BancoPreguntasScreen()),
              ),
              _herramientaTile(
                context,
                icon: Icons.import_export,
                titulo: 'Importar y exportar',
                subtitulo: 'Mover contenido entre dispositivos',
                onTap: () => _navegar(context, const ImportExportScreen()),
              ),
              _herramientaTile(
                context,
                icon: Icons.smart_toy_outlined,
                titulo: 'Generador de prompts IA',
                subtitulo: 'Crea preguntas nuevas con ayuda de IA',
                onTap: () => _navegar(context, const PromptGeneratorScreen()),
              ),
              _herramientaTile(
                context,
                icon: Icons.file_download_outlined,
                titulo: 'Importar preguntas de IA',
                subtitulo: 'Carga el JSON generado por una IA externa',
                onTap: () => _navegar(context, const AiImportScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navegar(BuildContext context, Widget screen) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Widget _herramientaTile(
    BuildContext context, {
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
      ),
      title: Text(titulo, style: theme.textTheme.titleMedium),
      subtitle: Text(subtitulo),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facultades = ref.watch(facultadesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _crearFacultad(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Facultad'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BrandHeader(
              title: 'BrainQuiz',
              subtitle: 'Prepárate para tu examen de admisión, offline.',
              actions: [
                HeaderIconButton(
                  icon: Icons.insights,
                  tooltip: 'Mi progreso',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProgresoScreen()),
                  ),
                ),
                HeaderIconButton(
                  icon: Icons.tune,
                  tooltip: 'Más herramientas',
                  onPressed: () => _abrirMenuHerramientas(context),
                ),
              ],
              trailingWidget: facultades.maybeWhen(
                data: (lista) => Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    StatPill(
                      value: '${lista.length}',
                      label: lista.length == 1 ? 'facultad' : 'facultades',
                      icon: Icons.school_outlined,
                    ),
                  ],
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              96,
            ),
            sliver: facultades.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, st) => SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'No se pudo cargar el contenido',
                  description: '$err',
                ),
              ),
              data: (lista) {
                if (lista.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyState(
                      icon: Icons.school_outlined,
                      title: 'Aún no tienes facultades',
                      description:
                          'Crea tu primera facultad para empezar a agregar materias y preguntas.',
                      action: FilledButton.icon(
                        onPressed: () => _crearFacultad(context, ref),
                        icon: const Icon(Icons.add),
                        label: const Text('Crear facultad'),
                      ),
                    ),
                  );
                }
                return SliverList.separated(
                  itemCount: lista.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final facultad = lista[i];
                    return _FacultadCard(
                      key: ValueKey('facultad-${facultad.id}'),
                      nombre: facultad.nombre,
                      cantidadAsync: ref.watch(
                        cantidadPreguntasFacultadProvider(facultad.id),
                      ),
                      onSimulacro: () => _iniciarSimulacro(
                        context,
                        ref,
                        facultad.id,
                        facultad.nombre,
                      ),
                      onEditar: () => _editarFacultad(
                        context,
                        ref,
                        facultad.id,
                        facultad.nombre,
                      ),
                      onEliminar: () => _eliminarFacultad(
                        context,
                        ref,
                        facultad.id,
                        facultad.nombre,
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MateriasScreen(
                            facultadId: facultad.id,
                            facultadNombre: facultad.nombre,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.surface,
    );
  }
}

class _FacultadCard extends StatelessWidget {
  const _FacultadCard({
    super.key,
    required this.nombre,
    required this.cantidadAsync,
    required this.onSimulacro,
    required this.onEditar,
    required this.onEliminar,
    required this.onTap,
  });

  final String nombre;
  final AsyncValue<int> cantidadAsync;
  final VoidCallback onSimulacro;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.school,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    cantidadAsync.when(
                      loading: () => Text(
                        'Cargando…',
                        style: theme.textTheme.bodySmall,
                      ),
                      error: (_, _) => Text(
                        '—',
                        style: theme.textTheme.bodySmall,
                      ),
                      data: (n) => Text(
                        '$n preguntas disponibles',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) => switch (value) {
                  'editar' => onEditar(),
                  'eliminar' => onEliminar(),
                  _ => null,
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'editar',
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Editar nombre'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'eliminar',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline),
                      title: Text('Eliminar'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.xs),
              FilledButton.tonalIcon(
                onPressed: onSimulacro,
                icon: const Icon(Icons.timer_outlined, size: 18),
                label: const Text('Simular'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
