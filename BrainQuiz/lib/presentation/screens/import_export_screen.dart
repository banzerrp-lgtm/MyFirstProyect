import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/import_export/content_transfer_service.dart';
import '../providers/contenido_providers.dart';
import '../../data/database/database.dart';

class ImportExportScreen extends ConsumerStatefulWidget {
  const ImportExportScreen({super.key});

  @override
  ConsumerState<ImportExportScreen> createState() => _ImportExportScreenState();
}

class _ImportExportScreenState extends ConsumerState<ImportExportScreen> {
  int? _facultadId;
  int? _materiaId;
  int? _temaId;
  String? _message;
  bool _busy = false;

  Future<void> _exportarFacultad() async {
    final id = _facultadId;
    if (id == null) return;
    await _run(
      () => ref.read(contentTransferServiceProvider).exportarFacultad(id),
    );
  }

  Future<void> _exportarBackup() async {
    await _run(
      () => ref.read(contentTransferServiceProvider).exportarBackupCompleto(),
    );
  }

  Future<void> _exportarMateria() async {
    final id = _materiaId;
    if (id == null) return;
    await _run(
      () => ref.read(contentTransferServiceProvider).exportarMateria(id),
    );
  }

  Future<void> _exportarTema() async {
    final id = _temaId;
    if (id == null) return;
    await _run(() => ref.read(contentTransferServiceProvider).exportarTema(id));
  }

  Future<void> _importar() async {
    final estrategia = await showDialog<ImportStrategy>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Qué hacer con duplicados'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImportStrategy.agregar),
            child: const ListTile(
              leading: Icon(Icons.add),
              title: Text('Agregar'),
              subtitle: Text('Agrega lo nuevo y conserva lo existente'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImportStrategy.omitir),
            child: const ListTile(
              leading: Icon(Icons.skip_next),
              title: Text('Omitir'),
              subtitle: Text('No importa una facultad que ya existe'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImportStrategy.reemplazar),
            child: const ListTile(
              leading: Icon(Icons.sync),
              title: Text('Reemplazar'),
              subtitle: Text('Sustituye la facultad del mismo nombre'),
            ),
          ),
        ],
      ),
    );
    if (estrategia == null) return;
    await _runImport(
      () => ref
          .read(contentTransferServiceProvider)
          .importarArchivo(estrategia: estrategia),
    );
  }

  Future<void> _run(Future<ExportResult?> Function() operation) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = await operation();
      if (!mounted) return;
      setState(() {
        _message = result == null
            ? 'Operación cancelada.'
            : 'Archivo: ${result.path.path}\n${_formatSummary(result.summary)}';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _message = 'Error: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runImport(Future<ImportResult?> Function() operation) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = await operation();
      if (!mounted) return;
      setState(() {
        _message = result == null
            ? 'Operación cancelada.'
            : '${_formatSummary(result.summary)}\n'
                  'Omitidos: ${result.skipped}. Reemplazados: ${result.replaced}.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _message = 'Error: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _formatSummary(TransferSummary summary) =>
      'Detectados: ${summary.facultades} facultades, '
      '${summary.materias} materias, ${summary.temas} temas, '
      '${summary.preguntas} preguntas y ${summary.opciones} opciones.';

  @override
  Widget build(BuildContext context) {
    final facultades = ref.watch(facultadesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Importar y exportar')),
      body: facultades.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (items) {
          if (_facultadId != null &&
              !items.any((facultad) => facultad.id == _facultadId)) {
            _facultadId = null;
          }
          final materiasAsync = _facultadId == null
              ? const AsyncValue<List<Materia>>.data([])
              : ref.watch(materiasProvider(_facultadId!));
          final temasAsync = _materiaId == null
              ? const AsyncValue<List<Tema>>.data([])
              : ref.watch(temasProvider(_materiaId!));
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              DropdownButtonFormField<int>(
                initialValue: _facultadId,
                decoration: const InputDecoration(
                  labelText: 'Facultad para exportar',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final facultad in items)
                    DropdownMenuItem(
                      value: facultad.id,
                      child: Text(facultad.nombre),
                    ),
                ],
                onChanged: _busy
                    ? null
                    : (value) => setState(() {
                        _facultadId = value;
                        _materiaId = null;
                        _temaId = null;
                      }),
              ),
              const SizedBox(height: 16),
              if (_facultadId != null)
                materiasAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (error, _) => Text('Error: $error'),
                  data: (materias) => DropdownButtonFormField<int>(
                    initialValue: materias.any((m) => m.id == _materiaId)
                        ? _materiaId
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Materia para exportar',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final materia in materias)
                        DropdownMenuItem(
                          value: materia.id,
                          child: Text(materia.nombre),
                        ),
                    ],
                    onChanged: _busy
                        ? null
                        : (value) => setState(() {
                            _materiaId = value;
                            _temaId = null;
                          }),
                  ),
                ),
              if (_materiaId != null) const SizedBox(height: 16),
              if (_materiaId != null)
                temasAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (error, _) => Text('Error: $error'),
                  data: (temas) => DropdownButtonFormField<int>(
                    initialValue: temas.any((t) => t.id == _temaId)
                        ? _temaId
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Tema para exportar',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final tema in temas)
                        DropdownMenuItem(
                          value: tema.id,
                          child: Text(tema.nombre),
                        ),
                    ],
                    onChanged: _busy
                        ? null
                        : (value) => setState(() => _temaId = value),
                  ),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _busy || _facultadId == null
                    ? null
                    : _exportarFacultad,
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('Exportar facultad'),
              ),
              OutlinedButton.icon(
                onPressed: _busy || _materiaId == null
                    ? null
                    : _exportarMateria,
                icon: const Icon(Icons.menu_book_outlined),
                label: const Text('Exportar materia'),
              ),
              OutlinedButton.icon(
                onPressed: _busy || _temaId == null ? null : _exportarTema,
                icon: const Icon(Icons.topic_outlined),
                label: const Text('Exportar tema'),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _exportarBackup,
                icon: const Icon(Icons.backup_outlined),
                label: const Text('Exportar backup completo'),
              ),
              const Divider(height: 32),
              FilledButton.icon(
                onPressed: _busy ? null : _importar,
                icon: const Icon(Icons.file_download_outlined),
                label: const Text('Importar archivo'),
              ),
              if (_busy)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (_message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SelectableText(_message!),
                ),
            ],
          );
        },
      ),
    );
  }
}
