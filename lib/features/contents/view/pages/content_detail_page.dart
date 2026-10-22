import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/add_content_sheet.dart';

class ContentDetailPage extends StatelessWidget {
  const ContentDetailPage({
    super.key,
    required this.title,
    required this.date,
    this.text = '',
    this.imagePath,
    this.isShared = false,
  });

  // Informations du contenu
  final String title;
  final String date;
  final String text;
  final String? imagePath;
  final bool isShared;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
          children: [
            // Icône du format, titre, date et bouton de retour
            Row(
              children: [
                Icon(
                  imagePath != null
                      ? Icons.image_outlined
                      : Icons.edit_outlined,
                  color: primary,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleLarge),
                      Text(date, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                OutlinedButton(
                  // Revient à la page précédente avec GoRouter
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primary,
                    side: BorderSide(color: primary),
                  ),
                  child: const Text('Retour'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            //statut actuel du partage.
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Partagé avec mon thérapeute',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),

                Switch(
                  value: isShared,

                  // Désactivé tant que le partage n’est pas activé
                  onChanged: null,
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath!,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              )
            else
              Text(text, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            builder: (context) => const AddContentSheet(),
          );
        },
        tooltip: 'Ajouter un contenu',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
