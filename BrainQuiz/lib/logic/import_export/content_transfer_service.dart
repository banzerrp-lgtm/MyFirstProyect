import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/database/database.dart';

enum ImportStrategy { agregar, omitir, reemplazar }

class TransferSummary {
  const TransferSummary({
    this.facultades = 0,
    this.materias = 0,
    this.temas = 0,
    this.preguntas = 0,
    this.opciones = 0,
    this.intentos = 0,
    this.respuestas = 0,
    this.quizzesGuardados = 0,
  });

  final int facultades;
  final int materias;
  final int temas;
  final int preguntas;
  final int opciones;
  final int intentos;
  final int respuestas;
  final int quizzesGuardados;

  Map<String, int> toJson() => {
    'facultades': facultades,
    'materias': materias,
    'temas': temas,
    'preguntas': preguntas,
    'opciones': opciones,
    'intentos': intentos,
    'respuestas': respuestas,
    'quizzesGuardados': quizzesGuardados,
  };

  @override
  String toString() =>
      '$facultades facultades, $materias materias, $temas temas, '
      '$preguntas preguntas, $opciones opciones';
}

class ExportResult {
  const ExportResult({required this.path, required this.summary});

  final Uri path;
  final TransferSummary summary;
}

class ImportResult {
  const ImportResult({
    required this.summary,
    this.skipped = 0,
    this.replaced = 0,
  });

  final TransferSummary summary;
  final int skipped;
  final int replaced;
}

class ContentTransferException implements Exception {
  const ContentTransferException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Serializa el contenido local en un zip con extensión .odontobank.
///
/// El archivo contiene un único `manifest.json`. Mantener el formato en JSON
/// hace que la validación y las futuras versiones sean explícitas, sin exponer
/// el archivo SQLite ni datos de la plataforma.
class ContentTransferService {
  ContentTransferService(this._db);

  static const _formatType = 'brainquiz.content';
  static const _backupType = 'brainquiz.backup';
  static const _formatVersion = 1;
  static const _manifestName = 'manifest.json';

  final AppDatabase _db;

  Future<ExportResult?> exportarTema(int temaId) async {
    final tema = await (_db.select(
      _db.temas,
    )..where((t) => t.id.equals(temaId))).getSingleOrNull();
    if (tema == null) {
      throw const ContentTransferException('El tema seleccionado no existe.');
    }
    final materia = await (_db.select(
      _db.materias,
    )..where((m) => m.id.equals(tema.materiaId))).getSingleOrNull();
    if (materia == null) {
      throw const ContentTransferException(
        'La materia del tema seleccionado no existe.',
      );
    }
    final facultad = await (_db.select(
      _db.facultades,
    )..where((f) => f.id.equals(materia.facultadId))).getSingleOrNull();
    if (facultad == null) {
      throw const ContentTransferException(
        'La facultad del tema seleccionado no existe.',
      );
    }
    final payload = _payloadBase('tema')
      ..['facultades'] = [
        {
          'id': facultad.id,
          'nombre': facultad.nombre,
          'materias': [
            {
              'id': materia.id,
              'nombre': materia.nombre,
              'temas': [await _temaToJson(tema)],
            },
          ],
        },
      ];
    _addSummary(payload);
    return _savePayload(payload, 'brainquiz_${_safeFileName(tema.nombre)}');
  }

  Future<ExportResult?> exportarMateria(int materiaId) async {
    final materia = await (_db.select(
      _db.materias,
    )..where((m) => m.id.equals(materiaId))).getSingleOrNull();
    if (materia == null) {
      throw const ContentTransferException(
        'La materia seleccionada no existe.',
      );
    }
    final facultad = await (_db.select(
      _db.facultades,
    )..where((f) => f.id.equals(materia.facultadId))).getSingleOrNull();
    if (facultad == null) {
      throw const ContentTransferException(
        'La facultad de la materia seleccionada no existe.',
      );
    }
    final payload = _payloadBase('materia')
      ..['facultades'] = [
        {
          'id': facultad.id,
          'nombre': facultad.nombre,
          'materias': [await _materiaToJson(materia)],
        },
      ];
    _addSummary(payload);
    return _savePayload(payload, 'brainquiz_${_safeFileName(materia.nombre)}');
  }

  Future<ExportResult?> exportarFacultad(int facultadId) async {
    final facultad = await (_db.select(
      _db.facultades,
    )..where((f) => f.id.equals(facultadId))).getSingleOrNull();
    if (facultad == null) {
      throw const ContentTransferException(
        'La facultad seleccionada no existe.',
      );
    }

    final payload = _payloadBase('facultad')
      ..['facultades'] = [await _facultadToJson(facultad)];
    _addSummary(payload);
    return _savePayload(payload, 'brainquiz_${_safeFileName(facultad.nombre)}');
  }

  Map<String, dynamic> _payloadBase(String scope) => {
    'metadata': {
      'type': _formatType,
      'version': _formatVersion,
      'scope': scope,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    },
    'facultades': <Map<String, dynamic>>[],
  };

  Future<ExportResult?> exportarBackupCompleto() async {
    final facultades = await (_db.select(
      _db.facultades,
    )..orderBy([(f) => OrderingTerm.asc(f.nombre)])).get();
    final intentos = await _db.select(_db.intentos).get();
    final respuestas = await _db.select(_db.respuestasIntento).get();
    final quizzes = await _db.select(_db.quizzesGuardados).get();
    final payload = <String, dynamic>{
      'metadata': {
        'type': _backupType,
        'version': _formatVersion,
        'scope': 'completo',
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      },
      'facultades': [
        for (final facultad in facultades) await _facultadToJson(facultad),
      ],
      'intentos': [
        for (final intento in intentos)
          {
            'id': intento.id,
            'fecha': intento.fecha.toIso8601String(),
            'tipo': intento.tipo,
            'configJson': intento.configJson,
            'correctas': intento.correctas,
            'incorrectas': intento.incorrectas,
            'tiempoUsado': intento.tiempoUsado,
          },
      ],
      'respuestas': [
        for (final respuesta in respuestas)
          {
            'id': respuesta.id,
            'intentoId': respuesta.intentoId,
            'preguntaId': respuesta.preguntaId,
            'opcionElegidaId': respuesta.opcionElegidaId,
            'esCorrecta': respuesta.esCorrecta,
          },
      ],
      'quizzesGuardados': [
        for (final quiz in quizzes)
          {'id': quiz.id, 'nombre': quiz.nombre, 'configJson': quiz.configJson},
      ],
    };
    _addSummary(
      payload,
      extras: TransferSummary(
        intentos: intentos.length,
        respuestas: respuestas.length,
        quizzesGuardados: quizzes.length,
      ),
    );
    return _savePayload(payload, 'brainquiz_backup');
  }

  /// Abre el selector de archivos y aplica la estrategia elegida.
  Future<ImportResult?> importarArchivo({
    required ImportStrategy estrategia,
  }) async {
    final picked = await FilePicker.pickFile(
      dialogTitle: 'Importar banco de preguntas',
      type: FileType.custom,
      allowedExtensions: ['odontobank'],
    );
    if (picked == null) return null;
    final bytes = await picked.readAsBytes();
    if (bytes.isEmpty) {
      throw const ContentTransferException(
        'No se pudo leer el archivo seleccionado.',
      );
    }
    return importarBytes(bytes, estrategia: estrategia);
  }

  /// Punto de entrada sin UI, útil también para pruebas y para futuras
  /// integraciones que ya tengan los bytes del archivo.
  Future<ImportResult> importarBytes(
    List<int> bytes, {
    required ImportStrategy estrategia,
  }) async {
    Map<String, dynamic> payload;
    try {
      final archive = ZipDecoder().decodeBytes(bytes, verify: true);
      final manifest = archive.find(_manifestName);
      if (manifest == null) {
        throw const ContentTransferException(
          'El archivo no contiene manifest.json.',
        );
      }
      final manifestBytes = manifest.readBytes();
      if (manifestBytes == null || manifestBytes.isEmpty) {
        throw const ContentTransferException('manifest.json está vacío.');
      }
      final decoded = jsonDecode(utf8.decode(manifestBytes));
      if (decoded is! Map) {
        throw const ContentTransferException(
          'La estructura del manifiesto no es válida.',
        );
      }
      payload = Map<String, dynamic>.from(decoded);
    } on ContentTransferException {
      rethrow;
    } catch (error) {
      throw ContentTransferException('No se pudo abrir el archivo: $error');
    }

    _validatePayload(payload);
    final metadata = Map<String, dynamic>.from(payload['metadata'] as Map);
    return _db.transaction(() async {
      final context = _ImportContext();
      final maps = <_IdMaps>[];
      for (final rawFacultad in payload['facultades'] as List) {
        final map = await _importFacultad(
          _asMap(rawFacultad, 'facultad'),
          estrategia,
          context,
        );
        maps.add(map);
      }

      if (metadata['type'] == _backupType) {
        await _importBackupData(payload, maps, context);
      }
      return ImportResult(
        summary: context.summary,
        skipped: context.skipped,
        replaced: context.replaced,
      );
    });
  }

  Future<ExportResult?> _savePayload(
    Map<String, dynamic> payload,
    String baseName,
  ) async {
    final archive = Archive()
      ..addFile(ArchiveFile.string(_manifestName, jsonEncode(payload)));
    final bytes = ZipEncoder().encodeBytes(archive);
    final documents = await getApplicationDocumentsDirectory();
    final path = await FilePicker.saveFile(
      dialogTitle: 'Guardar banco de preguntas',
      fileName: '$baseName.odontobank',
      bytes: bytes,
      mimeType: 'application/octet-stream',
      initialDirectory: documents.path,
    );
    if (path == null) return null;
    return ExportResult(
      path: path,
      summary: _summaryFromJson(payload['summary'] as Map),
    );
  }

  Future<Map<String, dynamic>> _facultadToJson(Facultade facultad) async {
    final materias =
        await (_db.select(_db.materias)
              ..where((m) => m.facultadId.equals(facultad.id))
              ..orderBy([(m) => OrderingTerm.asc(m.nombre)]))
            .get();
    return {
      'id': facultad.id,
      'nombre': facultad.nombre,
      'materias': [
        for (final materia in materias) await _materiaToJson(materia),
      ],
    };
  }

  Future<Map<String, dynamic>> _materiaToJson(Materia materia) async {
    final temas =
        await (_db.select(_db.temas)
              ..where((t) => t.materiaId.equals(materia.id))
              ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
            .get();
    return {
      'id': materia.id,
      'nombre': materia.nombre,
      'temas': [for (final tema in temas) await _temaToJson(tema)],
    };
  }

  Future<Map<String, dynamic>> _temaToJson(Tema tema) async {
    final preguntas =
        await (_db.select(_db.preguntas)
              ..where((p) => p.temaId.equals(tema.id))
              ..orderBy([(p) => OrderingTerm.asc(p.id)]))
            .get();
    return {
      'id': tema.id,
      'nombre': tema.nombre,
      'preguntas': [
        for (final pregunta in preguntas) await _preguntaToJson(pregunta),
      ],
    };
  }

  Future<Map<String, dynamic>> _preguntaToJson(Pregunta pregunta) async {
    final opciones =
        await (_db.select(_db.opciones)
              ..where((o) => o.preguntaId.equals(pregunta.id))
              ..orderBy([(o) => OrderingTerm.asc(o.orden)]))
            .get();
    return {
      'id': pregunta.id,
      'enunciado': pregunta.enunciado,
      'explicacion': pregunta.explicacion,
      'dificultad': pregunta.dificultad,
      'opciones': [
        for (final opcion in opciones)
          {
            'id': opcion.id,
            'texto': opcion.texto,
            'esCorrecta': opcion.esCorrecta,
            'orden': opcion.orden,
          },
      ],
    };
  }

  Future<_IdMaps> _importFacultad(
    Map<String, dynamic> data,
    ImportStrategy estrategia,
    _ImportContext context,
  ) async {
    final nombre = _requiredText(data, 'nombre', 'facultad');
    final facultades = await _db.select(_db.facultades).get();
    final existente = _findByName(facultades, nombre);
    if (estrategia == ImportStrategy.omitir && existente != null) {
      context.skipped += _countNodes(data);
      return _IdMaps();
    }
    if (estrategia == ImportStrategy.reemplazar && existente != null) {
      await (_db.delete(
        _db.facultades,
      )..where((f) => f.id.equals(existente.id))).go();
      context.replaced++;
    }

    final destino = estrategia == ImportStrategy.agregar ? existente : null;
    final facultadId =
        destino?.id ??
        await _db
            .into(_db.facultades)
            .insert(FacultadesCompanion.insert(nombre: nombre));
    if (destino == null) context._counts.facultades++;
    final maps = _IdMaps()
      ..facultades[_requiredId(data, 'facultad')] = facultadId;
    for (final rawMateria in _requiredList(data, 'materias', 'facultad')) {
      await _importMateria(
        _asMap(rawMateria, 'materia'),
        facultadId,
        estrategia,
        context,
        maps,
      );
    }
    return maps;
  }

  Future<void> _importMateria(
    Map<String, dynamic> data,
    int facultadId,
    ImportStrategy estrategia,
    _ImportContext context,
    _IdMaps maps,
  ) async {
    final nombre = _requiredText(data, 'nombre', 'materia');
    final existentes = await (_db.select(
      _db.materias,
    )..where((m) => m.facultadId.equals(facultadId))).get();
    final existente = _findByName(existentes, nombre);
    final id =
        existente?.id ??
        await _db
            .into(_db.materias)
            .insert(
              MateriasCompanion.insert(facultadId: facultadId, nombre: nombre),
            );
    if (existente == null) {
      context._counts.materias++;
    } else if (estrategia == ImportStrategy.agregar) {
      context.skipped++;
    }
    maps.materias[_requiredId(data, 'materia')] = id;
    for (final rawTema in _requiredList(data, 'temas', 'materia')) {
      await _importTema(_asMap(rawTema, 'tema'), id, estrategia, context, maps);
    }
  }

  Future<void> _importTema(
    Map<String, dynamic> data,
    int materiaId,
    ImportStrategy estrategia,
    _ImportContext context,
    _IdMaps maps,
  ) async {
    final nombre = _requiredText(data, 'nombre', 'tema');
    final existentes = await (_db.select(
      _db.temas,
    )..where((t) => t.materiaId.equals(materiaId))).get();
    final existente = _findByName(existentes, nombre);
    final id =
        existente?.id ??
        await _db
            .into(_db.temas)
            .insert(
              TemasCompanion.insert(materiaId: materiaId, nombre: nombre),
            );
    if (existente == null) {
      context._counts.temas++;
    } else if (estrategia == ImportStrategy.agregar) {
      context.skipped++;
    }
    maps.temas[_requiredId(data, 'tema')] = id;
    for (final rawPregunta in _requiredList(data, 'preguntas', 'tema')) {
      await _importPregunta(
        _asMap(rawPregunta, 'pregunta'),
        id,
        estrategia,
        context,
        maps,
      );
    }
  }

  Future<void> _importPregunta(
    Map<String, dynamic> data,
    int temaId,
    ImportStrategy estrategia,
    _ImportContext context,
    _IdMaps maps,
  ) async {
    final enunciado = _requiredText(data, 'enunciado', 'pregunta');
    final dificultad = _requiredText(data, 'dificultad', 'pregunta');
    final explicacion = _optionalText(data, 'explicacion');
    final opciones = _requiredList(data, 'opciones', 'pregunta');
    final existentes = await (_db.select(
      _db.preguntas,
    )..where((p) => p.temaId.equals(temaId))).get();
    final existente = _findByQuestionText(existentes, enunciado);
    if (existente != null) {
      maps.preguntas[_requiredId(data, 'pregunta')] = existente.id;
      final currentOptions = await (_db.select(
        _db.opciones,
      )..where((o) => o.preguntaId.equals(existente.id))).get();
      for (final rawOption in opciones) {
        final option = _asMap(rawOption, 'opción');
        final oldId = _requiredId(option, 'opción');
        final order = _requiredInt(option, 'orden', 'opción');
        final matchingOptions = currentOptions
            .where((o) => o.orden == order)
            .toList();
        final current = matchingOptions.isEmpty ? null : matchingOptions.first;
        if (current != null) maps.opciones[oldId] = current.id;
      }
      context.skipped += 1 + opciones.length;
      return;
    }

    final preguntaId = await _db
        .into(_db.preguntas)
        .insert(
          PreguntasCompanion.insert(
            temaId: temaId,
            enunciado: enunciado,
            explicacion: Value(explicacion),
            dificultad: dificultad,
          ),
        );
    context._counts.preguntas++;
    maps.preguntas[_requiredId(data, 'pregunta')] = preguntaId;
    for (final rawOption in opciones) {
      final option = _asMap(rawOption, 'opción');
      final optionId = await _db
          .into(_db.opciones)
          .insert(
            OpcionesCompanion.insert(
              preguntaId: preguntaId,
              texto: _requiredText(option, 'texto', 'opción'),
              esCorrecta: Value(_requiredBool(option, 'esCorrecta', 'opción')),
              orden: _requiredInt(option, 'orden', 'opción'),
            ),
          );
      maps.opciones[_requiredId(option, 'opción')] = optionId;
      context._counts.opciones++;
    }
  }

  Future<void> _importBackupData(
    Map<String, dynamic> payload,
    List<_IdMaps> maps,
    _ImportContext context,
  ) async {
    final attemptMap = <int, int>{};
    for (final raw in _requiredList(payload, 'intentos', 'backup')) {
      final data = _asMap(raw, 'intento');
      final id = await _db
          .into(_db.intentos)
          .insert(
            IntentosCompanion.insert(
              fecha: DateTime.parse(_requiredText(data, 'fecha', 'intento')),
              tipo: _requiredText(data, 'tipo', 'intento'),
              configJson: _requiredText(data, 'configJson', 'intento'),
              correctas: _requiredInt(data, 'correctas', 'intento'),
              incorrectas: _requiredInt(data, 'incorrectas', 'intento'),
              tiempoUsado: _requiredInt(data, 'tiempoUsado', 'intento'),
            ),
          );
      attemptMap[_requiredId(data, 'intento')] = id;
      context._counts.intentos++;
    }
    final allMaps = _IdMaps.merge(maps);
    for (final raw in _requiredList(payload, 'respuestas', 'backup')) {
      final data = _asMap(raw, 'respuesta');
      final intentoId =
          attemptMap[_requiredInt(data, 'intentoId', 'respuesta')];
      final preguntaId =
          allMaps.preguntas[_requiredInt(data, 'preguntaId', 'respuesta')];
      if (intentoId == null || preguntaId == null) {
        context.skipped++;
        continue;
      }
      await _db
          .into(_db.respuestasIntento)
          .insert(
            RespuestasIntentoCompanion.insert(
              intentoId: intentoId,
              preguntaId: preguntaId,
              opcionElegidaId: Value(
                allMaps.opciones[_optionalInt(data, 'opcionElegidaId')],
              ),
              esCorrecta: _requiredBool(data, 'esCorrecta', 'respuesta'),
            ),
          );
      context._counts.respuestas++;
    }
    for (final raw in _requiredList(payload, 'quizzesGuardados', 'backup')) {
      final data = _asMap(raw, 'quiz guardado');
      await _db
          .into(_db.quizzesGuardados)
          .insert(
            QuizzesGuardadosCompanion.insert(
              nombre: _requiredText(data, 'nombre', 'quiz guardado'),
              configJson: _requiredText(data, 'configJson', 'quiz guardado'),
            ),
          );
      context._counts.quizzesGuardados++;
    }
  }

  void _validatePayload(Map<String, dynamic> payload) {
    final metadata = _asMap(payload['metadata'], 'metadata');
    final type = metadata['type'];
    final version = metadata['version'];
    if (type != _formatType && type != _backupType) {
      throw const ContentTransferException('Tipo de archivo no compatible.');
    }
    if (version != _formatVersion) {
      throw ContentTransferException(
        'Versión de archivo no compatible: $version.',
      );
    }
    final summary = payload['summary'];
    if (summary is! Map) {
      throw const ContentTransferException(
        'El archivo no contiene un resumen válido.',
      );
    }
    for (final field in [
      'facultades',
      'materias',
      'temas',
      'preguntas',
      'opciones',
    ]) {
      if (summary[field] is! int) {
        throw ContentTransferException('El resumen no contiene $field.');
      }
    }
    final facultades = payload['facultades'];
    if (facultades is! List || facultades.isEmpty) {
      throw const ContentTransferException(
        'El archivo no contiene facultades.',
      );
    }
    for (final raw in facultades) {
      _validateFacultad(_asMap(raw, 'facultad'));
    }
    if (type == _backupType) {
      for (final field in ['intentos', 'respuestas', 'quizzesGuardados']) {
        if (payload[field] is! List) {
          throw ContentTransferException('Falta la sección $field del backup.');
        }
      }
    }
  }

  void _validateFacultad(Map<String, dynamic> data) {
    _requiredId(data, 'facultad');
    _requiredText(data, 'nombre', 'facultad');
    for (final rawMateria in _requiredList(data, 'materias', 'facultad')) {
      final materia = _asMap(rawMateria, 'materia');
      _requiredId(materia, 'materia');
      _requiredText(materia, 'nombre', 'materia');
      for (final rawTema in _requiredList(materia, 'temas', 'materia')) {
        final tema = _asMap(rawTema, 'tema');
        _requiredId(tema, 'tema');
        _requiredText(tema, 'nombre', 'tema');
        for (final rawPregunta in _requiredList(tema, 'preguntas', 'tema')) {
          final pregunta = _asMap(rawPregunta, 'pregunta');
          _requiredId(pregunta, 'pregunta');
          _requiredText(pregunta, 'enunciado', 'pregunta');
          _requiredText(pregunta, 'dificultad', 'pregunta');
          for (final rawOption in _requiredList(
            pregunta,
            'opciones',
            'pregunta',
          )) {
            final option = _asMap(rawOption, 'opción');
            _requiredId(option, 'opción');
            _requiredText(option, 'texto', 'opción');
            _requiredBool(option, 'esCorrecta', 'opción');
            _requiredInt(option, 'orden', 'opción');
          }
        }
      }
    }
  }

  void _addSummary(
    Map<String, dynamic> payload, {
    TransferSummary extras = const TransferSummary(),
  }) {
    var summary = extras;
    for (final rawFaculty in payload['facultades'] as List) {
      final faculty = rawFaculty as Map<String, dynamic>;
      var materias = 0;
      var temas = 0;
      var preguntas = 0;
      var opciones = 0;
      for (final rawMateria in faculty['materias'] as List) {
        materias++;
        for (final rawTema
            in (rawMateria as Map<String, dynamic>)['temas'] as List) {
          temas++;
          for (final rawPregunta
              in (rawTema as Map<String, dynamic>)['preguntas'] as List) {
            preguntas++;
            opciones +=
                ((rawPregunta as Map<String, dynamic>)['opciones'] as List)
                    .length;
          }
        }
      }
      summary = TransferSummary(
        facultades: summary.facultades + 1,
        materias: summary.materias + materias,
        temas: summary.temas + temas,
        preguntas: summary.preguntas + preguntas,
        opciones: summary.opciones + opciones,
        intentos: summary.intentos,
        respuestas: summary.respuestas,
        quizzesGuardados: summary.quizzesGuardados,
      );
    }
    payload['summary'] = summary.toJson();
  }

  static TransferSummary _summaryFromJson(Map summary) => TransferSummary(
    facultades: _jsonInt(summary, 'facultades'),
    materias: _jsonInt(summary, 'materias'),
    temas: _jsonInt(summary, 'temas'),
    preguntas: _jsonInt(summary, 'preguntas'),
    opciones: _jsonInt(summary, 'opciones'),
    intentos: _jsonInt(summary, 'intentos'),
    respuestas: _jsonInt(summary, 'respuestas'),
    quizzesGuardados: _jsonInt(summary, 'quizzesGuardados'),
  );

  static int _jsonInt(Map data, String key) =>
      data[key] is int ? data[key] as int : 0;

  static String _safeFileName(String value) =>
      value.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').trim();

  static String _normalise(String value) => value.trim().toLowerCase();

  static T? _findByName<T>(List<T> rows, String name) {
    for (final row in rows) {
      final rowName = row is Facultade
          ? row.nombre
          : row is Materia
          ? row.nombre
          : (row as Tema).nombre;
      if (_normalise(rowName) == _normalise(name)) return row;
    }
    return null;
  }

  static Pregunta? _findByQuestionText(List<Pregunta> rows, String text) {
    for (final row in rows) {
      if (_normalise(row.enunciado) == _normalise(text)) return row;
    }
    return null;
  }

  static Map<String, dynamic> _asMap(Object? value, String label) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw ContentTransferException('La sección $label no es válida.');
  }

  static List _requiredList(Map data, String key, String label) {
    final value = data[key];
    if (value is List) return value;
    throw ContentTransferException('Falta la lista $key en $label.');
  }

  static int _requiredId(Map data, String label) =>
      _requiredInt(data, 'id', label);

  static int _requiredInt(Map data, String key, String label) {
    final value = data[key];
    if (value is int) return value;
    throw ContentTransferException('El campo $key de $label no es válido.');
  }

  static int? _optionalInt(Map data, String key) {
    final value = data[key];
    return value is int ? value : null;
  }

  static String _requiredText(Map data, String key, String label) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) return value;
    throw ContentTransferException('El campo $key de $label no es válido.');
  }

  static String? _optionalText(Map data, String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is String) return value;
    throw ContentTransferException('El campo $key no es válido.');
  }

  static bool _requiredBool(Map data, String key, String label) {
    final value = data[key];
    if (value is bool) return value;
    throw ContentTransferException('El campo $key de $label no es válido.');
  }

  static int _countNodes(Map<String, dynamic> faculty) {
    var count = 1;
    for (final rawMateria in faculty['materias'] as List) {
      count++;
      for (final rawTema in (rawMateria as Map)['temas'] as List) {
        count++;
        for (final rawPregunta in (rawTema as Map)['preguntas'] as List) {
          count++;
          count += ((rawPregunta as Map)['opciones'] as List).length;
        }
      }
    }
    return count;
  }
}

class _ImportContext {
  final _MutableSummary _counts = _MutableSummary();
  int skipped = 0;
  int replaced = 0;

  TransferSummary get summary => _counts.toSummary();
}

class _IdMaps {
  final facultades = <int, int>{};
  final materias = <int, int>{};
  final temas = <int, int>{};
  final preguntas = <int, int>{};
  final opciones = <int, int>{};

  static _IdMaps merge(List<_IdMaps> maps) {
    final merged = _IdMaps();
    for (final map in maps) {
      merged
        ..facultades.addAll(map.facultades)
        ..materias.addAll(map.materias)
        ..temas.addAll(map.temas)
        ..preguntas.addAll(map.preguntas)
        ..opciones.addAll(map.opciones);
    }
    return merged;
  }
}

class _MutableSummary {
  int facultades = 0;
  int materias = 0;
  int temas = 0;
  int preguntas = 0;
  int opciones = 0;
  int intentos = 0;
  int respuestas = 0;
  int quizzesGuardados = 0;

  TransferSummary toSummary() => TransferSummary(
    facultades: facultades,
    materias: materias,
    temas: temas,
    preguntas: preguntas,
    opciones: opciones,
    intentos: intentos,
    respuestas: respuestas,
    quizzesGuardados: quizzesGuardados,
  );
}
