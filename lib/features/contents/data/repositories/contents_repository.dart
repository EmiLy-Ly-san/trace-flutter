import 'package:drift/drift.dart';

import '../../../../core/storage/app_database.dart';
import '../local/contents_table.dart';

// Le guichet des contenus : les écrans passeront par lui
class ContentsRepository {
  // On lui donne la base au moment de le créer
  ContentsRepository(this._database);

  // Le _ au début veut dire : utilisable seulement dans ce fichier
  final AppDatabase _database;

  // Range un nouveau texte dans la base
  Future<void> addText({required String title, required String body}) async {
    await _database
        .into(_database.contents)
        .insert(
          ContentsCompanion.insert(
            title: title,
            type: ContentType.text,
            createdAt: DateTime.now(),
            body: Value(body),
          ),
        );
  }

  // Lit tous les contenus rangés dans la base
  Future<List<Content>> getAll() {
    return _database.select(_database.contents).get();
  }

  // Lit les contenus et prévient à chaque changement de la base
  // Les plus récents sont en premier
  Stream<List<Content>> watchAll() {
    final query = _database.select(_database.contents)
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);

    return query.watch();
  }
}
