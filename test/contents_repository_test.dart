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

  test('enregistre une photo avec le chemin de son fichier', () async {
    await repository.addPhoto(
      title: 'Ma photo',
      filePath: '/chemin/vers/photo.jpg',
    );

    final contents = await repository.getAll();

    expect(contents, hasLength(1));
    expect(contents.first.title, 'Ma photo');
    expect(contents.first.type, ContentType.photo);
    expect(contents.first.filePath, '/chemin/vers/photo.jpg');
    expect(contents.first.body, isNull);
  });

  test('supprime aussi le fichier d’une photo', () async {
    // Crée un vrai fichier temporaire pour le test
    final folder = await Directory.systemTemp.createTemp('photo_test');
    final file = File('${folder.path}/photo.jpg');
    await file.writeAsString('fausse photo');

    await repository.addPhoto(title: 'Ma photo', filePath: file.path);
    final saved = (await repository.getAll()).single;

    await repository.deleteById(saved.id);

    // La ligne et le fichier ont disparu
    expect(await repository.getAll(), isEmpty);
    expect(await file.exists(), isFalse);

    await folder.delete(recursive: true);
  });

  test('enregistre un fichier importé avec son chemin', () async {
    await repository.addFile(
      title: 'Mon bilan',
      filePath: '/chemin/vers/123_bilan.pdf',
    );

    final contents = await repository.getAll();

    expect(contents, hasLength(1));
    expect(contents.first.title, 'Mon bilan');
    expect(contents.first.type, ContentType.file);
    expect(contents.first.filePath, '/chemin/vers/123_bilan.pdf');
    expect(contents.first.body, isNull);
  });

  test('supprime aussi la copie d’un fichier importé', () async {
    // Crée un vrai fichier temporaire pour le test
    final folder = await Directory.systemTemp.createTemp('file_test');
    final file = File('${folder.path}/123_bilan.pdf');
    await file.writeAsString('faux document');

    await repository.addFile(title: 'Mon bilan', filePath: file.path);
    final saved = (await repository.getAll()).single;

    await repository.deleteById(saved.id);

    // La ligne et le fichier ont disparu
    expect(await repository.getAll(), isEmpty);
    expect(await file.exists(), isFalse);

    await folder.delete(recursive: true);
  });

  test('marque un contenu comme partagé puis privé', () async {
    await repository.addText(title: 'Premier', body: 'Texte 1');
    final saved = (await repository.getAll()).single;
    expect(saved.isShared, isFalse);

    await repository.updateShared(id: saved.id, isShared: true);
    expect((await repository.getAll()).single.isShared, isTrue);

    await repository.updateShared(id: saved.id, isShared: false);
    expect((await repository.getAll()).single.isShared, isFalse);
  });

  test('ne partage que le contenu demandé', () async {
    await repository.addText(title: 'Premier', body: 'Texte 1');
    await repository.addText(title: 'Deuxième', body: 'Texte 2');
    final first = (await repository.getAll()).firstWhere(
      (content) => content.title == 'Premier',
    );

    await repository.updateShared(id: first.id, isShared: true);

    final contents = await repository.getAll();
    final second = contents.firstWhere(
      (content) => content.title == 'Deuxième',
    );
    expect(contents.firstWhere((c) => c.id == first.id).isShared, isTrue);
    expect(second.isShared, isFalse);
  });

  test('ne supprime rien si le numéro n’existe pas', () async {
    await repository.addText(title: 'Premier', body: 'Texte 1');

    await repository.deleteById(9999);

    expect(await repository.getAll(), hasLength(1));
  });
}
