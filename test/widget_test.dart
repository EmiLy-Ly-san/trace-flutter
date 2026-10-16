import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test/main.dart';

void main() {
  testWidgets('Affiche les cartes de contenu', (tester) async {
    // Lance l’application et attend la fin du chargement.
    await tester.pumpWidget(const TraceApp());
    await tester.pumpAndSettle();

    // Vérifie les titres des contenus d’exemple.
    expect(find.text('Mes contenus'), findsOneWidget);
    expect(find.text('Une promenade au calme'), findsOneWidget);
    expect(find.text('Une photo à partager'), findsOneWidget);

    // Vérifie la présence des deux cartes.
    expect(find.byType(Card), findsNWidgets(2));

    // Vérifie qu’aucune erreur n’a été remontée,
    // notamment pendant le chargement de l’image.
    expect(tester.takeException(), isNull);
  });

  testWidgets('Ouvre le menu des formats de contenu', (tester) async {
    await tester.pumpWidget(const TraceApp());

    // Appuie sur le bouton « + ».
    await tester.tap(find.byTooltip('Ajouter un contenu'));
    await tester.pumpAndSettle();

    // Vérifie les quatre choix proposés.
    expect(find.text('Écrire un texte'), findsOneWidget);
    expect(find.text('Ajouter une photo'), findsOneWidget);
    expect(find.text('Enregistrer un vocal'), findsOneWidget);
    expect(find.text('Importer un fichier'), findsOneWidget);
  });
}
