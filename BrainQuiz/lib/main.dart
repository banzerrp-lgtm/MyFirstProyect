import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/providers/database_provider.dart';
import 'presentation/screens/inicio_screen.dart';

void main() {
  runApp(const ProviderScope(child: BrainQuizApp()));
}

class BrainQuizApp extends StatelessWidget {
  const BrainQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainQuiz',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6),
        ),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      home: const _StartupGate(),
    );
  }
}

/// Espera a que la BD esté lista (con seed) antes de mostrar la app real.
class _StartupGate extends ConsumerWidget {
  const _StartupGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = ref.watch(databaseReadyProvider);

    return ready.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) => Scaffold(
        body: Center(child: Text('Error al iniciar la base de datos:\n$err')),
      ),
      data: (_) => const InicioScreen(),
    );
  }
}
