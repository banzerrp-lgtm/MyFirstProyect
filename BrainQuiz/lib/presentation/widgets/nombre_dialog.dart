import 'package:flutter/material.dart';

Future<String?> mostrarDialogoNombre(
  BuildContext context, {
  required String titulo,
  String inicial = '',
  String labelCampo = 'Nombre',
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _NombreDialog(
      titulo: titulo,
      inicial: inicial,
      labelCampo: labelCampo,
    ),
  );
}

class _NombreDialog extends StatefulWidget {
  const _NombreDialog({
    required this.titulo,
    required this.inicial,
    required this.labelCampo,
  });

  final String titulo;
  final String inicial;
  final String labelCampo;

  @override
  State<_NombreDialog> createState() => _NombreDialogState();
}

class _NombreDialogState extends State<_NombreDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.inicial,
  );
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: widget.labelCampo),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Escribe un nombre' : null,
          onFieldSubmitted: (_) => _guardar(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}

Future<bool> confirmarEliminacion(
  BuildContext context, {
  required String mensaje,
  String titulo = 'Confirmar eliminación',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
  return ok ?? false;
}
