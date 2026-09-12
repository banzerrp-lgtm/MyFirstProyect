import 'package:flutter/material.dart';

Future<String?> mostrarDialogoNombre(
  BuildContext context, {
  required String titulo,
  String inicial = '',
  String labelCampo = 'Nombre',
}) async {
  final controller = TextEditingController(text: inicial);
  final formKey = GlobalKey<FormState>();
  final resultado = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: labelCampo),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Escribe un nombre' : null,
          onFieldSubmitted: (_) {
            if (formKey.currentState!.validate()) {
              Navigator.pop(context, controller.text.trim());
            }
          },
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
  return resultado;
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
