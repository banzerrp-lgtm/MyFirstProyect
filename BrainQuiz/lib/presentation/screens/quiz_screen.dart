import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/quiz_engine/quiz_engine_service.dart';
import '../../logic/quiz_engine/quiz_models.dart';
import '../providers/quiz_providers.dart';
import 'quiz_resultado_screen.dart';

/// Pantalla del quiz: recibe un filtro ya armado, inicia la sesión,
/// gestiona el temporizador y delega toda la lógica al motor.
class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, required this.filtro});

  final QuizFiltro filtro;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late Future<void> _iniciando;
  final Stopwatch _cronometro = Stopwatch();
  Timer? _ticker;
  int _segundosRestantes = 0;
  bool _finalizando = false;

  @override
  void initState() {
    super.initState();
    _segundosRestantes = widget.filtro.tiempoLimiteSegundos ?? 0;
    _iniciando = _iniciar();
  }

  Future<void> _iniciar() async {
    await ref.read(quizSessionProvider.notifier).iniciar(widget.filtro);
    _cronometro.start();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    if (!mounted) return;
    if (widget.filtro.tiempoLimiteSegundos != null) {
      setState(() {
        _segundosRestantes = (_segundosRestantes - 1).clamp(0, 359999).toInt();
      });
      if (_segundosRestantes <= 0) {
        _finalizar();
      }
    } else {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _cronometro.stop();
    super.dispose();
  }

  int get _segundosTranscurridos => _cronometro.elapsed.inSeconds;

  Future<void> _finalizar() async {
    if (_finalizando) return;
    _finalizando = true;
    _ticker?.cancel();
    _cronometro.stop();

    final limite = widget.filtro.tiempoLimiteSegundos;
    final tiempoUsado = limite == null
        ? _segundosTranscurridos
        : _segundosTranscurridos.clamp(0, limite).toInt();
    final resultado = await ref
        .read(quizSessionProvider.notifier)
        .finalizar(tiempoUsadoSegundos: tiempoUsado);

    if (!mounted || resultado == null) return;

    ref.read(quizSessionProvider.notifier).limpiar();
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => QuizResultadoScreen(resultado: resultado),
      ),
    );
  }

  Future<bool> _confirmarSalir() async {
    final salir = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Salir del quiz?'),
        content: const Text('Perderás el progreso de este intento.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    return salir ?? false;
  }

  String _formatoTiempo(int segundos) {
    final s = segundos.clamp(0, 359999);
    final horas = s ~/ 3600;
    final minutos = (s % 3600) ~/ 60;
    final segs = s % 60;
    final minutosStr = minutos.toString().padLeft(2, '0');
    final segsStr = segs.toString().padLeft(2, '0');
    return horas > 0 ? '$horas:$minutosStr:$segsStr' : '$minutosStr:$segsStr';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _iniciando,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          final mensaje = error is PreguntasInsuficientesException
              ? error.toString()
              : 'No se pudo iniciar el quiz.\n$error';
          return Scaffold(
            appBar: AppBar(title: const Text('Quiz')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(mensaje, textAlign: TextAlign.center),
              ),
            ),
          );
        }

        return _buildQuiz(context);
      },
    );
  }

  Widget _buildQuiz(BuildContext context) {
    final estado = ref.watch(quizSessionProvider);

    if (estado == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pregunta = estado.pregunta;
    final tiempoLimite = widget.filtro.tiempoLimiteSegundos != null;
    final tiempoMostrado = tiempoLimite
        ? _segundosRestantes
        : _segundosTranscurridos;
    final tiempoEnRiesgo = tiempoLimite && _segundosRestantes <= 30;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmarSalir() && context.mounted) {
          _ticker?.cancel();
          ref.read(quizSessionProvider.notifier).limpiar();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pregunta ${estado.indice + 1} de ${estado.total}'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: tiempoEnRiesgo ? Colors.red : null,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatoTiempo(tiempoMostrado),
                      style: TextStyle(
                        color: tiempoEnRiesgo ? Colors.red : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(value: (estado.indice + 1) / estado.total),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pregunta.enunciado,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          tooltip: estado.marcada
                              ? 'Desmarcar pendiente'
                              : 'Marcar como pendiente',
                          icon: Icon(
                            estado.marcada ? Icons.flag : Icons.outlined_flag,
                            color: estado.marcada ? Colors.orange : null,
                          ),
                          onPressed: () => ref
                              .read(quizSessionProvider.notifier)
                              .alternarPendiente(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RadioGroup<int>(
                      groupValue: estado.respuestaActual?.opcionElegidaId,
                      onChanged: (valor) {
                        if (valor != null) {
                          ref
                              .read(quizSessionProvider.notifier)
                              .responder(valor);
                        }
                      },
                      child: Column(
                        children: pregunta.opciones.map((opcion) {
                          final seleccionada =
                              estado.respuestaActual?.opcionElegidaId ==
                              opcion.id;
                          return Card(
                            color: seleccionada
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            child: RadioListTile<int>(
                              title: Text(opcion.texto),
                              value: opcion.id,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: estado.esPrimera
                            ? null
                            : () => ref
                                  .read(quizSessionProvider.notifier)
                                  .anterior(),
                        child: const Text('Anterior'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: estado.esUltima
                          ? FilledButton(
                              onPressed: () => _finalizar(),
                              child: const Text('Finalizar'),
                            )
                          : FilledButton(
                              onPressed: () => ref
                                  .read(quizSessionProvider.notifier)
                                  .siguiente(),
                              child: const Text('Siguiente'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
