import 'package:path/path.dart' as p;

// Formats de documents acceptés à l’import
// Les photos et les vocaux ont déjà leurs propres boutons
const allowedFileExtensions = ['pdf', 'doc', 'docx', 'odt', 'rtf', 'txt'];

// Taille maximale d’un fichier importé : 20 Mo
const maxFileSizeInBytes = 20 * 1024 * 1024;

// Vérifie un fichier avant de l’importer
// Renvoie le message à afficher s’il est refusé, ou null s’il est accepté
// size peut être inconnue (null) : le fichier est alors accepté
String? checkImportedFile({required String name, required int? size}) {
  // Extension sans le point et en minuscules : « Bilan.PDF » donne « pdf »
  final extension = p.extension(name).replaceFirst('.', '').toLowerCase();

  if (!allowedFileExtensions.contains(extension)) {
    return 'Format non accepté (PDF, Word, ODT, RTF ou TXT)';
  }

  if (size != null && size > maxFileSizeInBytes) {
    return 'Fichier trop volumineux (20 Mo maximum)';
  }

  return null;
}
