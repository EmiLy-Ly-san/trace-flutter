import 'package:flutter/material.dart';

// Écran permettant de saisir un titre et un texte
class AddTextPage extends StatelessWidget {
  const AddTextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Écrire un texte')),

      // Ajoute une marge autour des champs
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Champ de saisie du titre
            TextField(
              style: Theme.of(context).textTheme.titleLarge,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Titre'),
            ),

            // Espace entre les deux champs
            const SizedBox(height: 16),

            // Le champ de texte occupe la hauteur restante
            Expanded(
              child: TextField(
                style: Theme.of(context).textTheme.bodyLarge,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,

                // Autorise plusieurs lignes et remplit l’espace disponible
                maxLines: null,
                expands: true,

                // Place le texte en haut du champ
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(hintText: 'Écris ici…'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
