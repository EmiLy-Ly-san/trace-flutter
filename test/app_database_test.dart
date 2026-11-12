import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test/core/storage/app_database.dart';
import 'package:test/features/contents/data/local/contents_table.dart';

void main() {
  // Base créée avant chaque test, puis fermée après
  late AppDatabase database;

  setUp(() {
    // NativeDatabase.memory() crée une base temporaire, sans fichier
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('enregistre un contenu texte puis le relit', () async {
    // Insère une ligne, Drift renvoie le numéro (id) qui lui est donné
    final id = await database
        .into(database.contents)
        .insert(
          ContentsCompanion.insert(
            title: 'Une promenade au calme',
            type: ContentType.text,
            createdAt: DateTime(2026, 10, 16),
            body: const Value('Je suis sortie marcher un moment.'),
          ),
        );

    // Relit toutes les lignes de la table
    final rows = await database.select(database.contents).get();

    expect(rows, hasLength(1));
    expect(rows.first.id, id);
    expect(rows.first.title, 'Une promenade au calme');
    expect(rows.first.type, ContentType.text);
    expect(rows.first.body, 'Je suis sortie marcher un moment.');

    // Valeurs par défaut : pas de fichier, contenu privé
    expect(rows.first.filePath, isNull);
    expect(rows.first.isShared, false);
  });
}
