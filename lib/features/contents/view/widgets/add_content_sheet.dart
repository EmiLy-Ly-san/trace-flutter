import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Panneau proposant les différents formats de contenu
class AddContentSheet extends StatelessWidget {
  const AddContentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //Safearea = évite que le contenu soit masqué par les zones système,comme la navbar du tel
      child: SingleChildScrollView(
        //Pour faire défiler le contenu sur un petit écran
        padding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          24,
        ), //gauche, haut, droite, bas
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // La colonne prend seulement la hauteur nécessaire
          crossAxisAlignment: CrossAxisAlignment
              .start, // Alignement au début de l’axe horizontal
          children: [
            Text(
              'Ajouter un contenu',
              style: Theme.of(
                context,
              ).textTheme.titleLarge, // Récupèrer le style de AppTheme
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Écrire un texte'),
              onTap: () {
                // Récupère le routeur avant de fermer le panneau
                final router = GoRouter.of(context);

                // Ferme le panneaur
                Navigator.pop(context);

                // Ouvre l’éditeur en conservant le dashboard en dessous
                router.push('/contents/add-text');
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Ajouter une photo'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mic_none),
              title: const Text('Enregistrer un vocal'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Importer un fichier'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
