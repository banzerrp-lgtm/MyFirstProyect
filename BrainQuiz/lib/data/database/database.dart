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
        onUpgrade: (Migrator m, int from, int to) async {
          // Mantener un historial explícito de migraciones por versión.
          // El objetivo es evitar cambios de schema que reescriban la base sin
          // migrar los datos existentes.
          switch (from) {
            case 1:
              // Versión actual del esquema. Cuando llegue la primera migración
              // real (por ejemplo, schemaVersion = 2), agregar aquí la lógica de
              // upgrade explícita, por ejemplo:
              // await m.addColumn(...);
              // await m.createTable(...);
              // Nunca hacer dropTable/createTable sin una migración de datos
              // documentada y probada.
              return;
            default:
              throw UnsupportedError(
                'No hay una migración definida para $from -> $to',
              );
          }
        },
        beforeOpen: (details) async {
          if (details.hadUpgrade) {
            // Si en el futuro se dispara un upgrade, dejar este punto como
            // checkpoint para validaciones y logging de migración.
          }
        },
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
