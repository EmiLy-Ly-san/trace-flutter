import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test/core/storage/app_database.dart';
import 'package:test/core/storage/database_provider.dart';
import 'package:test/features/contents/data/repositories/contents_repository.dart';
import 'package:test/main.dart';

void main() {
  // Base temporaire en mémoire, pour ne pas toucher au vrai fichier
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  // Lance l’application avec la base temporaire à la place de la vraie.
  Future<void> startApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const TraceApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Ferme l’application puis la base, à la fin de chaque test.
  // Drift garde une minuterie après la fermeture de l’écran :
  // le pump final lui laisse le temps de se terminer.
  Future<void> closeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));

    // runAsync laisse la base se fermer en temps réel.
    await tester.runAsync(database.close);
  }

  testWidgets('Affiche un message quand il n’y a aucun contenu', (
    tester,
  ) async {
    await startApp(tester);

    expect(find.text('Mes contenus'), findsOneWidget);
    expect(find.text('Aucun contenu pour le moment'), findsOneWidget);
    expect(find.byType(Card), findsNothing);

    await closeApp(tester);
  });

  testWidgets('Affiche un texte enregistré dans la base', (tester) async {
    // runAsync laisse la base travailler en temps réel pendant le test.
    await tester.runAsync(() {
      return ContentsRepository(
        database,
      ).addText(title: 'Une promenade au calme', body: 'Je suis sortie.');
    });

    await startApp(tester);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text('Une promenade au calme'), findsOneWidget);
    expect(find.text('Je suis sortie.'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);

    await closeApp(tester);
  });

  testWidgets('Ouvre le menu des formats de contenu', (tester) async {
    await startApp(tester);

    // Appuie sur le bouton « + ».
    await tester.tap(find.byTooltip('Ajouter un contenu'));
    await tester.pumpAndSettle();

    // Vérifie les quatre choix proposés.
    expect(find.text('Écrire un texte'), findsOneWidget);
    expect(find.text('Ajouter une photo'), findsOneWidget);
    expect(find.text('Enregistrer un vocal'), findsOneWidget);
    expect(find.text('Importer un fichier'), findsOneWidget);

    await closeApp(tester);
  });
}
