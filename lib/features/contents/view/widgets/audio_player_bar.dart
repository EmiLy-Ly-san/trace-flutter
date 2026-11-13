import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// Petit lecteur pour écouter un vocal enregistré sur le téléphone
class AudioPlayerBar extends StatefulWidget {
  const AudioPlayerBar({super.key, required this.filePath});

  // Endroit où le fichier du vocal est gardé
  final String filePath;

  @override
  State<AudioPlayerBar> createState() => _AudioPlayerBarState();
}

class _AudioPlayerBarState extends State<AudioPlayerBar> {
  // Objet qui contrôle la lecture du fichier audio
  final _player = AudioPlayer();

  // Écoute les changements d’état du lecteur
  StreamSubscription<PlayerState>? _stateSubscription;

  // Écoute la progression de la lecture
  StreamSubscription<Duration>? _positionSubscription;

  // Écoute la durée réelle du fichier audio
  StreamSubscription<Duration>? _durationSubscription;

  // Indique si le vocal est en cours de lecture
  bool _isPlaying = false;

  // Position actuelle et durée totale du vocal
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Actualise le bouton lorsque la lecture démarre, s’arrête ou se termine
    _stateSubscription = _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state == PlayerState.playing;

        // Affiche la fin du vocal lorsque la lecture est terminée
        if (state == PlayerState.completed) {
          _position = _duration;
        }
      });
    });

    _positionSubscription = _player.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        _position = position;
      });
    });

    _durationSubscription = _player.onDurationChanged.listen((duration) {
      if (!mounted) return;

      setState(() {
        _duration = duration;
      });
    });
  }

  // Formate une durée sous la forme minutes:secondes
  String _formatDuration(Duration duration) {
    final minutes = (duration.inSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  // Démarre ou arrête la lecture du vocal
  Future<void> _togglePlayback() async {
    try {
      if (_isPlaying) {
        // Arrête la lecture et revient au début du vocal
        await _player.stop();

        if (!mounted) return;

        setState(() {
          _position = Duration.zero;
        });
      } else {
        // Repart du début à chaque nouvelle écoute
        setState(() {
          _position = Duration.zero;
        });

        // Lit le fichier audio enregistré sur le téléphone
        await _player.play(DeviceFileSource(widget.filePath));
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de lire le vocal')),
      );
    }
  }

  @override
  void dispose() {
    // Arrête l’écoute des changements du lecteur
    final stateSubscription = _stateSubscription;
    final positionSubscription = _positionSubscription;
    final durationSubscription = _durationSubscription;

    if (stateSubscription != null) {
      unawaited(stateSubscription.cancel());
    }

    if (positionSubscription != null) {
      unawaited(positionSubscription.cancel());
    }

    if (durationSubscription != null) {
      unawaited(durationSubscription.cancel());
    }

    // Libère le lecteur lorsque la page est supprimée
    // unawaited lance le nettoyage sans attendre dans dispose
    unawaited(_player.dispose());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Bouton lecture / arrêt
        IconButton.filled(
          onPressed: _togglePlayback,
          tooltip: _isPlaying ? 'Arrêter la lecture' : 'Écouter',
          icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
        ),

        const SizedBox(width: 16),

        // Position actuelle et durée totale, comme sur l’écran d’enregistrement
        Text(
          _duration > Duration.zero
              ? '${_formatDuration(_position)} / ${_formatDuration(_duration)}'
              : _formatDuration(_position),
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
