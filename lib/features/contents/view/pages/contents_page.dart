import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/storage/app_database.dart';
import '../../controllers/contents_providers.dart';
import '../../data/local/contents_table.dart';
import '../widgets/add_content_sheet.dart';
import '../widgets/content_card.dart';

// Écran principal des contenus du patient.
// ConsumerWidget : un écran qui peut écouter Riverpod.
class ContentsPage extends ConsumerWidget {
  const ContentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On écoute la liste : l'écran se redessine à chaque changement.
    final contents = ref.watch(contentsProvider);

    // Scaffold fournit la structure de la page :
    // barre du haut, corps et bouton flottant.
    return Scaffold(
      appBar: AppBar(title: const Text('Mes contenus')),

      // when() choisit quoi afficher selon l'état de la liste.
      body: contents.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(child: Text('Erreur de lecture')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Aucun contenu pour le moment'));
          }

          // Une carte par contenu de la base.
          return ListView.separated(
            physics: const ClampingScrollPhysics(), // pas de rebond
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final content = items[index];
              final date = _formatDate(content.createdAt);

              return ContentCard(
                title: content.title,
                date: date,
                preview: content.body ?? '',
                isAudio: content.type == ContentType.audio,
                isShared: content.isShared,

                // Demande confirmation avant de supprimer.
                onDelete: () => _confirmDelete(context, ref, content),

                // Transmet les informations du contenu à la page de détail.
                onOpen: () {
                  context.push(
                    '/contents/detail',
                    extra: <String, Object?>{
                      'title': content.title,
                      'date': date,
                      'text': content.body ?? '',

                      // Le détail a besoin du fichier pour lire un vocal.
                      'audioPath': content.type == ContentType.audio
                          ? content.filePath
                          : null,
                      'isShared': content.isShared,
                    },
                  );
                },
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        // Cette fonction s’exécute au clic sur le bouton.
        onPressed: () {
          // Ouvre un panneau par-dessus la page, depuis le bas.
          // <void> indique qu’on n’attend aucune valeur en retour.
          showModalBottomSheet<void>(
            context: context,

            // Affiche la petite poignée en haut du panneau.
            showDragHandle: true,

            // Permet au panneau de dépasser la hauteur limitée
            // par défaut, si son contenu en a besoin.
            isScrollControlled: true,

            // Construit le contenu du panneau.
            builder: (context) => const AddContentSheet(),
          );
        },

        // Libellé utilisé notamment pour l’accessibilité
        // et affiché lors d’un appui prolongé.
        tooltip: 'Ajouter un contenu',

        // Icône visible dans le bouton.
        child: const Icon(Icons.add),
      ),

      // Place le bouton en bas au centre de la page.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// Demande confirmation, puis supprime le contenu.
Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  Content content,
) async {
  // showDialog affiche une petite fenêtre au centre de l'écran.
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Supprimer ce contenu ?'),
      content: Text('« ${content.title} » sera supprimé de ce téléphone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Supprimer'),
        ),
      ],
    ),
  );

  // Si on n'a pas appuyé sur « Supprimer », on s'arrête.
  if (confirmed != true) return;

  await ref.read(contentsRepositoryProvider).deleteById(content.id);
}

// Transforme une date en texte français, par exemple « 16 octobre 2026 ».
String _formatDate(DateTime date) {
  const months = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
