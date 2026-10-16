import 'package:flutter/material.dart';

// Test les widgets Flutter
import 'package:flutter_test/flutter_test.dart';

// « test » correspond au nom du projet dans pubspec.yaml
import 'package:test/main.dart';

void main() {
  testWidgets('Affiche la page des contenus et le bouton d’ajout', (
    WidgetTester tester,
  ) async {
    // Construit l’appli dans l’env de test
    await tester.pumpWidget(const TraceApp());

    // Vérifie que chaque élément attendu est présent une fois
    expect(find.text('Mes contenus'), findsOneWidget);

    expect(find.text('Aucun contenu pour le moment'), findsOneWidget);

    expect(find.byType(FloatingActionButton), findsOneWidget);

    expect(find.byTooltip('Ajouter un contenu'), findsOneWidget);
  });
}
