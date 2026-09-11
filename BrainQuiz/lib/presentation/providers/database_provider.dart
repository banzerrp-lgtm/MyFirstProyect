import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database.dart';
import '../../data/database/seed_data.dart';

/// Instancia única de la base de datos para toda la app.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Se completa cuando el seed de datos de prueba terminó (o ya existía).
final databaseReadyProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(databaseProvider);
  await seedIfEmpty(db);
});
