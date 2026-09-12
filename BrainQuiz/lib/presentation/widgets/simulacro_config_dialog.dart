import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/database.dart';
import '../../logic/quiz_engine/quiz_models.dart';
import '../providers/contenido_providers.dart';

Future<QuizFiltro?> mostrarConfiguracionSimulacroDialog(
  BuildContext context, {
  required int facultadId,
  required String facultadNombre,
}) {
  return showDialog<QuizFiltro>(
    context: context,
    builder: (_) => _SimulacroConfigDialog(
      facultadId: facultadId,
      facultadNombre: facultadNombre,
    ),
  );
}

class _MateriaEstado {
  bool seleccionada = false;
  int cantidad = 0;
  bool expandido = false;
  final Map<int, int> porTema = {};
}

class _SimulacroConfigDialog extends ConsumerStatefulWidget {
  const _SimulacroConfigDialog({
    required this.facultadId,
    required this.facultadNombre,
  });

  final int facultadId;
  final String facultadNombre;

  @override
  ConsumerState<_SimulacroConfigDialog> createState() =>
      _SimulacroConfigDialogState();
}

class _SimulacroConfigDialogState
    extends ConsumerState<_SimulacroConfigDialog> {
  final Map<int, _MateriaEstado> _estado = {};
  final Set<String> _dificultades = {};
  bool _conTiempo = false;
  int _minutos = 30;

  _MateriaEstado _estadoDe(int id) =>
      _estado.putIfAbsent(id, _MateriaEstado.new);

  int get _totalSeleccionado => _estado.values
      .where((estado) => estado.seleccionada)
      .fold(0, (total, estado) => total + estado.cantidad);

  @override
  Widget build(BuildContext context) {
    final materiasAsync = ref.watch(materiasProvider(widget.facultadId));
    return AlertDialog(
      title: Text('Simulacro: ${widget.facultadNombre}'),
      content: SizedBox(
        width: 480,
        height: 520,
        child: materiasAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (materias) => materias.isEmpty
              ? const Center(child: Text('Esta facultad no tiene materias.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Selecciona materias y cantidad de preguntas:'),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: materias.length,
                        itemBuilder: (_, index) => _materiaTile(materias[index]),
                      ),
                    ),
                    const Divider(),
                    Text(
                      'Total seleccionado: $_totalSeleccionado preguntas',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Dificultad (todas si no eliges ninguna):'),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final dificultad in const [
                          ('facil', 'Fácil'),
                          ('media', 'Media'),
                          ('dificil', 'Difícil'),
                        ])
                          FilterChip(
                            label: Text(dificultad.$2),
                            selected: _dificultades.contains(dificultad.$1),
                            onSelected: (selected) => setState(() {
                              if (selected) {
                                _dificultades.add(dificultad.$1);
                              } else {
                                _dificultades.remove(dificultad.$1);
                              }
                            }),
                          ),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Con límite de tiempo'),
                      value: _conTiempo,
                      onChanged: (value) =>
                          setState(() => _conTiempo = value),
                    ),
                    if (_conTiempo)
                      Row(
                        children: [
                          const Text('Minutos:'),
                          Expanded(
                            child: Slider(
                              value: _minutos.toDouble(),
                              min: 5,
                              max: 180,
                              divisions: 35,
                              label: '$_minutos',
                              onChanged: (value) =>
                                  setState(() => _minutos = value.round()),
                            ),
                          ),
                          Text('$_minutos'),
                        ],
                      ),
                  ],
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _totalSeleccionado == 0 ? null : _confirmar,
          child: const Text('Iniciar simulacro'),
        ),
      ],
    );
  }

  Widget _materiaTile(Materia materia) {
    final estado = _estadoDe(materia.id);
    final cantidadAsync = ref.watch(
      cantidadPreguntasMateriaProvider(materia.id),
    );
    final maximo = cantidadAsync.hasValue ? cantidadAsync.requireValue : 0;
    return Card(
      key: ValueKey('simulacro-materia-${materia.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            value: estado.seleccionada,
            title: Text(materia.nombre),
            subtitle: Text('$maximo preguntas disponibles'),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: maximo == 0
                ? null
                : (value) => setState(() {
                    estado.seleccionada = value ?? false;
                    if (estado.seleccionada && estado.cantidad == 0) {
                      estado.cantidad = maximo < 10 ? maximo : 10;
                    }
                    if (!estado.seleccionada) {
                      estado.cantidad = 0;
                      estado.expandido = false;
                      estado.porTema.clear();
                    }
                  }),
          ),
          if (estado.seleccionada)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Cantidad:'),
                      Expanded(
                        child: Slider(
                          value: estado.cantidad
                              .clamp(1, maximo)
                              .toDouble(),
                          min: 1,
                          max: maximo.toDouble(),
                          divisions: maximo > 1 ? maximo - 1 : null,
                          label: '${estado.cantidad}',
                          onChanged: estado.expandido
                              ? null
                              : (value) => setState(
                                  () => estado.cantidad = value.round(),
                                ),
                        ),
                      ),
                      Text('${estado.cantidad}'),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => estado.expandido = !estado.expandido),
                    icon: Icon(
                      estado.expandido
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                    label: Text(
                      estado.expandido
                          ? 'Ocultar temas'
                          : 'Distribuir por tema',
                    ),
                  ),
                  if (estado.expandido) _temasDeMateria(materia, estado),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _temasDeMateria(Materia materia, _MateriaEstado estado) {
    final temasAsync = ref.watch(temasProvider(materia.id));
    return temasAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
      data: (temas) => Column(
        children: [
          for (final tema in temas) _temaRow(tema, estado),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Suma de temas: '
              '${estado.porTema.values.fold(0, (a, b) => a + b)}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _temaRow(Tema tema, _MateriaEstado estado) {
    final cantidadAsync = ref.watch(cantidadPreguntasProvider(tema.id));
    final maximo = cantidadAsync.hasValue ? cantidadAsync.requireValue : 0;
    final actual = estado.porTema[tema.id] ?? 0;
    return Row(
      children: [
        Expanded(child: Text(tema.nombre, overflow: TextOverflow.ellipsis)),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: actual == 0
              ? null
              : () => setState(() {
                  estado.porTema[tema.id] = actual - 1;
                  estado.cantidad =
                      estado.porTema.values.fold(0, (a, b) => a + b);
                }),
        ),
        Text('$actual'),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: actual >= maximo
              ? null
              : () => setState(() {
                  estado.porTema[tema.id] = actual + 1;
                  estado.cantidad =
                      estado.porTema.values.fold(0, (a, b) => a + b);
                }),
        ),
        Text('/ $maximo'),
      ],
    );
  }

  void _confirmar() {
    final distribucion = <DistribucionItem>[];
    for (final entry in _estado.entries) {
      final estado = entry.value;
      if (!estado.seleccionada || estado.cantidad <= 0) continue;
      if (estado.expandido && estado.porTema.isNotEmpty) {
        for (final tema in estado.porTema.entries) {
          if (tema.value > 0) {
            distribucion.add(
              DistribucionItem(
                materiaId: entry.key,
                temaId: tema.key,
                cantidad: tema.value,
              ),
            );
          }
        }
      } else {
        distribucion.add(
          DistribucionItem(materiaId: entry.key, cantidad: estado.cantidad),
        );
      }
    }
    if (distribucion.isEmpty) return;
    Navigator.of(context).pop(
      QuizFiltro(
        facultadId: widget.facultadId,
        dificultades: _dificultades,
        cantidadPreguntas: distribucion.fold(
          0,
          (total, item) => total + item.cantidad,
        ),
        tiempoLimiteSegundos: _conTiempo ? _minutos * 60 : null,
        tipo: 'simulacro',
        distribucion: distribucion,
      ),
    );
  }
}
