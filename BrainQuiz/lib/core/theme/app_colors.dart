import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color seed = Color(0xFF0F766E);
  static const Color seedDark = Color(0xFF14B8A6);

  static const Color facil = Color(0xFF2E7D32);
  static const Color media = Color(0xFFB45309);
  static const Color dificil = Color(0xFFB91C1C);

  static const Color facilContainer = Color(0xFFDCFCE7);
  static const Color mediaContainer = Color(0xFFFEF3C7);
  static const Color dificilContainer = Color(0xFFFEE2E2);

  static const Color correcto = Color(0xFF16A34A);
  static const Color incorrecto = Color(0xFFDC2626);
  static const Color sinResponder = Color(0xFF6B7280);

  static const Color prioridadAlta = Color(0xFFDC2626);
  static const Color prioridadMedia = Color(0xFFD97706);
  static const Color prioridadBaja = Color(0xFF16A34A);

  static Color porDificultad(String dificultad) => switch (dificultad) {
    'facil' => facil,
    'dificil' => dificil,
    _ => media,
  };

  static Color containerPorDificultad(String dificultad) =>
      switch (dificultad) {
        'facil' => facilContainer,
        'dificil' => dificilContainer,
        _ => mediaContainer,
      };

  static Color porPrioridad(String prioridad) => switch (prioridad) {
    'Alta' => prioridadAlta,
    'Media' => prioridadMedia,
    _ => prioridadBaja,
  };

  static String nombreDificultad(String dificultad) => switch (dificultad) {
    'facil' => 'Fácil',
    'dificil' => 'Difícil',
    _ => 'Media',
  };
}
