import 'package:flutter/material.dart';

class ContentsPage extends StatelessWidget {
  const ContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes contenus')),
      body: const Center(child: Text('Aucun contenu pour le moment')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // On ajoutera ici l’ouverture du menu :
          // texte, photo, vocal ou fichier.
        },
        tooltip: 'Ajouter un contenu',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
