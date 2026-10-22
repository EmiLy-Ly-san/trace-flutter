import 'package:flutter/material.dart';

// Écran de création d’un vocal
class AddAudioPage extends StatelessWidget {
  const AddAudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Enregistrer un vocal')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Zone centrale avec le micro et la durée
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mic_none,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),

                    const SizedBox(height: 24),

                    // Durée affichée avant le début de l’enregistrement
                    Text('00:00', style: theme.textTheme.headlineSmall),

                    const SizedBox(height: 12),

                    Text(
                      'Prêt à enregistrer',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // Bouton désactivé tant que le micro n’est pas branché
              FilledButton.icon(
                onPressed: null,
                icon: const Icon(Icons.mic),
                label: const Text('Commencer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
