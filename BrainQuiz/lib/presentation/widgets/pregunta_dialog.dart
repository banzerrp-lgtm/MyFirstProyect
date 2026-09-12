import 'package:flutter/material.dart';

import '../../logic/quiz_engine/quiz_models.dart';

typedef GuardarPreguntaCallback = Future<dynamic> Function(
  String enunciado,
  String? explicacion,
  String dificultad,
  List<({String texto, bool correcta})> opciones,
);

Future<void> mostrarDialogoPregunta(
  BuildContext context, {
  PreguntaConOpciones? pregunta,
  required GuardarPreguntaCallback onGuardar,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _PreguntaDialog(pregunta: pregunta, onGuardar: onGuardar),
  );
}

class _PreguntaDialog extends StatefulWidget {
  const _PreguntaDialog({this.pregunta, required this.onGuardar});
  final PreguntaConOpciones? pregunta;
  final GuardarPreguntaCallback onGuardar;

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

    final textos = opciones.map((o) => o.texto.toLowerCase()).toList();
    if (textos.toSet().length != textos.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hay opciones con el mismo texto.'),
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
