import 'package:drift/drift.dart';

// Les 4 types de contenu possibles
enum ContentType { text, photo, audio, file }

// Une classe qui étend Table décrit une table SQLite
class Contents extends Table {
  // Numéro unique, ajouté automatiquement par la base
  IntColumn get id => integer().autoIncrement()();

  // Titre obligatoire
  TextColumn get title => text()();

  // Type du contenu, enregistré sous forme de texte ("text", "photo"...)
  TextColumn get type => textEnum<ContentType>()();

  // Texte écrit par le patient, vide pour une photo ou un vocal
  TextColumn get body => text().nullable()();

  // Chemin du fichier sur le téléphone (photo, vocal ou fichier)
  TextColumn get filePath => text().nullable()();

  // Date de création
  DateTimeColumn get createdAt => dateTime()();

  // Contenu partagé ou non, privé par défaut
  BoolColumn get isShared => boolean().withDefault(const Constant(false))();
}
