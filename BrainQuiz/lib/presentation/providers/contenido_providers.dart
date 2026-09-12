import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database.dart';
import '../../data/repositories/contenido_repository.dart';
import '../../logic/import_export/content_transfer_service.dart';
import '../../logic/ai_prompt/ai_quiz_import_service.dart';
import '../../logic/quiz_engine/quiz_models.dart';
import 'database_provider.dart';

final contenidoRepositoryProvider = Provider<ContenidoRepository>((ref) {
  return ContenidoRepository(ref.watch(databaseProvider));
});

final contentTransferServiceProvider = Provider<ContentTransferService>((ref) {
  return ContentTransferService(ref.watch(databaseProvider));
});

final aiQuizImportServiceProvider = Provider<AiQuizImportService>((ref) {
  return AiQuizImportService(ref.watch(contenidoRepositoryProvider));
});

final facultadesProvider = StreamProvider.autoDispose<List<Facultade>>((ref) {
  return ref.watch(contenidoRepositoryProvider).watchFacultades();
});

final materiaProvider = StreamProvider.autoDispose.family<Materia?, int>(
  (ref, materiaId) {
    return ref.watch(contenidoRepositoryProvider).watchMateria(materiaId);
  },
);

final materiasProvider = StreamProvider.autoDispose.family<List<Materia>, int>(
  (ref, facultadId) {
    return ref.watch(contenidoRepositoryProvider).watchMaterias(facultadId);
  },
);

final temaProvider = StreamProvider.autoDispose.family<Tema?, int>(
  (ref, temaId) {
    return ref.watch(contenidoRepositoryProvider).watchTema(temaId);
  },
);

final temasProvider = StreamProvider.autoDispose.family<List<Tema>, int>(
  (ref, materiaId) {
    return ref.watch(contenidoRepositoryProvider).watchTemas(materiaId);
  },
);

final cantidadPreguntasProvider = StreamProvider.autoDispose.family<int, int>(
  (ref, temaId) {
    return ref.watch(contenidoRepositoryProvider).watchCantidadPreguntas(temaId);
  },
);

final cantidadPreguntasMateriaProvider =
    StreamProvider.autoDispose.family<int, int>((ref, materiaId) {
  return ref
      .watch(contenidoRepositoryProvider)
      .watchCantidadPreguntasMateria(materiaId);
});

final cantidadPreguntasFacultadProvider =
    StreamProvider.autoDispose.family<int, int>((ref, facultadId) {
  return ref
      .watch(contenidoRepositoryProvider)
      .watchCantidadPreguntasFacultad(facultadId);
});

final preguntasProvider = StreamProvider.autoDispose.family<
  List<PreguntaConOpciones>,
  int
>((ref, temaId) {
  return ref.watch(contenidoRepositoryProvider).watchPreguntas(temaId);
});
