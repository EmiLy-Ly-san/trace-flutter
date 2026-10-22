import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
              onTap: () async {
                try {
                  // Propose de choisir une photo ou d’en prendre une
                  final source = await showDialog<ImageSource>(
                    context: context,
                    builder: (dialogContext) {
                      return SimpleDialog(
                        title: const Text('Ajouter une photo'),
                        children: [
                          SimpleDialogOption(
                            // Ferme le dialogue en renvoyant le choix galerie
                            onPressed: () {
                              Navigator.pop(dialogContext, ImageSource.gallery);
                            },
                            child: const ListTile(
                              leading: Icon(Icons.photo_library_outlined),
                              title: Text('Choisir dans la galerie'),
                            ),
                          ),
                          SimpleDialogOption(
                            // Ferme le dialogue en renvoyant le choix appareil photo
                            onPressed: () {
                              Navigator.pop(dialogContext, ImageSource.camera);
                            },
                            child: const ListTile(
                              leading: Icon(Icons.photo_camera_outlined),
                              title: Text('Prendre une photo'),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  // Arrête si le panneau a été fermé pendant l’attente
                  if (!context.mounted) return;

                  // Si l’utilisateur annule le choix, conserve le panneau
                  if (source == null) return;

                  // Ouvre la galerie ou l’appareil photo selon le choix
                  final photo = await ImagePicker().pickImage(source: source);

                  // Arrête si le panneau a été fermé pendant l’attente
                  if (!context.mounted) return;

                  // Si l’utilisateur annule, conserve le panneau sans naviguer
                  if (photo == null) return;

                  // Récupère le routeur avant de fermer le panneau
                  final router = GoRouter.of(context);

                  // Ferme le panneau de choix des formats
                  Navigator.pop(context);

                  // Ouvre l’aperçu avec la photo sélectionnée
                  router.push('/contents/add-photo', extra: photo);
                } catch (error) {
                  // Vérifie que le panneau est encore affiché
                  if (!context.mounted) return;

                  // Informe l’utilisateur si la photo ne peut pas être récupérée
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Impossible de récupérer la photo'),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.mic_none),
              title: const Text('Enregistrer un vocal'),
              onTap: () {
                // Récupère le routeur avant de fermer le panneau
                final router = GoRouter.of(context);

                // Ferme le panneau de choix des formats
                Navigator.pop(context);

                // Ouvre l’écran d’enregistrement
                router.push('/contents/add-audio');
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
