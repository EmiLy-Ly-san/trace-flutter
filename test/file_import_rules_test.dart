import 'package:flutter_test/flutter_test.dart';
import 'package:test/contents/data/file_import_rules.dart';

void main() {
  test('accepte un PDF de taille raisonnable', () {
    expect(checkImportedFile(name: 'bilan.pdf', size: 2 * 1024 * 1024), isNull);
  });

  test('accepte une extension écrite en majuscules', () {
    expect(checkImportedFile(name: 'Compte_rendu.DOCX', size: 1000), isNull);
  });

  test('accepte un fichier dont la taille est inconnue', () {
    expect(checkImportedFile(name: 'notes.txt', size: null), isNull);
  });

  test('accepte un fichier de 20 Mo pile', () {
    expect(
      checkImportedFile(name: 'scan.pdf', size: maxFileSizeInBytes),
      isNull,
    );
  });

  test('refuse un fichier de plus de 20 Mo', () {
    expect(
      checkImportedFile(name: 'scan.pdf', size: maxFileSizeInBytes + 1),
      'Fichier trop volumineux (20 Mo maximum)',
    );
  });

  test('refuse les formats qui ne sont pas des documents', () {
    for (final name in [
      'video.mp4',
      'photo.jpg',
      'archive.zip',
      'sans_extension',
    ]) {
      expect(
        checkImportedFile(name: name, size: 1000),
        'Format non accepté (PDF, Word, ODT, RTF ou TXT)',
        reason: name,
      );
    }
  });
}
