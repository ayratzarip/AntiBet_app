import 'package:flutter/material.dart';

/// Набор пресетов теней для создания глубины (см. .cursorrules, п.14–32).
class AppShadows {
  /// Маленькая тень для базовых карточек и чипов.
  static List<BoxShadow> small(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.7),
        offset: const Offset(0, -1),
        blurRadius: 1,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
        offset: const Offset(0, 2),
        blurRadius: 4,
      ),
    ];
  }

  /// Средняя тень для интерактивных элементов и hover-состояний.
  static List<BoxShadow> medium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.85),
        offset: const Offset(0, -1),
        blurRadius: 2,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
        offset: const Offset(0, 4),
        blurRadius: 8,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
        offset: const Offset(0, 8),
        blurRadius: 16,
      ),
    ];
  }

  /// Большая тень — модальные окна, выпадающие списки.
  static List<BoxShadow> large(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white,
        offset: const Offset(0, -1),
        blurRadius: 2,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
        offset: const Offset(0, 8),
        blurRadius: 16,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.1),
        offset: const Offset(0, 16),
        blurRadius: 32,
      ),
    ];
  }

  /// Inset-тень для "вдавленных" элементов (поля ввода, прогресс-бары).
  static List<BoxShadow> inset(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
        offset: const Offset(0, 2),
        blurRadius: 4,
        spreadRadius: -1,
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.65),
        offset: const Offset(0, -1),
        blurRadius: 2,
      ),
    ];
  }
}
