import 'package:flutter/material.dart';

import '../widgets/add_content_sheet.dart';

class ContentsPage extends StatelessWidget {
  const ContentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes contenus')),
      body: const Center(child: Text('Aucun contenu pour le moment')),
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
