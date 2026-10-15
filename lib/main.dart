import 'package:flutter/material.dart';

import 'features/contents/view/pages/contents_page.dart';
import 'app/theme/app_theme.dart';

void main() {
  runApp(const TraceApp());
}

class TraceApp extends StatelessWidget {
  const TraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ContentsPage(),
    );
  }
}
