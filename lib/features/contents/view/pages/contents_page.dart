import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/add_content_sheet.dart';
import '../widgets/content_card.dart';

// Écran principal des contenus du patient.
class ContentsPage extends StatelessWidget {
  const ContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold fournit la structure de la page :
    // barre du haut, corps et bouton flottant.
    return Scaffold(
      appBar: AppBar(title: const Text('Mes contenus')),

      // Liste temporaire
      body: ListView(
        physics: const ClampingScrollPhysics(), // pas de rebond au définlemenr
        padding: const EdgeInsets.all(16),
        children: [
          ContentCard(
            title: 'Une promenade au calme',
            date: '16 octobre 2026',
            preview:
                'Je suis sortie marcher un moment. Ça m’a permis de '
                'prendre du recul et de profiter de ce qui m’entourait.',

            // Transmet les informations du contenu à la page de détail.
            onOpen: () {
              context.push(
                '/contents/detail',
                extra: <String, Object?>{
                  'title': 'Une promenade au calme',
                  'date': '16 octobre 2026',
                  'text':
                      'Je suis sortie marcher un moment. Ça m’a permis de '
                      'prendre du recul et de profiter de ce qui m’entourait.',
                  'isShared': false,
                },
              );
            },
          ),

          const SizedBox(height: 16),

          ContentCard(
            title: 'Une photo à partager',
            date: '15 octobre 2026',
            imagePath: 'assets/images/TURBOPRUNE-banniere-fb.jpg',
            isShared: true,

            // Ouvre le détail avec la photo et son statut de partage.
            onOpen: () {
              context.push(
                '/contents/detail',
                extra: <String, Object?>{
                  'title': 'Une photo à partager',
                  'date': '15 octobre 2026',
                  'imagePath': 'assets/images/TURBOPRUNE-banniere-fb.jpg',
                  'isShared': true,
                },
              );
            },
          ),

          const SizedBox(height: 80),
        ],
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
