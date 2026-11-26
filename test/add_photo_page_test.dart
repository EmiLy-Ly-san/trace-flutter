import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:test/core/storage/app_database.dart';
import 'package:test/core/storage/database_provider.dart';
import 'package:test/contents/data/repositories/contents_repository.dart';
import 'package:test/contents/view/pages/add_photo_page.dart';

void main() {
  // Base temporaire en mémoire, pour ne pas toucher au vrai fichier
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  // Affiche l’écran photo seul, avec la base temporaire
  Future<void> openPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(
          home: AddPhotoPage(photo: XFile('/chemin/vers/photo.jpg')),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Ferme l’écran puis la base, comme dans widget_test.dart
  Future<void> closePage(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 1));
    await tester.runAsync(database.close);
  }

  testWidgets('Affiche la photo choisie et un champ titre', (tester) async {
    await openPage(tester);

    expect(find.text('Ajouter une photo'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Titre'), findsOneWidget);
    expect(find.text('Enregistrer'), findsOneWidget);

    // L’aperçu lit la photo depuis son fichier
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<FileImage>());
    expect((image.image as FileImage).file.path, '/chemin/vers/photo.jpg');

    await closePage(tester);
  });

  testWidgets('Demande un titre et n’enregistre rien sans titre', (
    tester,
  ) async {
    await openPage(tester);

    await tester.tap(find.text('Enregistrer'));
    await tester.pump();

    // Le message apparaît et l’écran reste ouvert
    expect(find.text('Ajoute un titre'), findsOneWidget);
    expect(find.text('Ajouter une photo'), findsOneWidget);

    // Rien n’a été rangé dans la base
    final contents = await tester.runAsync(
      () => ContentsRepository(database).getAll(),
    );
    expect(contents, isEmpty);

    await closePage(tester);
  });
}
