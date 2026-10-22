// Accéder à un fichier sur le téléphone
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Écran d’aperçu d’une photo sélectionnée
class AddPhotoPage extends StatelessWidget {
  const AddPhotoPage({super.key, required this.photo});

  // XFile représente le fichier renvoyé par image_picker
  final XFile photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une photo')),

      // Évite les zones système du téléphone
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            // Arrondit les coins de la photo
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),

              // Affiche un fichier du téléphone
              child: Image.file(
                File(photo.path),

                // Affiche la photo entière sans la recadrer
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
