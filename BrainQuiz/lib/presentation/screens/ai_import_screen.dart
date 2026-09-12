import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database.dart';
import '../../logic/ai_prompt/ai_quiz_import_service.dart';
import '../providers/contenido_providers.dart';

class AiImportScreen extends ConsumerStatefulWidget {
  const AiImportScreen({super.key});

  @override
  ConsumerState<AiImportScreen> createState() => _AiImportScreenState();
}

class _AiImportScreenState extends ConsumerState<AiImportScreen> {
  final _jsonController = TextEditingController();
  int? _facultadId;
  int? _materiaId;
  int? _temaId;
  AiImportParseResult? _resultado;
  String? _mensaje;
  bool _busy = false;

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  Future<void> _cargarArchivo() async {
    final picked = await FilePicker.pickFile(
      dialogTitle: 'Cargar JSON de preguntas',
      type: FileType.custom,
      allowedExtensions: ['json', 'txt'],
    );
    if (picked == null) return;
    _jsonController.text = String.fromCharCodes(await picked.readAsBytes());
    setState(() {
      _resultado = null;
      _mensaje = null;
    });
  }

  void _analizar() {
    try {
      final resultado = ref.read(aiQuizImportServiceProvider).parsear(
        _jsonController.text,
      );
      setState(() {
        _resultado = resultado;
        _mensaje = null;
      });
    } on AiImportException catch (error) {
      setState(() {
        _resultado = null;
        _mensaje = error.message;
      });
    }
  }

  Future<void> _importar() async {
    final resultado = _resultado;
    final temaId = _temaId;
    if (resultado == null || temaId == null) return;
    setState(() => _busy = true);
    try {
      final cantidad = await ref.read(aiQuizImportServiceProvider).importarATema(
        temaId: temaId,
        preguntas: resultado.preguntas,
      );
      if (!mounted) return;
      setState(() {
        _mensaje = 'Se importaron $cantidad preguntas correctamente.';
        _resultado = null;
        _jsonController.clear();
      });
    } on Exception catch (error) {
      if (mounted) setState(() => _mensaje = 'No se pudo importar: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final facultades = ref.watch(facultadesProvider);
    final materias = _facultadId == null
        ? const AsyncValue<List<Materia>>.data([])
        : ref.watch(materiasProvider(_facultadId!));
    final temas = _materiaId == null
        ? const AsyncValue<List<Tema>>.data([])
        : ref.watch(temasProvider(_materiaId!));

    return Scaffold(
      appBar: AppBar(title: const Text('Importar preguntas de IA')),
      body: facultades.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (facultadRows) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Selecciona el tema donde se agregarán las preguntas.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _facultadId,
              decoration: const InputDecoration(labelText: 'Facultad'),
              items: [
                for (final item in facultadRows)
                  DropdownMenuItem(value: item.id, child: Text(item.nombre)),
              ],
              onChanged: (value) => setState(() {
                _facultadId = value;
                _materiaId = null;
                _temaId = null;
              }),
            ),
            if (_facultadId != null)
              materias.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('Error: $error'),
                data: (rows) => DropdownButtonFormField<int>(
                  initialValue: _materiaId,
                  decoration: const InputDecoration(labelText: 'Materia'),
                  items: [
                    for (final item in rows)
                      DropdownMenuItem(value: item.id, child: Text(item.nombre)),
                  ],
                  onChanged: (value) => setState(() {
                    _materiaId = value;
                    _temaId = null;
                  }),
                ),
              ),
            if (_materiaId != null)
              temas.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('Error: $error'),
                data: (rows) => DropdownButtonFormField<int>(
                  initialValue: _temaId,
                  decoration: const InputDecoration(labelText: 'Tema'),
                  items: [
                    for (final item in rows)
                      DropdownMenuItem(value: item.id, child: Text(item.nombre)),
                  ],
                  onChanged: (value) => setState(() => _temaId = value),
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _jsonController,
              minLines: 10,
              maxLines: 18,
              decoration: const InputDecoration(
                labelText: 'JSON generado por la IA',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _busy ? null : _cargarArchivo,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Cargar archivo'),
                ),
                FilledButton.icon(
                  onPressed: _busy ? null : _analizar,
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text('Validar JSON'),
                ),
              ],
            ),
            if (_mensaje != null) ...[
              const SizedBox(height: 12),
              Text(_mensaje!, style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              )),
            ],
            if (_resultado != null) ...[
              const SizedBox(height: 16),
              Text(
                'Vista previa: ${_resultado!.preguntas.length} preguntas válidas',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              for (final advertencia in _resultado!.advertencias)
                Text('Aviso: $advertencia'),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _busy || _temaId == null ? null : _importar,
                icon: const Icon(Icons.save_alt),
                label: const Text('Importar al tema'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
