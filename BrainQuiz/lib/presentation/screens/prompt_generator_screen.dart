import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database.dart';
import '../../logic/ai_prompt/prompt_generator_service.dart';
import '../../logic/quiz_engine/quiz_models.dart';
import '../providers/contenido_providers.dart';
import 'ai_import_screen.dart';

class PromptGeneratorScreen extends ConsumerStatefulWidget {
  const PromptGeneratorScreen({super.key});

  @override
  ConsumerState<PromptGeneratorScreen> createState() =>
      _PromptGeneratorScreenState();
}

class _PromptGeneratorScreenState extends ConsumerState<PromptGeneratorScreen> {
  int? _facultadId;
  int? _materiaId;
  int? _temaId;
  final _objetivoController = TextEditingController(
    text: 'Genera preguntas nuevas de repaso para admisión odontológica.',
  );
  final _cantidadController = TextEditingController(text: '10');
  String _dificultad = 'mixta';
  String _prompt = '';

  final _service = PromptGeneratorService();

  @override
  void dispose() {
    _objetivoController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _copiarPrompt() async {
    if (_prompt.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _prompt));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Prompt copiado al portapapeles.')),
    );
  }

  List<Facultade> _leerFacultades() {
    final value = ref.read(facultadesProvider);
    return value.when(
      data: (data) => data,
      loading: () => const <Facultade>[],
      error: (_, _) => const <Facultade>[],
    );
  }

  List<Materia> _leerMaterias(int facultadId) {
    final value = ref.read(materiasProvider(facultadId));
    return value.when(
      data: (data) => data,
      loading: () => const <Materia>[],
      error: (_, _) => const <Materia>[],
    );
  }

  List<Tema> _leerTemas(int materiaId) {
    final value = ref.read(temasProvider(materiaId));
    return value.when(
      data: (data) => data,
      loading: () => const <Tema>[],
      error: (_, _) => const <Tema>[],
    );
  }

  List<PreguntaConOpciones> _leerPreguntas(int temaId) {
    final value = ref.read(preguntasProvider(temaId));
    return value.when(
      data: (data) => data,
      loading: () => const <PreguntaConOpciones>[],
      error: (_, _) => const <PreguntaConOpciones>[],
    );
  }

  void _generarPrompt() {
    var facultadNombre = 'Facultad no seleccionada';
    for (final facultad in _leerFacultades()) {
      if (facultad.id == _facultadId) {
        facultadNombre = facultad.nombre;
        break;
      }
    }

    var materiaNombre = 'Materia no seleccionada';
    if (_facultadId != null) {
      for (final materia in _leerMaterias(_facultadId!)) {
        if (materia.id == _materiaId) {
          materiaNombre = materia.nombre;
          break;
        }
      }
    }

    var temaNombre = 'Tema no seleccionado';
    if (_materiaId != null) {
      for (final tema in _leerTemas(_materiaId!)) {
        if (tema.id == _temaId) {
          temaNombre = tema.nombre;
          break;
        }
      }
    }

    final ejemplos = _temaId == null
        ? const <PreguntaConOpciones>[]
        : _leerPreguntas(_temaId!);

    final cantidad = int.tryParse(_cantidadController.text) ?? 10;
    final prompt = _service.buildPrompt(
      PromptGenerationRequest(
        facultadNombre: facultadNombre,
        materiaNombre: materiaNombre,
        temaNombre: temaNombre,
        objetivo: _objetivoController.text.trim().isEmpty
            ? 'Genera preguntas nuevas de repaso para admisión odontológica.'
            : _objetivoController.text.trim(),
        cantidad: cantidad.clamp(1, 50),
        dificultad: _dificultad,
        ejemplos: ejemplos,
      ),
    );

    setState(() => _prompt = prompt);
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
      appBar: AppBar(title: const Text('Generador de prompts IA')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            initialValue: _facultadId,
            decoration: const InputDecoration(labelText: 'Facultad'),
            items: facultades.when(
              loading: () => const <DropdownMenuItem<int>>[],
              error: (_, _) => const <DropdownMenuItem<int>>[],
              data: (lista) => [
                for (final facultad in lista)
                  DropdownMenuItem(
                    value: facultad.id,
                    child: Text(facultad.nombre),
                  ),
              ],
            ),
            onChanged: (value) => setState(() {
              _facultadId = value;
              _materiaId = null;
              _temaId = null;
            }),
          ),
          const SizedBox(height: 12),
          if (_facultadId != null)
            materias.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Error: $error'),
              data: (lista) => DropdownButtonFormField<int>(
                initialValue: _materiaId,
                decoration: const InputDecoration(labelText: 'Materia'),
                items: [
                  for (final materia in lista)
                    DropdownMenuItem(
                      value: materia.id,
                      child: Text(materia.nombre),
                    ),
                ],
                onChanged: (value) => setState(() {
                  _materiaId = value;
                  _temaId = null;
                }),
              ),
            ),
          const SizedBox(height: 12),
          if (_materiaId != null)
            temas.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Error: $error'),
              data: (lista) => DropdownButtonFormField<int>(
                initialValue: _temaId,
                decoration: const InputDecoration(labelText: 'Tema'),
                items: [
                  for (final tema in lista)
                    DropdownMenuItem(value: tema.id, child: Text(tema.nombre)),
                ],
                onChanged: (value) => setState(() => _temaId = value),
              ),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _objetivoController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Objetivo del prompt',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _dificultad,
                  decoration: const InputDecoration(
                    labelText: 'Dificultad',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'mixta', child: Text('Mixta')),
                    DropdownMenuItem(value: 'facil', child: Text('Fácil')),
                    DropdownMenuItem(value: 'media', child: Text('Media')),
                    DropdownMenuItem(value: 'dificil', child: Text('Difícil')),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _dificultad = value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _generarPrompt,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generar prompt'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _prompt.isEmpty ? null : _copiarPrompt,
            icon: const Icon(Icons.copy_all_outlined),
            label: const Text('Copiar prompt'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AiImportScreen()),
            ),
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Importar preguntas de IA'),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              _prompt.isEmpty
                  ? 'Selecciona un tema y genera un prompt para copiarlo en otra IA.'
                  : _prompt,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
