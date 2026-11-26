// Accéder à un fichier sur le téléphone
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../controllers/contents_providers.dart';

// Écran d’aperçu d’une photo sélectionnée, avec son titre
class AddPhotoPage extends ConsumerStatefulWidget {
  const AddPhotoPage({super.key, required this.photo});

  // XFile représente le fichier renvoyé par image_picker
  final XFile photo;

  @override
  ConsumerState<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends ConsumerState<AddPhotoPage> {
  // Retient le titre écrit par le patient
  final _titleController = TextEditingController();

  // Empêche d’enregistrer deux fois pendant une opération
  bool _isBusy = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Copie la photo dans un dossier sûr, puis la range dans la base
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
      final folder = Directory(p.join(documents.path, 'photos'));
      await folder.create(recursive: true);

      // Nom unique, en gardant l’extension d’origine (.jpg, .png…)
      final fileName =
          'photo_${DateTime.now().microsecondsSinceEpoch}'
          '${p.extension(widget.photo.path)}';
      final newPath = p.join(folder.path, fileName);

      // Copie la photo : l’originale reste dans la galerie
      await widget.photo.saveTo(newPath);

      // Range la photo dans la base
      await ref
          .read(contentsRepositoryProvider)
          .addPhoto(title: title, filePath: newPath);

      if (!mounted) return;

      // Revient à l’écran précédent
      context.pop();
    } catch (error) {
      if (!mounted) return;

      _showError('Impossible d’enregistrer la photo');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une photo'),

        // Bouton grisé pendant l’enregistrement
        actions: [
          TextButton(
            onPressed: _isBusy ? null : _save,
            child: const Text('Enregistrer'),
          ),
        ],
      ),

      // Évite les zones système du téléphone
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

              const SizedBox(height: 16),

              // La photo occupe la hauteur restante
              Expanded(
                child: Center(
                  // Arrondit les coins de la photo
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    // Affiche un fichier du téléphone
                    child: Image.file(
                      File(widget.photo.path),

                      // Affiche la photo entière sans la recadrer
                      fit: BoxFit.contain,

                      // Si la photo ne peut pas être lue, prévient le patient
                      errorBuilder: (context, error, stackTrace) =>
                          const Text('Impossible d’afficher la photo'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
