import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Facultades,
    Materias,
    Temas,
    Preguntas,
    Opciones,
    Intentos,
    RespuestasIntento,
    QuizzesGuardados,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Constructor para tests / conexiones alternativas (ej. import/export)
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        // A partir de aquí se agregan los onUpgrade cuando cambie el schema.
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'brainquiz.sqlite'));

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON;'),
    );
  });
}
