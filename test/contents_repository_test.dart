import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test/core/storage/app_database.dart';
import 'package:test/features/contents/data/local/contents_table.dart';
import 'package:test/features/contents/data/repositories/contents_repository.dart';

void main() {
  late AppDatabase database;
  late ContentsRepository repository;

  setUp(() {
    // Base temporaire en mémoire, sans fichier
    database = AppDatabase(NativeDatabase.memory());
    repository = ContentsRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('supprime seulement le contenu demandé', () async {
    await repository.addText(title: 'Premier', body: 'Texte 1');
    await repository.addText(title: 'Deuxième', body: 'Texte 2');

    // Relit les contenus pour connaître le numéro du premier
    final before = await repository.getAll();
    expect(before, hasLength(2));
    final first = before.firstWhere((content) => content.title == 'Premier');

    await repository.deleteById(first.id);

    // Il ne reste que le deuxième
    final after = await repository.getAll();
    expect(after, hasLength(1));
    expect(after.first.title, 'Deuxième');
  });

  test('enregistre un vocal avec le chemin de son fichier', () async {
    await repository.addAudio(
      title: 'Mon vocal',
      filePath: '/chemin/vers/vocal.m4a',
    );

    final contents = await repository.getAll();

    expect(contents, hasLength(1));
    expect(contents.first.title, 'Mon vocal');
    expect(contents.first.type, ContentType.audio);
    expect(contents.first.filePath, '/chemin/vers/vocal.m4a');
    expect(contents.first.body, isNull);
  });

  test('supprime aussi le fichier d’un vocal', () async {
    // Crée un vrai fichier temporaire pour le test
    final folder = await Directory.systemTemp.createTemp('vocal_test');
    final file = File('${folder.path}/vocal.m4a');
    await file.writeAsString('faux audio');

    await repository.addAudio(title: 'Mon vocal', filePath: file.path);
    final saved = (await repository.getAll()).single;

    await repository.deleteById(saved.id);

    // La ligne et le fichier ont disparu
    expect(await repository.getAll(), isEmpty);
    expect(await file.exists(), isFalse);

    await folder.delete(recursive: true);
  });

  test('supprime un vocal même si son fichier est déjà absent', () async {
    await repository.addAudio(
      title: 'Mon vocal',
      filePath: '/chemin/inexistant/vocal.m4a',
    );
    final saved = (await repository.getAll()).single;

    await repository.deleteById(saved.id);

    expect(await repository.getAll(), isEmpty);
  });

  test('ne supprime rien si le numéro n’existe pas', () async {
    await repository.addText(title: 'Premier', body: 'Texte 1');

    await repository.deleteById(9999);

    expect(await repository.getAll(), hasLength(1));
  });
}
