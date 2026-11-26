import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test/core/storage/app_database.dart';
import 'package:test/core/storage/database_provider.dart';
import 'package:test/contents/data/repositories/contents_repository.dart';
import 'package:test/contents/view/pages/contents_page.dart';
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

  // « Privé » et « Partagé » sont écrits à deux endroits :
  // dans le filtre en haut, et dans le badge de chaque carte.
  Finder filter(String label) => find.descendant(
    of: find.byType(SegmentedButton<ShareFilter>),
    matching: find.text(label),
  );

  Finder badge(String label) =>
      find.descendant(of: find.byType(Card), matching: find.text(label));

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

  testWidgets('Affiche une photo enregistrée dans la base', (tester) async {
    await tester.runAsync(() {
      return ContentsRepository(
        database,
      ).addPhoto(title: 'Le parc', filePath: '/chemin/vers/photo.jpg');
    });

    await startApp(tester);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text('Le parc'), findsOneWidget);

    // La carte lit la photo depuis le fichier du téléphone
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<FileImage>());
    expect((image.image as FileImage).file.path, '/chemin/vers/photo.jpg');

    await closeApp(tester);
  });

  testWidgets('Ouvre le détail d’une photo', (tester) async {
    await tester.runAsync(() {
      return ContentsRepository(
        database,
      ).addPhoto(title: 'Le parc', filePath: '/chemin/vers/photo.jpg');
    });

    await startApp(tester);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Ouvrir le contenu'));
    await tester.pumpAndSettle();

    // La page de détail affiche le titre et la même photo
    expect(find.text('Retour'), findsOneWidget);
    expect(find.text('Le parc'), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image));
    expect((image.image as FileImage).file.path, '/chemin/vers/photo.jpg');

    // Revient à l’accueil : le routeur est partagé entre les tests
    await tester.tap(find.text('Retour'));
    await tester.pumpAndSettle();
    expect(find.text('Mes contenus'), findsOneWidget);

    await closeApp(tester);
  });

  testWidgets('Affiche un fichier importé et son nom dans le détail', (
    tester,
  ) async {
    await tester.runAsync(() {
      return ContentsRepository(
        database,
      ).addFile(title: 'Mon bilan', filePath: '/chemin/files/123_bilan.pdf');
    });

    await startApp(tester);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    // La carte montre le titre, l’icône et un libellé à la place du texte
    expect(find.text('Mon bilan'), findsOneWidget);
    expect(find.text('Fichier joint'), findsOneWidget);
    expect(find.byIcon(Icons.insert_drive_file_outlined), findsOneWidget);

    await tester.tap(find.byTooltip('Ouvrir le contenu'));
    await tester.pumpAndSettle();

    // Le détail affiche le nom d’origine, sans le numéro ajouté à l’import
    expect(find.text('bilan.pdf'), findsOneWidget);

    // Revient à l’accueil : le routeur est partagé entre les tests
    await tester.tap(find.text('Retour'));
    await tester.pumpAndSettle();

    await closeApp(tester);
  });

  testWidgets('Partage un contenu depuis le détail', (tester) async {
    await tester.runAsync(() {
      return ContentsRepository(
        database,
      ).addText(title: 'Une promenade au calme', body: 'Je suis sortie.');
    });

    await startApp(tester);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    // Au départ, le badge de la carte indique « Privé »
    expect(badge('Privé'), findsOneWidget);

    await tester.tap(find.byTooltip('Ouvrir le contenu'));
    await tester.pumpAndSettle();

    // Active l’interrupteur de partage
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

    // Laisse la base enregistrer le changement en temps réel
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    final saved = await tester.runAsync(
      () => ContentsRepository(database).getAll(),
    );
    expect(saved!.single.isShared, isTrue);

    // De retour à l’accueil, la carte affiche « Partagé »
    await tester.tap(find.text('Retour'));
    await tester.pumpAndSettle();
    expect(badge('Partagé'), findsOneWidget);

    await closeApp(tester);
  });

  testWidgets('Filtre les contenus entre tout, privé et partagé', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final repository = ContentsRepository(database);
      await repository.addText(title: 'Pour moi', body: 'Privé');
      await repository.addText(title: 'Pour ma psy', body: 'Partagé');
      final shared = (await repository.getAll()).firstWhere(
        (content) => content.title == 'Pour ma psy',
      );
      await repository.updateShared(id: shared.id, isShared: true);
    });

    await startApp(tester);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    // Par défaut, « Tout » montre les deux contenus
    expect(find.text('Pour moi'), findsOneWidget);
    expect(find.text('Pour ma psy'), findsOneWidget);

    await tester.tap(filter('Partagé'));
    await tester.pumpAndSettle();
    expect(find.text('Pour moi'), findsNothing);
    expect(find.text('Pour ma psy'), findsOneWidget);

    await tester.tap(filter('Privé'));
    await tester.pumpAndSettle();
    expect(find.text('Pour moi'), findsOneWidget);
    expect(find.text('Pour ma psy'), findsNothing);

    await tester.tap(filter('Tout'));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNWidgets(2));

    await closeApp(tester);
  });

  testWidgets('Indique quand aucun contenu n’est partagé', (tester) async {
    await tester.runAsync(() {
      return ContentsRepository(
        database,
      ).addText(title: 'Pour moi', body: 'Privé');
    });

    await startApp(tester);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    await tester.tap(filter('Partagé'));
    await tester.pumpAndSettle();

    expect(find.text('Pour moi'), findsNothing);
    expect(find.text('Aucun contenu partagé'), findsOneWidget);

    await closeApp(tester);
  });

  testWidgets('Supprime un contenu seulement après confirmation', (
    tester,
  ) async {
    await tester.runAsync(() {
      return ContentsRepository(
        database,
      ).addText(title: 'Une promenade au calme', body: 'Je suis sortie.');
    });

    await startApp(tester);
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.text('Une promenade au calme'), findsOneWidget);

    // Appuie sur la poubelle, puis sur « Annuler » : la carte reste.
    await tester.tap(find.byTooltip('Supprimer le contenu'));
    await tester.pumpAndSettle();
    expect(find.text('Supprimer ce contenu ?'), findsOneWidget);

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(find.text('Une promenade au calme'), findsOneWidget);

    // Recommence et confirme : la carte disparaît.
    await tester.tap(find.byTooltip('Supprimer le contenu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();

    // Laisse la base finir la suppression en temps réel.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text('Une promenade au calme'), findsNothing);
    expect(find.text('Aucun contenu pour le moment'), findsOneWidget);

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
