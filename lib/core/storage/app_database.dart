// Fichier écrit par nous : il définit la base locale et ses tables.
// Son fichier généré, app_database.g.dart, est créé par Drift.

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Importe notre table Contents pour pouvoir la déclarer dans la base
import '../../features/contents/data/local/contents_table.dart';

part 'app_database.g.dart';

// Base locale de l'application
// AppDatabase est notre classe
// _$AppDatabase sera généré par Drift
// tables: [Contents] indique à Drift quelles tables créer dans la base
@DriftDatabase(tables: [Contents])
class AppDatabase extends _$AppDatabase {
  // Sans paramètre, la base ouvre le vrai fichier trace.db
  // Les tests peuvent fournir une base en mémoire à la place
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  // Version du schéma de la base
  // Ce numéro augmentera lorsque des tables seront ajoutées
  @override
  int get schemaVersion => 1;
}

// Ouvre le fichier SQLite dans le dossier privé de l'application
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Dossier fourni par le package path_provider
    final folder = await getApplicationDocumentsDirectory();

    // Fichier conservé sur le téléphone
    final file = File(p.join(folder.path, 'trace.db'));

    // NativeDatabase vient de Drift et ouvre ce fichier
    return NativeDatabase(file);
  });
}
