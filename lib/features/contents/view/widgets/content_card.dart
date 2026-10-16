import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.title,
    required this.date,
    this.preview = '',
    this.imagePath,
    this.isShared = false,
    this.onOpen,
    this.onDelete,
  });

  // Informations affichées dans la carte.
  final String title;
  final String date;
  final String preview;
  // Chemin d’une image intégrée au projet.
  // Sans image, la carte affiche l’aperçu texte.
  final String? imagePath;
  final bool isShared;

  // Actions facultatives, qui seront branchées plus tard.
  final VoidCallback? onOpen;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    // Style des boutons ronds d’agrandissement et de suppression.
    final actionStyle = IconButton.styleFrom(
      foregroundColor: primary,
      disabledForegroundColor: primary,
      side: BorderSide(color: primary),
      shape: const CircleBorder(),

      // Réduit l’espace entre l’icône et le cercle.
      padding: const EdgeInsets.all(6),
      minimumSize: const Size(32, 32),

      // Conserve une zone tactile plus grande que le cercle visible.
      tapTargetSize: MaterialTapTargetSize.padded,
    );

    return Card(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge à gauche et bouton d’agrandissement à droite.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    // Fond violet uniquement pour le statut partagé.
                    color: isShared ? primary : Colors.transparent,

                    // Même violet pour le contour et le texte du statut privé.
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    isShared ? 'Partagé' : 'Privé',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isShared ? Colors.white : primary,
                    ),
                  ),
                ),
                IconButton.outlined(
                  onPressed: onOpen,
                  tooltip: 'Ouvrir le contenu',
                  icon: const Icon(Icons.open_in_full, size: 18),
                  style: actionStyle,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Icône du format texte et titre du contenu.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  imagePath != null
                      ? Icons.image_outlined
                      : Icons.edit_outlined,
                  color: primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Affiche une photo ou un aperçu du texte selon le contenu
            if (imagePath != null)
              ClipRRect(
                // Arrondit les coins de la photo
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  // Format paysage, comme dans la maquette
                  aspectRatio: 4 / 3,
                  child: Image.asset(imagePath!, fit: BoxFit.cover),
                ),
              )
            else
              // Aperçu du texte en italique
              Text(
                preview,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

            const SizedBox(height: 12),

            // Date sous l’aperçu.
            Text(date, style: theme.textTheme.bodyLarge),

            const SizedBox(height: 8),

            // Suppression en bas à droite.
            Align(
              alignment: Alignment.centerRight,
              child: IconButton.outlined(
                onPressed: onDelete,
                tooltip: 'Supprimer le contenu',
                icon: const Icon(Icons.delete_outline, size: 20),
                style: actionStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
