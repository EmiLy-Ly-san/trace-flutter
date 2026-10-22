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

  // Écoute la progression de la lecture
  StreamSubscription<Duration>? _positionSubscription;

  // Écoute la durée réelle du fichier audio
  StreamSubscription<Duration>? _durationSubscription;

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

  // Position actuelle pendant la lecture
  Duration _playbackPosition = Duration.zero;

  // Durée réelle du fichier audio
  Duration _playbackDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Actualise le bouton lorsque la lecture démarre ou se termine
    _playerSubscription = _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state == PlayerState.playing;

        // Affiche la fin du vocal lorsque la lecture est terminée
        if (state == PlayerState.completed) {
          _playbackPosition = _playbackDuration;
        }
      });
    });

    // Actualise la position à partir des informations du lecteur
    _positionSubscription = _player.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        _playbackPosition = position;
      });
    });

    // Récupère la durée réelle du fichier lors de son chargement
    _durationSubscription = _player.onDurationChanged.listen((duration) {
      if (!mounted) return;

      setState(() {
        _playbackDuration = duration;
      });
    });
  }

  // Formate une durée sous la forme minutes:secondes
  String _formatDuration(Duration duration) {
    final minutes = (duration.inSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  // Formate la durée écoulée pendant l’enregistrement
  String get _formattedDuration {
    return _formatDuration(Duration(seconds: _elapsedSeconds));
  }

  // Utilise la durée réelle du fichier dès qu’elle est disponible
  String get _formattedPlaybackDuration {
    if (_playbackDuration > Duration.zero) {
      return _formatDuration(_playbackDuration);
    }

    return _formattedDuration;
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
          _playbackPosition = Duration.zero;
          _playbackDuration = Duration.zero;
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

        if (!mounted) return;

        setState(() {
          _playbackPosition = Duration.zero;
        });
      } else {
        // Repart du début à chaque nouvelle écoute
        setState(() {
          _playbackPosition = Duration.zero;
        });

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
    final playerSubscription = _playerSubscription;

    if (playerSubscription != null) {
      unawaited(playerSubscription.cancel());
    }

    // Arrête l’écoute de la position et de la durée
    final positionSubscription = _positionSubscription;
    final durationSubscription = _durationSubscription;

    if (positionSubscription != null) {
      unawaited(positionSubscription.cancel());
    }

    if (durationSubscription != null) {
      unawaited(durationSubscription.cancel());
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

                    // Affiche le compteur pendant l’enregistrement
                    // Puis la position de lecture et la durée totale
                    Text(
                      _audioPath != null && !_isRecording
                          ? '${_formatDuration(_playbackPosition)}'
                                ' / $_formattedPlaybackDuration'
                          : _formattedDuration,
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
