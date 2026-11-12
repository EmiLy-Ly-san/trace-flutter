import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test/core/storage/app_database.dart';
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

  test('ne supprime rien si le numéro n’existe pas', () async {
    await repository.addText(title: 'Premier', body: 'Texte 1');

    await repository.deleteById(9999);

    expect(await repository.getAll(), hasLength(1));
  });
}
