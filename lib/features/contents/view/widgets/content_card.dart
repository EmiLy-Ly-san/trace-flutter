import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key, //va permettre d'identifier l'élément; SUPER : classe parente
    required this.title,
    required this.date,
    required this.preview,
    this.isShared = false,
  });

  // Informations fournies à la carte lors de son utilisation
  final String title;
  final String date;
  final String preview;

  // Un contenu est privé par défaut
  final bool isShared;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,

      // Arrondis et contour de la carte.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre du contenu
            Text(
              title,
              style: theme.textTheme.titleLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Date affichée sous le titre
            Text(date, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 12),

            // Aperçu limité à trois lignes
            Text(
              preview,
              style: theme.textTheme.bodyLarge,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Icône et libellé du statut de partage
            Row(
              children: [
                Icon(
                  isShared ? Icons.people_outline : Icons.lock_outline,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  isShared ? 'Partagé' : 'Privé',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
