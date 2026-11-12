import 'dart:io';

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

  // Range un nouveau vocal dans la base
  // filePath est l'endroit où le fichier est gardé sur le téléphone
  Future<void> addAudio({
    required String title,
    required String filePath,
  }) async {
    await _database
        .into(_database.contents)
        .insert(
          ContentsCompanion.insert(
            title: title,
            type: ContentType.audio,
            createdAt: DateTime.now(),
            filePath: Value(filePath),
          ),
        );
  }

  // Supprime le contenu qui a ce numéro (id), et son fichier s'il en a un
  Future<void> deleteById(int id) async {
    // Lit d'abord la ligne pour connaître le chemin de son fichier
    final content = await (_database.select(
      _database.contents,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    // Rien à supprimer si ce numéro n'existe pas
    if (content == null) return;

    // Supprime d'abord la ligne dans la base
    await (_database.delete(
      _database.contents,
    )..where((table) => table.id.equals(id))).go();

    // Puis supprime le fichier du téléphone, s'il existe
    final path = content.filePath;
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
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
