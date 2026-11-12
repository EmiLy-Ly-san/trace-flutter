import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/database_provider.dart';
import '../data/repositories/contents_repository.dart';

// Donne accès au guichet des contenus depuis n'importe quel écran
final contentsRepositoryProvider = Provider<ContentsRepository>((ref) {
  // On récupère la base grâce au provider qu'on a déjà fait
  final database = ref.watch(appDatabaseProvider);

  // On crée le guichet en lui donnant la base
  return ContentsRepository(database);
});
