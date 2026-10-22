import 'package:go_router/go_router.dart';

import '../../features/contents/view/pages/add_text_page.dart';
import '../../features/contents/view/pages/contents_page.dart';
import '../../features/contents/view/pages/content_detail_page.dart';

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
    GoRoute(
      path: '/contents/detail',

      // Revient au dashboard si aucune donnée valide n’a été transmise.
      redirect: (context, state) {
        if (state.extra is! Map<String, Object?>) {
          return '/';
        }

        return null;
      },

      builder: (context, state) {
        // Récupère les informations transmises lors de la navigation.
        final data = state.extra as Map<String, Object?>;

        return ContentDetailPage(
          title: data['title'] as String,
          date: data['date'] as String,
          text: data['text'] as String? ?? '',
          imagePath: data['imagePath'] as String?,
          isShared: data['isShared'] as bool? ?? false,
        );
      },
    ),
  ],
);
