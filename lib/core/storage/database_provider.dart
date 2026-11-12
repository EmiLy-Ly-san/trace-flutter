import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

// Provider Riverpod : donne accès à la base depuis n'importe quel écran
// Riverpod crée AppDatabase une seule fois et réutilise cette instance
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  // Ferme proprement la base quand le provider n'est plus utilisé
  ref.onDispose(database.close);

  return database;
});
