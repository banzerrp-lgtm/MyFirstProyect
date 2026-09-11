import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/quiz_repository.dart';
import '../../logic/stats/recommendation_service.dart';
import '../providers/quiz_providers.dart';

class ProgresoScreen extends ConsumerWidget {
  const ProgresoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progreso = ref.watch(progresoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi progreso'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: () => ref.invalidate(progresoProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: progreso.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          message: 'No se pudo cargar el progreso.',
          onRetry: () => ref.invalidate(progresoProvider),
        ),
        data: (data) => _ContenidoProgreso(data: data),
      ),
    );
  }
}

class _ContenidoProgreso extends StatelessWidget {
  const _ContenidoProgreso({required this.data});
  final ProgresoData data;

  @override
  Widget build(BuildContext context) {
    if (data.intentos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aún no tienes intentos guardados.\nCompleta un quiz para empezar a ver tu progreso.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final recomendaciones = const RecommendationService().buildRecommendations(
      data,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ResumenCard(data: data),
        const SizedBox(height: 16),
        const Text('Recomendaciones', style: _sectionStyle),
        const SizedBox(height: 8),
        ...recomendaciones.map(
          (recomendacion) => _RecommendationTile(recomendacion: recomendacion),
        ),
        const SizedBox(height: 16),
        if (data.puntosEvolucion.length > 1) ...[
          const Text('Evolución', style: _sectionStyle),
          const SizedBox(height: 8),
          SizedBox(height: 230, child: _Grafico(data.puntosEvolucion)),
          const SizedBox(height: 16),
        ],
        const Text('Mis errores', style: _sectionStyle),
        const SizedBox(height: 8),
        if (data.errores.isEmpty)
          const Card(
            child: ListTile(title: Text('¡No hay respuestas incorrectas!')),
          )
        else
          ...data.errores.take(10).map((error) => _ErrorTile(error: error)),
        const SizedBox(height: 16),
        const Text('Historial de intentos', style: _sectionStyle),
        const SizedBox(height: 8),
        ...data.intentos
            .take(20)
            .map((intento) => _IntentoTile(intento: intento)),
      ],
    );
  }

  static const _sectionStyle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
  );
}

class _ResumenCard extends StatelessWidget {
  const _ResumenCard({required this.data});
  final ProgresoData data;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: 16,
        spacing: 18,
        children: [
          _Dato('Intentos', '${data.intentos.length}', Icons.assignment),
          _Dato(
            'Promedio',
            '${data.porcentaje.toStringAsFixed(0)}%',
            Icons.trending_up,
          ),
          _Dato(
            'Correctas',
            '${data.totalCorrectas}',
            Icons.check_circle,
            Colors.green,
          ),
          _Dato(
            'Incorrectas',
            '${data.totalIncorrectas}',
            Icons.cancel,
            Colors.red,
          ),
        ],
      ),
    ),
  );
}

class _Dato extends StatelessWidget {
  const _Dato(this.label, this.value, this.icon, [this.color]);
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Text(label),
    ],
  );
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({required this.recomendacion});
  final Recommendation recomendacion;

  @override
  Widget build(BuildContext context) {
    final color = switch (recomendacion.priority) {
      'Alta' => Colors.red,
      'Media' => Colors.orange,
      _ => Colors.green,
    };

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(26),
          foregroundColor: color,
          child: Icon(recomendacion.icon),
        ),
        title: Text(recomendacion.title),
        subtitle: Text(recomendacion.description),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            recomendacion.priority,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _Grafico extends StatelessWidget {
  const _Grafico(this.puntos);
  final List<({DateTime fecha, double porcentaje})> puntos;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: true),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 34),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= puntos.length || index % 2 != 0) {
                  return const SizedBox.shrink();
                }
                final fecha = puntos[index].fecha;
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    '${fecha.day}/${fecha.month}',
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < puntos.length; i++)
                FlSpot(i.toDouble(), puntos[i].porcentaje),
            ],
            isCurved: true,
            color: color,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: color.withAlpha(35)),
          ),
        ],
      ),
    );
  }
}

class _ErrorTile extends StatelessWidget {
  const _ErrorTile({required this.error});
  final ErrorPreguntaResumen error;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.red.withAlpha(30),
        foregroundColor: Colors.red,
        child: Text('${error.errores}'),
      ),
      title: Text(
        error.enunciado,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${error.materia} · ${error.tema}  •  ${error.errores} fallos',
      ),
    ),
  );
}

class _IntentoTile extends StatelessWidget {
  const _IntentoTile({required this.intento});
  final IntentoResumen intento;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(
        intento.porcentaje >= 60 ? Icons.check_circle : Icons.warning,
        color: intento.porcentaje >= 60 ? Colors.green : Colors.orange,
      ),
      title: Text(
        '${intento.porcentaje.toStringAsFixed(0)}% · ${_tipo(intento.tipo)}',
      ),
      subtitle: Text(
        '${_fecha(intento.fecha)}  •  ${intento.correctas} correctas · '
        '${intento.incorrectas} incorrectas',
      ),
      trailing: Text('${intento.tiempoUsado ~/ 60} min'),
    ),
  );
}

String _fecha(DateTime fecha) =>
    '${fecha.day.toString().padLeft(2, '0')}/'
    '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

String _tipo(String tipo) => switch (tipo) {
  'simulacro' => 'Simulacro',
  'practica_tema' => 'Práctica de tema',
  'practica_materia' => 'Práctica de materia',
  _ => tipo,
};

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
      ],
    ),
  );
}
