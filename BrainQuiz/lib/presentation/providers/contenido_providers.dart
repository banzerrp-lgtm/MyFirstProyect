import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database.dart';
import '../../data/repositories/contenido_repository.dart';
import 'database_provider.dart';

final contenidoRepositoryProvider = Provider<ContenidoRepository>((ref) {
  return ContenidoRepository(ref.watch(databaseProvider));
});

final facultadesProvider = StreamProvider<List<Facultade>>((ref) {
  return ref.watch(contenidoRepositoryProvider).watchFacultades();
});

final materiasProvider =
    StreamProvider.family<List<Materia>, int>((ref, facultadId) {
  return ref.watch(contenidoRepositoryProvider).watchMaterias(facultadId);
});

final temasProvider = StreamProvider.family<List<Tema>, int>((ref, materiaId) {
  return ref.watch(contenidoRepositoryProvider).watchTemas(materiaId);
});

final cantidadPreguntasProvider =
    StreamProvider.family<int, int>((ref, temaId) {
  return ref.watch(contenidoRepositoryProvider).watchCantidadPreguntas(temaId);
});

final cantidadPreguntasMateriaProvider =
    StreamProvider.family<int, int>((ref, materiaId) {
  return ref
      .watch(contenidoRepositoryProvider)
      .watchCantidadPreguntasMateria(materiaId);
});

final cantidadPreguntasFacultadProvider =
    StreamProvider.family<int, int>((ref, facultadId) {
  return ref
      .watch(contenidoRepositoryProvider)
      .watchCantidadPreguntasFacultad(facultadId);
});
