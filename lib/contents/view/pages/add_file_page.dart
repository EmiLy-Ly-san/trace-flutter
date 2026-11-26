// Accéder à un fichier sur le téléphone
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../controllers/contents_providers.dart';

// Écran de confirmation d’un fichier importé, avec son titre
class AddFilePage extends ConsumerStatefulWidget {
  const AddFilePage({super.key, required this.file});

  // PlatformFile représente le fichier renvoyé par file_picker
  final PlatformFile file;

  @override
  ConsumerState<AddFilePage> createState() => _AddFilePageState();
}

class _AddFilePageState extends ConsumerState<AddFilePage> {
  // Titre proposé : le nom du fichier sans son extension
  late final _titleController = TextEditingController(
    text: p.basenameWithoutExtension(widget.file.name),
  );

  // Empêche d’enregistrer deux fois pendant une opération
  bool _isBusy = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Copie le fichier dans un dossier sûr, puis le range dans la base
  Future<void> _save() async {
    final title = _titleController.text.trim();

    if (_isBusy) return;

    // Sans titre, on prévient et on n’enregistre rien
    if (title.isEmpty) {
      _showError('Ajoute un titre');
      return;
    }

    setState(() {
      _isBusy = true;
    });

    try {
      // Dossier privé de l’application, qui n’est pas nettoyé par le système
      final documents = await getApplicationDocumentsDirectory();
      final folder = Directory(p.join(documents.path, 'files'));
      await folder.create(recursive: true);

      // Le numéro au début évite d’écraser un fichier qui a le même nom
      final fileName =
          '${DateTime.now().microsecondsSinceEpoch}_${widget.file.name}';
      final newPath = p.join(folder.path, fileName);

      // Recopie le contenu du fichier morceau par morceau
      // Sur Android, le fichier choisi n’a pas toujours de chemin direct
      final copy = File(newPath).openWrite();
      await copy.addStream(widget.file.readAsByteStream());
      await copy.close();

      // Range le fichier dans la base
      await ref
          .read(contentsRepositoryProvider)
          .addFile(title: title, filePath: newPath);

      if (!mounted) return;

      // Revient à l’écran précédent
      context.pop();
    } catch (error) {
      if (!mounted) return;

      _showError('Impossible d’enregistrer le fichier');
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Importer un fichier'),

        // Bouton grisé pendant l’enregistrement
        actions: [
          TextButton(
            onPressed: _isBusy ? null : _save,
            child: const Text('Enregistrer'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Champ de saisie du titre
              TextField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(hintText: 'Titre'),
              ),

              const SizedBox(height: 24),

              // Rappelle quel fichier a été choisi
              Row(
                children: [
                  Icon(
                    Icons.insert_drive_file_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.file.name,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
