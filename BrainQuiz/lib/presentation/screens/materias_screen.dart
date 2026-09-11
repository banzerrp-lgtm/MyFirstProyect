import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/contenido_providers.dart';
import 'temas_screen.dart';

class MateriasScreen extends ConsumerWidget {
  const MateriasScreen({
    super.key,
    required this.facultadId,
    required this.facultadNombre,
  });

  final int facultadId;
  final String facultadNombre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materias = ref.watch(materiasProvider(facultadId));

    return Scaffold(
      appBar: AppBar(title: Text(facultadNombre)),
      body: materias.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (lista) {
          if (lista.isEmpty) {
            return const Center(child: Text('No hay materias en esta facultad.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final materia = lista[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(materia.nombre),
                  trailing: const Icon(Icons.chevron_right),
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
