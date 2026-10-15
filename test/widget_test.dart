import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test/main.dart';

void main() {
  testWidgets('Affiche la page des contenus et le bouton d’ajout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TraceApp());

    expect(find.text('Mes contenus'), findsOneWidget);
    expect(find.text('Aucun contenu pour le moment'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byTooltip('Ajouter un contenu'), findsOneWidget);
  });
}
