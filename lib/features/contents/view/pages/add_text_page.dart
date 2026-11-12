import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/contents_providers.dart';

// Écran permettant de saisir un titre et un texte
class AddTextPage extends ConsumerStatefulWidget {
  const AddTextPage({super.key});

  @override
  ConsumerState<AddTextPage> createState() => _AddTextPageState();
}

class _AddTextPageState extends ConsumerState<AddTextPage> {
  // Chaque controller retient ce qui est écrit dans un champ
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  // Libère la mémoire quand l'écran est fermé
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  // Enregistre le texte dans la base, puis ferme l'écran
  Future<void> _save() async {
    final title = _titleController.text.trim();

    // Sans titre, on prévient et on n'enregistre rien
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ajoute un titre')));
      return;
    }

    // On demande le guichet, puis on lui donne le texte à ranger
    await ref
        .read(contentsRepositoryProvider)
        .addText(title: title, body: _bodyController.text);

    // Si l'écran a été fermé entre-temps, on s'arrête
    if (!mounted) return;

    // Revient à l'écran précédent
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Écrire un texte'),

        // Bouton en haut à droite pour enregistrer
        actions: [
          TextButton(onPressed: _save, child: const Text('Enregistrer')),
        ],
      ),

      // Ajoute une marge autour des champs
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Champ de saisie du titre
            TextField(
              controller: _titleController,
              style: Theme.of(context).textTheme.titleLarge,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Titre'),
            ),

            // Espace entre les deux champs
            const SizedBox(height: 16),

            // Le champ de texte occupe la hauteur restante
            Expanded(
              child: TextField(
                controller: _bodyController,
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
