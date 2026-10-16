import 'package:go_router/go_router.dart';

import '../../features/contents/view/pages/add_text_page.dart';
import '../../features/contents/view/pages/contents_page.dart';

// Centralise les routes de l’application.
final appRouter = GoRouter(
  // Page affichée au lancement.
  initialLocation: '/',

  routes: [
    // Dashboard patient
    GoRoute(path: '/', builder: (context, state) => const ContentsPage()),

    // Page d’écriture d’un texte.
    GoRoute(
      path: '/contents/add-text',
      builder: (context, state) => const AddTextPage(),
    ),
  ],
);
