import 'package:drift/drift.dart';

import 'database.dart';

/// Inserta datos de prueba solo si la tabla Facultades está vacía.
/// Seguro de llamar en cada arranque durante desarrollo.
Future<void> seedIfEmpty(AppDatabase db) async {
  final yaExiste = await db.select(db.facultades).get();
  if (yaExiste.isNotEmpty) return;

  await db.transaction(() async {
    final facultadId = await db.into(db.facultades).insert(
          FacultadesCompanion.insert(
            nombre: 'Examen de admisión de Odontología',
          ),
        );

    final materiaBiologiaId = await db.into(db.materias).insert(
          MateriasCompanion.insert(
            facultadId: facultadId,
            nombre: 'Biología',
          ),
        );
    final materiaQuimicaId = await db.into(db.materias).insert(
          MateriasCompanion.insert(
            facultadId: facultadId,
            nombre: 'Química',
          ),
        );

    final temaCitologiaId = await db.into(db.temas).insert(
          TemasCompanion.insert(
            materiaId: materiaBiologiaId,
            nombre: 'Citología',
          ),
        );
    final temaGeneticaId = await db.into(db.temas).insert(
          TemasCompanion.insert(
            materiaId: materiaBiologiaId,
            nombre: 'Genética',
          ),
        );
    final temaOrganicaId = await db.into(db.temas).insert(
          TemasCompanion.insert(
            materiaId: materiaQuimicaId,
            nombre: 'Química orgánica',
          ),
        );

    Future<void> insertarPregunta({
      required int temaId,
      required String enunciado,
      required String dificultad,
      String? explicacion,
      required List<(String, bool)> opciones,
    }) async {
      final preguntaId = await db.into(db.preguntas).insert(
            PreguntasCompanion.insert(
              temaId: temaId,
              enunciado: enunciado,
              dificultad: dificultad,
              explicacion: Value(explicacion),
            ),
          );

      for (var i = 0; i < opciones.length; i++) {
        final (texto, esCorrecta) = opciones[i];
        await db.into(db.opciones).insert(
              OpcionesCompanion.insert(
                preguntaId: preguntaId,
                texto: texto,
                esCorrecta: Value(esCorrecta),
                orden: i,
              ),
            );
      }
    }

    await insertarPregunta(
      temaId: temaCitologiaId,
      enunciado: '¿Cuál es la unidad básica de los seres vivos?',
      dificultad: 'facil',
      explicacion:
          'La célula es la unidad estructural y funcional de todo ser vivo.',
      opciones: [
        ('Tejido', false),
        ('Célula', true),
        ('Órgano', false),
        ('Sistema', false),
      ],
    );

    await insertarPregunta(
      temaId: temaCitologiaId,
      enunciado:
          '¿Qué organelo se encarga de la producción de energía celular?',
      dificultad: 'media',
      explicacion: 'La mitocondria produce ATP mediante respiración celular.',
      opciones: [
        ('Aparato de Golgi', false),
        ('Mitocondria', true),
        ('Retículo endoplasmático', false),
        ('Lisosoma', false),
      ],
    );

    await insertarPregunta(
      temaId: temaGeneticaId,
      enunciado: '¿Qué molécula contiene la información genética?',
      dificultad: 'facil',
      opciones: [
        ('ARN', false),
        ('ADN', true),
        ('ATP', false),
        ('Proteína', false),
      ],
    );

    await insertarPregunta(
      temaId: temaOrganicaId,
      enunciado: '¿Cuál es el elemento base de la química orgánica?',
      dificultad: 'facil',
      opciones: [
        ('Oxígeno', false),
        ('Carbono', true),
        ('Nitrógeno', false),
        ('Hidrógeno', false),
      ],
    );
  });
}
