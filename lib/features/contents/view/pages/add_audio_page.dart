import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
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

  // Objet qui contrôle la lecture du fichier audio
  final _player = AudioPlayer();

  // Écoute les changements d’état du lecteur
  StreamSubscription<PlayerState>? _playerSubscription;

  // Indique si le micro enregistre actuellement
  bool _isRecording = false;

  // Indique si le vocal est en cours de lecture
  bool _isPlaying = false;

  // Empêche plusieurs actions pendant une opération
  bool _isBusy = false;

  // Chemin du dernier fichier enregistré
  String? _audioPath;

  // Déclenche une mise à jour chaque seconde
  Timer? _timer;

  // Durée écoulée en secondes
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();

    // Actualise le bouton lorsque la lecture démarre ou se termine
    _playerSubscription = _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  // Formate la durée sous la forme minutes:secondes
  String get _formattedDuration {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

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

        // Fige la durée lorsque l’enregistrement s’arrête
        _timer?.cancel();

        if (!mounted) return;

        setState(() {
          _isRecording = false;
          _audioPath = path;
        });

        if (path == null) {
          _showError('Aucun fichier audio n’a été créé');
        }
      } else {
        // Arrête une éventuelle lecture avant d’utiliser le micro
        await _player.stop();

        if (!mounted) return;

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
          _elapsedSeconds = 0;
        });

        // Annule un éventuel ancien compteur
        _timer?.cancel();

        // Actualise la durée chaque seconde
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;

          setState(() {
            _elapsedSeconds++;
          });
        });
      }
    } catch (error) {
      if (!mounted) return;

      _showError('Impossible de démarrer ou d’arrêter l’enregistrement');
    } finally {
      // Réactive les boutons après l’opération
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  // Démarre ou arrête la lecture du vocal
  Future<void> _togglePlayback() async {
    final path = _audioPath;

    if (_isBusy || _isRecording || path == null) return;

    setState(() {
      _isBusy = true;
    });

    try {
      if (_isPlaying) {
        // Arrête la lecture et revient au début du vocal
        await _player.stop();
      } else {
        // Lit le fichier audio enregistré sur le téléphone
        await _player.play(DeviceFileSource(path));
      }
    } catch (error) {
      if (!mounted) return;

      _showError('Impossible de lire le vocal');
    } finally {
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
    // Arrête le compteur lorsque la page est supprimée
    _timer?.cancel();

    // Arrête l’écoute des changements d’état du lecteur
    final subscription = _playerSubscription;

    if (subscription != null) {
      unawaited(subscription.cancel());
    }

    // Libère le lecteur et le micro lorsque la page est supprimée
    // unawaited lance le nettoyage sans attendre dans dispose
    unawaited(_player.dispose());
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
              // Zone centrale avec le micro, la durée et l’état du vocal
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

                    // Affiche la durée totale enregistrée
                    Text(
                      _formattedDuration,
                      style: theme.textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 12),

                    // Adapte le message à l’état de l’enregistrement
                    Text(
                      _isRecording
                          ? 'Enregistrement en cours'
                          : _isPlaying
                          ? 'Lecture en cours'
                          : _audioPath != null
                          ? 'Enregistrement terminé'
                          : 'Prêt à enregistrer',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Affiche la lecture uniquement lorsqu’un vocal est disponible
              if (_audioPath != null && !_isRecording) ...[
                OutlinedButton.icon(
                  onPressed: _isBusy ? null : _togglePlayback,
                  icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Arrêter la lecture' : 'Écouter'),
                ),

                const SizedBox(height: 12),
              ],

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
