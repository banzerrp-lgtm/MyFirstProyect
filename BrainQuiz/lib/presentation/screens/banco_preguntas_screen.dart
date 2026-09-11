import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database.dart';
import '../../data/repositories/contenido_repository.dart';
import '../../logic/quiz_engine/quiz_models.dart';
import '../providers/contenido_providers.dart';

class BancoPreguntasScreen extends ConsumerStatefulWidget {
  const BancoPreguntasScreen({super.key});

  @override
  ConsumerState<BancoPreguntasScreen> createState() =>
      _BancoPreguntasScreenState();
}

class _BancoPreguntasScreenState extends ConsumerState<BancoPreguntasScreen> {
  int? _facultadId;
  int? _materiaId;
  int? _temaId;

  ContenidoRepository get _repo => ref.read(contenidoRepositoryProvider);

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
      appBar: AppBar(title: const Text('Banco de preguntas')),
      floatingActionButton: _temaId == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _editarPregunta(context),
              icon: const Icon(Icons.add),
              label: const Text('Nueva pregunta'),
            ),
      body: facultades.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (facultadRows) => materias.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (materiaRows) => temas.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (temaRows) => _contenido(facultadRows, materiaRows, temaRows),
          ),
        ),
      ),
    );
  }

  Widget _contenido(
    List<Facultade> facultades,
    List<Materia> materias,
    List<Tema> temas,
  ) {
    final facultadId = facultades.any((f) => f.id == _facultadId)
        ? _facultadId
        : null;
    final materiaId = materias.any((m) => m.id == _materiaId)
        ? _materiaId
        : null;
    final temaId = temas.any((t) => t.id == _temaId) ? _temaId : null;
    if (facultadId != _facultadId ||
        materiaId != _materiaId ||
        temaId != _temaId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _facultadId = facultadId;
            _materiaId = materiaId;
            _temaId = temaId;
          });
        }
      });
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              SizedBox(
                width: 260,
                child: DropdownButtonFormField<int>(
                  initialValue: facultadId,
                  decoration: const InputDecoration(labelText: 'Facultad'),
                  items: facultades
                      .map(
                        (f) => DropdownMenuItem(
                          value: f.id,
                          child: Text(f.nombre),
                        ),
                      )
                      .toList(),
                  onChanged: (id) => setState(() {
                    _facultadId = id;
                    _materiaId = null;
                    _temaId = null;
                  }),
                ),
              ),
              if (facultadId != null)
                SizedBox(
                  width: 260,
                  child: DropdownButtonFormField<int>(
                    initialValue: materiaId,
                    decoration: InputDecoration(
                      labelText: 'Materia',
                      suffixIcon: IconButton(
                        tooltip: 'Administrar materias',
                        icon: const Icon(Icons.edit_note),
                        onPressed: () => _administrarMaterias(materias),
                      ),
                    ),
                    items: materias
                        .map(
                          (m) => DropdownMenuItem(
                            value: m.id,
                            child: Text(m.nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (id) => setState(() {
                      _materiaId = id;
                      _temaId = null;
                    }),
                  ),
                ),
              if (materiaId != null)
                SizedBox(
                  width: 260,
                  child: DropdownButtonFormField<int>(
                    initialValue: temaId,
                    decoration: InputDecoration(
                      labelText: 'Tema',
                      suffixIcon: IconButton(
                        tooltip: 'Administrar temas',
                        icon: const Icon(Icons.edit_note),
                        onPressed: () => _administrarTemas(temas),
                      ),
                    ),
                    items: temas
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.id,
                            child: Text(t.nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (id) => setState(() => _temaId = id),
                  ),
                ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: temaId == null
              ? const Center(child: Text('Selecciona una materia y un tema.'))
              : ref
                    .watch(preguntasProvider(temaId))
                    .when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (preguntas) => preguntas.isEmpty
                          ? const Center(
                              child: Text('No hay preguntas en este tema.'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                              itemCount: preguntas.length,
                              itemBuilder: (_, i) =>
                                  _tarjetaPregunta(preguntas[i]),
                            ),
                    ),
        ),
      ],
    );
  }

  Widget _tarjetaPregunta(PreguntaConOpciones pregunta) {
    return Card(
      child: ListTile(
        title: Text(pregunta.enunciado),
        subtitle: Text(
          '${_nombreDificultad(pregunta.dificultad)} · ${pregunta.opciones.length} opciones\n'
          '${pregunta.opciones.where((o) => o.esCorrecta).map((o) => o.texto).join(', ')}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        trailing: Wrap(
          children: [
            IconButton(
              tooltip: 'Editar',
              icon: const Icon(Icons.edit),
              onPressed: () => _editarPregunta(context, pregunta),
            ),
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _eliminarPregunta(pregunta),
            ),
          ],
        ),
      ),
    );
  }

  String _nombreDificultad(String value) => switch (value) {
    'facil' => 'Fácil',
    'dificil' => 'Difícil',
    _ => 'Media',
  };

  Future<void> _administrarMaterias(List<Materia> materias) async {
    if (_facultadId == null) return;
    await showDialog<void>(
      context: context,
      builder: (_) => _NombreListaDialog(
        titulo: 'Materias',
        elementos: materias.map((m) => (m.id, m.nombre)).toList(),
        onCrear: (nombre) =>
            _repo.crearMateria(facultadId: _facultadId!, nombre: nombre),
        onEditar: _repo.actualizarMateria,
        onEliminar: (id) => _confirmarEliminacion(
          '¿Eliminar la materia y todos sus temas y preguntas?',
          () => _repo.eliminarMateria(id),
        ),
      ),
    );
  }

  Future<void> _administrarTemas(List<Tema> temas) async {
    if (_materiaId == null) return;
    await showDialog<void>(
      context: context,
      builder: (_) => _NombreListaDialog(
        titulo: 'Temas',
        elementos: temas.map((t) => (t.id, t.nombre)).toList(),
        onCrear: (nombre) =>
            _repo.crearTema(materiaId: _materiaId!, nombre: nombre),
        onEditar: _repo.actualizarTema,
        onEliminar: (id) => _confirmarEliminacion(
          '¿Eliminar el tema y todas sus preguntas?',
          () => _repo.eliminarTema(id),
        ),
      ),
    );
  }

  Future<void> _confirmarEliminacion(
    String mensaje,
    Future<void> Function() action,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) await action();
  }

  Future<void> _eliminarPregunta(PreguntaConOpciones pregunta) async {
    await _confirmarEliminacion(
      '¿Eliminar esta pregunta y sus opciones?',
      () => _repo.eliminarPregunta(pregunta.id),
    );
  }

  Future<void> _editarPregunta(
    BuildContext context, [
    PreguntaConOpciones? pregunta,
  ]) async {
    if (_temaId == null && pregunta == null) return;
    await showDialog<void>(
      context: context,
      builder: (_) => _PreguntaDialog(
        pregunta: pregunta,
        onGuardar: (enunciado, explicacion, dificultad, opciones) {
          final temaId = pregunta?.temaId ?? _temaId!;
          if (pregunta == null) {
            return _repo.crearPregunta(
              temaId: temaId,
              enunciado: enunciado,
              explicacion: explicacion,
              dificultad: dificultad,
              opciones: opciones,
            );
          }
          return _repo.actualizarPregunta(
            id: pregunta.id,
            temaId: temaId,
            enunciado: enunciado,
            explicacion: explicacion,
            dificultad: dificultad,
            opciones: opciones,
          );
        },
      ),
    );
  }
}

class _NombreListaDialog extends StatefulWidget {
  const _NombreListaDialog({
    required this.titulo,
    required this.elementos,
    required this.onCrear,
    required this.onEditar,
    required this.onEliminar,
  });
  final String titulo;
  final List<(int, String)> elementos;
  final Future<void> Function(String) onCrear;
  final Future<void> Function(int, String) onEditar;
  final Future<void> Function(int) onEliminar;

  @override
  State<_NombreListaDialog> createState() => _NombreListaDialogState();
}

class _NombreListaDialogState extends State<_NombreListaDialog> {
  Future<void> _nombre({int? id, String inicial = ''}) async {
    final controller = TextEditingController(text: inicial);
    final formKey = GlobalKey<FormState>();
    final nombre = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          id == null
              ? 'Nuevo ${widget.titulo.substring(0, widget.titulo.length - 1)}'
              : 'Editar',
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nombre'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Escribe un nombre' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (nombre != null) {
      if (id == null) {
        await widget.onCrear(nombre);
      } else {
        await widget.onEditar(id, nombre);
      }
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.titulo),
    content: SizedBox(
      width: 400,
      child: widget.elementos.isEmpty
          ? const Text('No hay elementos todavía.')
          : ListView(
              shrinkWrap: true,
              children: widget.elementos
                  .map(
                    (e) => ListTile(
                      title: Text(e.$2),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _nombre(id: e.$1, inicial: e.$2),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await widget.onEliminar(e.$1);
                              if (mounted) setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cerrar'),
      ),
      FilledButton.icon(
        onPressed: _nombre,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
    ],
  );
}

class _PreguntaDialog extends StatefulWidget {
  const _PreguntaDialog({this.pregunta, required this.onGuardar});
  final PreguntaConOpciones? pregunta;
  final Future<dynamic> Function(
    String enunciado,
    String? explicacion,
    String dificultad,
    List<({String texto, bool correcta})> opciones,
  )
  onGuardar;

  @override
  State<_PreguntaDialog> createState() => _PreguntaDialogState();
}

class _PreguntaDialogState extends State<_PreguntaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _enunciado;
  late final TextEditingController _explicacion;
  late String _dificultad;
  late List<({TextEditingController controller, bool correcta})> _opciones;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final p = widget.pregunta;
    _enunciado = TextEditingController(text: p?.enunciado);
    _explicacion = TextEditingController(text: p?.explicacion);
    _dificultad = p?.dificultad ?? 'media';
    _opciones = (p?.opciones ?? [])
        .map(
          (o) => (
            controller: TextEditingController(text: o.texto),
            correcta: o.esCorrecta,
          ),
        )
        .toList();
    if (_opciones.isEmpty) {
      _opciones = List.generate(
        4,
        (_) => (controller: TextEditingController(), correcta: false),
      );
    }
  }

  @override
  void dispose() {
    _enunciado.dispose();
    _explicacion.dispose();
    for (final o in _opciones) {
      o.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final opciones = _opciones
        .map((o) => (texto: o.controller.text.trim(), correcta: o.correcta))
        .toList();
    if (opciones.where((o) => o.correcta).length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona exactamente una respuesta correcta.'),
        ),
      );
      return;
    }
    setState(() => _guardando = true);
    await widget.onGuardar(
      _enunciado.text.trim(),
      _explicacion.text.trim().isEmpty ? null : _explicacion.text.trim(),
      _dificultad,
      opciones,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.pregunta == null ? 'Nueva pregunta' : 'Editar pregunta'),
    content: SizedBox(
      width: 600,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _enunciado,
                decoration: const InputDecoration(labelText: 'Enunciado'),
                minLines: 2,
                maxLines: 4,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Escribe el enunciado'
                    : null,
              ),
              TextFormField(
                controller: _explicacion,
                decoration: const InputDecoration(
                  labelText: 'Explicación (opcional)',
                ),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                initialValue: _dificultad,
                decoration: const InputDecoration(labelText: 'Dificultad'),
                items: const [
                  DropdownMenuItem(value: 'facil', child: Text('Fácil')),
                  DropdownMenuItem(value: 'media', child: Text('Media')),
                  DropdownMenuItem(value: 'dificil', child: Text('Difícil')),
                ],
                onChanged: (v) => setState(() => _dificultad = v!),
              ),
              const SizedBox(height: 12),
              ..._opciones.asMap().entries.map((entry) {
                final i = entry.key;
                final opcion = entry.value;
                return Row(
                  children: [
                    RadioGroup<bool>(
                      groupValue: opcion.correcta,
                      onChanged: (_) => setState(() {
                        _opciones = [
                          for (var j = 0; j < _opciones.length; j++)
                            (
                              controller: _opciones[j].controller,
                              correcta: j == i,
                            ),
                        ];
                      }),
                      child: const Radio<bool>(value: true),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: opcion.controller,
                        decoration: InputDecoration(
                          labelText: 'Opción ${String.fromCharCode(65 + i)}',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Completa la opción'
                            : null,
                      ),
                    ),
                    if (_opciones.length > 2)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => setState(() {
                          final removed = _opciones.removeAt(i);
                          removed.controller.dispose();
                        }),
                      ),
                  ],
                );
              }),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(
                    () => _opciones.add((
                      controller: TextEditingController(),
                      correcta: false,
                    )),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Añadir opción'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _guardando ? null : () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: _guardando ? null : _guardar,
        child: _guardando
            ? const CircularProgressIndicator()
            : const Text('Guardar'),
      ),
    ],
  );
}
