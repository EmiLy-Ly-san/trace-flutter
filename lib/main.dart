import 'package:flutter/material.dart';
import 'app/theme/app_theme.dart';
import 'app/router/app_router.dart';

void main() {
  runApp(const TraceApp()); // Lance Flutter avec TraceApp comme widget racine
}

//StatelessWidget : ce widget ne gère pas d’état mutable/
class TraceApp extends StatelessWidget {
  const TraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // build décrit l’interface à afficher
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // Masque le bandeau « DEBUG »
      theme: AppTheme.light, //Applique mon theme
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        // Désactive les effets visuels aux extrémités des listes
        overscroll: false,
      ),
      routerConfig: appRouter,
    );
  }
}
