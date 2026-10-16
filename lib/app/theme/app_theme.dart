import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // Thème clair utilisé par MaterialApp, Final variabke qui changera pas
  static final light = ThemeData(
    useMaterial3: true,

    // Fond par défaut des pages utilisant Scaffold
    scaffoldBackgroundColor: AppColors.background,

    // Palette utilisée par les composants Material
    // fromSeed génère une palette, puis on précise certaines couleurs
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.textPrimary,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
    ),

    // Apparence des barres situées en haut des pages
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,

      // Évite une teinte supplémentaire sur la barre
      surfaceTintColor: Colors.transparent,

      // Pas d’ombre et titre aligné à gauche
      elevation: 0,
      centerTitle: false,

      // Styles de texte
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
    ),

    // Apparence du bouton flottant « + »
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
  );
}
