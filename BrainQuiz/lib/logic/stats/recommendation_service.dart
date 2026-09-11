import 'package:flutter/material.dart';

import '../../data/repositories/quiz_repository.dart';

class Recommendation {
  const Recommendation({
    required this.title,
    required this.description,
    required this.priority,
    required this.icon,
  });

  final String title;
  final String description;
  final String priority;
  final IconData icon;
}

class RecommendationService {
  const RecommendationService();

  List<Recommendation> buildRecommendations(ProgresoData data) {
    final recommendations = <Recommendation>[];

    if (data.intentos.isEmpty) {
      return const [
        Recommendation(
          title: 'Empieza con un simulacro corto',
          description: 'Todavía no tienes historial. Haz un simulacro inicial para activar tu base y medir tu nivel.',
          priority: 'Alta',
          icon: Icons.play_circle_fill,
        ),
      ];
    }

    final promedio = data.porcentaje;
    if (promedio < 60) {
      recommendations.add(
        const Recommendation(
          title: 'Enfoca la base antes que la cantidad',
          description: 'Tu promedio está por debajo del 60%. Haz pruebas más cortas y repite los temas con más fallos antes de sumar más volumen.',
          priority: 'Alta',
          icon: Icons.trending_down,
        ),
      );
    } else if (promedio < 80) {
      recommendations.add(
        const Recommendation(
          title: 'Estás en una zona de mejora',
          description: 'Tienes buen nivel, pero aún hay margen. Prioriza repaso de temas repetidos y busca consistencia en tus simulacros.',
          priority: 'Media',
          icon: Icons.trending_up,
        ),
      );
    } else {
      recommendations.add(
        const Recommendation(
          title: 'Mantén la racha',
          description: 'Tu rendimiento es sólido. Sigue con simulacros cortos y revisa solo dudas puntuales para consolidar la mejora.',
          priority: 'Baja',
          icon: Icons.emoji_events,
        ),
      );
    }

    if (data.errores.isNotEmpty) {
      final topError = data.errores.first;
      recommendations.add(
        Recommendation(
          title: 'Revisa ${topError.materia}',
          description:
              'La pregunta con más fallos es "${topError.enunciado}" en ${topError.tema}. Repruébala antes del próximo intento.',
          priority: 'Alta',
          icon: Icons.error_outline,
        ),
      );

      final groupedByTema = <String, int>{};
      for (final error in data.errores) {
        groupedByTema[error.tema] =
            (groupedByTema[error.tema] ?? 0) + error.errores;
      }
      if (groupedByTema.isNotEmpty) {
        final temaMasDebil = groupedByTema.entries.reduce(
          (curr, next) => curr.value >= next.value ? curr : next,
        );
        recommendations.add(
          Recommendation(
            title: 'Prioriza ${temaMasDebil.key}',
            description: 'Es el tema con más errores acumulados. Dedica una sesión breve de repaso y vuelve a evaluarlo.',
            priority: 'Media',
            icon: Icons.psychology,
          ),
        );
      }
    }

    return recommendations.take(3).toList();
  }
}
