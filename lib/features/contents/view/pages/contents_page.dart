import 'package:flutter/material.dart';

import '../widgets/add_content_sheet.dart';
import '../widgets/content_card.dart';

// Écran des contenus du patient (dashbaord patient)
class ContentsPage extends StatelessWidget {
  const ContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes contenus')),
      // Liste temporaire pour construire l’interface avant la BDD.
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const ClampingScrollPhysics(),

        /// Permet le défilement sans étirer le contenu aux extrémités.
        children: const [
          ContentCard(
            title: 'Une promenade au calme',
            date: '16 octobre 2026',
            preview:
                'Je suis sortie marcher un moment. Ça m’a permis de '
                'prendre du recul et de profiter de ce qui m’entourait.',
          ),

          SizedBox(height: 16),

          ContentCard(
            title: 'À aborder pendant la séance',
            date: '15 octobre 2026',
            preview:
                'J’aimerais revenir sur ce moment et sur les émotions '
                'que j’ai ressenties.',
            isShared: true,
          ),

          // Garde de l’espace sous la dernière carte pour le bouton « + ».
          SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            // <void> indique qu’on n’attend aucune valeur en retour
            context: context,
            showDragHandle: true, // Affiche la petite poignée
            isScrollControlled:
                true, // Permet au panneau de dépasser la hauteur limitée si besoin
            builder: (context) =>
                const AddContentSheet(), //construit le contenu du panneau
          );
        },
        tooltip: 'Ajouter un contenu',
        child: const Icon(Icons.add), //’icône choisie : add -> « +»
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
