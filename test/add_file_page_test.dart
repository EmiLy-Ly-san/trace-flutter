import 'dart:typed_data';

import 'package:image_picker/image_picker.dart' show XFile;
import 'package:drift/native.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test/core/storage/app_database.dart';
import 'package:test/core/storage/database_provider.dart';
import 'package:test/features/contents/data/repositories/contents_repository.dart';
import 'package:test/features/contents/view/pages/add_file_page.dart';

// Faux fichier choisi : seul son nom est utilisé par ces tests
// PlatformFile ne peut être qu’étendu, par une classe « final »
final class _FakeFile extends PlatformFile {
  @override
  String get name => 'bilan_octobre.pdf';

  @override
  Uri get uri => Uri.file('/chemin/vers/bilan_octobre.pdf');

  @override
  XFile get xFile => throw UnimplementedError();

  @override
  int? lengthSync() => null;

  @override
  Future<int?> length() => throw UnimplementedError();

  @override
  Future<Uint8List> readAsBytes() => throw UnimplementedError();

  @override
  Stream<Uint8List> readAsByteStream() => throw UnimplementedError();
}

void main() {
  // Base temporaire en mémoire, pour ne pas toucher au vrai fichier
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  // Affiche l’écran d’import seul, avec la base temporaire
  Future<void> openPage(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: MaterialApp(home: AddFilePage(file: _FakeFile())),
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

  testWidgets('Propose le nom du fichier comme titre', (tester) async {
    await openPage(tester);

    expect(find.text('Importer un fichier'), findsOneWidget);
    expect(find.text('Enregistrer'), findsOneWidget);

    // Le titre est prérempli sans l’extension
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, 'bilan_octobre');

    // Le nom complet du fichier choisi est rappelé
    expect(find.text('bilan_octobre.pdf'), findsOneWidget);

    await closePage(tester);
  });

  testWidgets('Demande un titre et n’enregistre rien sans titre', (
    tester,
  ) async {
    await openPage(tester);

    // Efface le titre proposé, puis essaie d’enregistrer
    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();

    // Le message apparaît et l’écran reste ouvert
    expect(find.text('Ajoute un titre'), findsOneWidget);
    expect(find.text('Importer un fichier'), findsOneWidget);

    // Rien n’a été rangé dans la base
    final contents = await tester.runAsync(
      () => ContentsRepository(database).getAll(),
    );
    expect(contents, isEmpty);

    await closePage(tester);
  });
}
