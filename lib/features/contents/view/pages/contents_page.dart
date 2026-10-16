import 'package:flutter/material.dart';

import '../widgets/add_content_sheet.dart';

// Écran des contenus du patient (dashbaord patient)
class ContentsPage extends StatelessWidget {
  const ContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes contenus')),
      body: const Center(child: Text('Aucun contenu pour le moment')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>( // <void> indique qu’on n’attend aucune valeur en retour
            context: context,
            showDragHandle: true, // Affiche la petite poignée
            isScrollControlled: true, // Permet au panneau de dépasser la hauteur limitée si besoin
            builder: (context) => const AddContentSheet(), //construit le contenu du panneau
          );
        },
        tooltip: 'Ajouter un contenu',
        child: const Icon(Icons.add), //’icône choisie : add -> « +»
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
