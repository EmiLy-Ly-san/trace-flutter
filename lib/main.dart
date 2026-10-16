import 'package:flutter/material.dart';

import 'features/contents/view/pages/contents_page.dart'; // Premier écran affiché au démarrage
import 'app/theme/app_theme.dart';

void main() {
  runApp(const TraceApp()); // Lance Flutter avec TraceApp comme widget racine
}

//StatelessWidget : ce widget ne gère pas d’état mutable/
class TraceApp extends StatelessWidget {
  const TraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // build décrit l’interface à afficher
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Masque le bandeau « DEBUG »
      theme: AppTheme.light, //Applique mon theme
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        // Désactive les effets visuels aux extrémités des listes
        overscroll: false,
      ),
      home: const ContentsPage(), //écran d’accueil
    );
  }
}
