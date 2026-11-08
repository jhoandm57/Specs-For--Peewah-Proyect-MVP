import 'package:flutter/material.dart';

// Colores principales de la referencia visual de Peewah.
const _ink = Color(0xFF161616);
const _background = Color(0xFFFEFEFE);

/// Configura el tema claro que comparten las pantallas.
ThemeData buildAppTheme() => ThemeData(
  scaffoldBackgroundColor: _background,
  colorScheme: const ColorScheme.light(
    primary: _ink,
    onPrimary: _background,
    surface: _background,
    onSurface: _ink,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _background,
    foregroundColor: _ink,
  ),
);
