import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

// Écran de création d’un vocal
class AddAudioPage extends StatefulWidget {
  const AddAudioPage({super.key});

  @override
  State<AddAudioPage> createState() => _AddAudioPageState();
}

class _AddAudioPageState extends State<AddAudioPage> {
  // Objet qui contrôle l’enregistrement du micro
  final _recorder = AudioRecorder();

  // Indique si le micro enregistre actuellement
  bool _isRecording = false;

  // Empêche plusieurs actions pendant une opération
  bool _isBusy = false;

  // Chemin du dernier fichier enregistré
  String? _audioPath;

  // Démarre ou arrête l’enregistrement selon son état actuel
  Future<void> _toggleRecording() async {
    if (_isBusy) return;

    setState(() {
      _isBusy = true;
    });

    try {
      if (_isRecording) {
        // Arrête le micro et récupère le chemin du fichier
        final path = await _recorder.stop();

        if (!mounted) return;

        setState(() {
          _isRecording = false;
          _audioPath = path;
        });

        if (path == null) {
          _showError('Aucun fichier audio n’a été créé');
        }
      } else {
        // Vérifie et demande l’autorisation d’utiliser le micro
        final hasPermission = await _recorder.hasPermission();

        if (!mounted) return;

        if (!hasPermission) {
          _showError('L’accès au micro est nécessaire pour enregistrer');
          return;
        }

        // Trouve le dossier temporaire de l’application
        final directory = await getTemporaryDirectory();

        if (!mounted) return;

        // Utilise un nom différent pour chaque enregistrement
        final fileName = 'vocal_${DateTime.now().microsecondsSinceEpoch}.m4a';

        // Démarre un enregistrement au format AAC dans un fichier M4A
        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: '${directory.path}/$fileName',
        );

        if (!mounted) return;

        setState(() {
          _isRecording = true;
          _audioPath = null;
        });
      }
    } catch (error) {
      if (!mounted) return;

      _showError('Impossible de démarrer ou d’arrêter l’enregistrement');
    } finally {
      // Réactive le bouton après l’opération
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  // Affiche un message en bas de l’écran
  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    // Libère le micro lorsque la page est supprimée
    // unawaited lance le nettoyage sans attendre dans dispose
    unawaited(_recorder.dispose());
    super.dispose();
  }

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
              // Zone centrale avec le micro et l’état du vocal
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isRecording ? Icons.mic : Icons.mic_none,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),

                    const SizedBox(height: 24),

                    // Adapte le message à l’état de l’enregistrement
                    Text(
                      _isRecording
                          ? 'Enregistrement en cours'
                          : _audioPath != null
                          ? 'Enregistrement terminé'
                          : 'Prêt à enregistrer',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Désactive temporairement le bouton pendant une opération
              FilledButton.icon(
                onPressed: _isBusy ? null : _toggleRecording,
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                label: Text(
                  _isBusy
                      ? 'Patiente…'
                      : _isRecording
                      ? 'Arrêter'
                      : _audioPath != null
                      ? 'Recommencer'
                      : 'Commencer',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
