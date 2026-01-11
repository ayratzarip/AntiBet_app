import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 24.0; // Более скругленные углы, как на референсе
  static const double xl = 32.0;
}

// =============================================================================
// COLORS (Reference Based)
// =============================================================================

class LightModeColors {
  // Фон 90% светлоты
  static const background = Color(0xFFE6E6E6);
  // Карточки 95% светлоты
  static const surface = Color(0xFFF2F2F2);

  // Текст основной 5% светлоты
  static const textPrimary = Color(0xFF0D0D0D);
  // Текст второстепенный 30% светлоты
  static const textMuted = Color(0xFF4D4D4D);

  // Кнопки внутри карточек 100% (белый)
  static const primary = Color(0xFFFFFFFF);
  static const onPrimary = Color(0xFF0D0D0D);

  // Поля для ввода 100% (белый)
  static const inputField = Color(0xFFFFFFFF);

  // Цвет текста кнопок 70% светлоты
  static const buttonText = Color(0xFFB3B3B3);

  // Цвет фона вторичных кнопок 95% светлоты
  static const secondaryButtonBackground = Color(0xFFF2F2F2);
  // Цвет текста вторичных кнопок 30% светлоты
  static const secondaryButtonText = Color(0xFF4D4D4D);

  // Цвет иконок и индикаторов
  static const iconColor = Color(0xFF2b67dc);

  static const border = Color(0xFFE5E5EA);
}

class DarkModeColors {
  // Фон 10% светлоты
  static const background = Color(0xFF1A1A1A);
  // Карточки 5% светлоты
  static const surface = Color(0xFF0D0D0D);

  // Текст основной 95% светлоты
  static const textPrimary = Color(0xFFF2F2F2);
  // Текст второстепенный 70% светлоты
  static const textMuted = Color(0xFFB3B3B3);

  // Кнопки внутри карточек 0% (черный)
  static const primary = Color(0xFF000000);
  static const onPrimary = Color(0xFFF2F2F2);

  // Поля для ввода 0% (черный)
  static const inputField = Color(0xFF000000);

  // Цвет текста кнопок 30% светлоты
  static const buttonText = Color(0xFF4D4D4D);

  // Цвет фона вторичных кнопок 5% светлоты
  static const secondaryButtonBackground = Color(0xFF0D0D0D);
  // Цвет текста вторичных кнопок 70% светлоты
  static const secondaryButtonText = Color(0xFFB3B3B3);

  // Цвет иконок и индикаторов
  static const iconColor = Color(0xFF2b67dc);

  static const border = Color(0xFF2C2C2E); // Highlight border base
}

// =============================================================================
// THEMES
// =============================================================================

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: LightModeColors.background,
      colorScheme: const ColorScheme.light(
        primary: LightModeColors.primary,
        onPrimary: LightModeColors.onPrimary,
        secondary: LightModeColors.primary,
        onSecondary: LightModeColors.onPrimary,
        secondaryContainer: Color(0xFFE5E5EA),
        onSecondaryContainer: LightModeColors.textPrimary,
        surface: LightModeColors.surface,
        onSurface: LightModeColors.textPrimary,
        onSurfaceVariant: LightModeColors.textMuted,
        surfaceContainerHighest: Color(0xFFE5E5EA),
        outline: LightModeColors.border,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: LightModeColors.primary,
          foregroundColor: LightModeColors.onPrimary,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: LightModeColors.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LightModeColors.inputField,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: LightModeColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: LightModeColors.primary, width: 2),
        ),
      ),
    );

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DarkModeColors.background,
      colorScheme: const ColorScheme.dark(
        primary: DarkModeColors.primary,
        onPrimary: DarkModeColors.onPrimary,
        secondary: DarkModeColors.primary,
        onSecondary: DarkModeColors.onPrimary,
        secondaryContainer: Color(0xFF2C2C2E),
        onSecondaryContainer: DarkModeColors.textPrimary,
        surface: DarkModeColors.surface,
        onSurface: DarkModeColors.textPrimary,
        onSurfaceVariant: DarkModeColors.textMuted,
        surfaceContainerHighest: Color(0xFF2C2C2E),
        outline: DarkModeColors.border,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: DarkModeColors.primary,
          foregroundColor: DarkModeColors.onPrimary,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: DarkModeColors.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DarkModeColors.inputField,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: DarkModeColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: DarkModeColors.primary, width: 2),
        ),
      ),
    );

TextTheme _buildTextTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final primaryColor =
      isDark ? DarkModeColors.textPrimary : LightModeColors.textPrimary;

  return TextTheme(
    displayLarge: GoogleFonts.inter(
        fontSize: 57, fontWeight: FontWeight.bold, color: primaryColor),
    displayMedium: GoogleFonts.inter(
        fontSize: 45, fontWeight: FontWeight.bold, color: primaryColor),
    displaySmall: GoogleFonts.inter(
        fontSize: 36, fontWeight: FontWeight.bold, color: primaryColor),

    // Sharp headings
    headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: primaryColor,
        letterSpacing: -0.5),
    headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: primaryColor,
        letterSpacing: -0.5),
    headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.5),

    titleLarge: GoogleFonts.inter(
        fontSize: 22, fontWeight: FontWeight.w700, color: primaryColor),
    titleMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
    titleSmall: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor),

    bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor),
    bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400, color: primaryColor),
    bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isDark ? DarkModeColors.textMuted : LightModeColors.textMuted),
  );
}
