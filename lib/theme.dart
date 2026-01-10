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
  // Фон чуть серый, чтобы белая карточка выделялась
  static const background = Color(0xFFF2F2F7); 
  static const surface = Color(0xFFFFFFFF);
  
  static const textPrimary = Color(0xFF000000); // Sharp
  static const textMuted = Color(0xFF6E6E73);   // Muted
  
  static const primary = Color(0xFF000000); // Кнопки черные/контрастные
  static const onPrimary = Color(0xFFFFFFFF);
  
  static const border = Color(0xFFE5E5EA);
}

class DarkModeColors {
  // Фон черный
  static const background = Color(0xFF000000);
  // Карточка чуть светлее, но очень темная
  static const surface = Color(0xFF161618); 
  
  static const textPrimary = Color(0xFFFFFFFF); // Sharp
  static const textMuted = Color(0xFF98989F);   // Muted
  
  static const primary = Color(0xFFFFFFFF);
  static const onPrimary = Color(0xFF000000);
  
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
);

TextTheme _buildTextTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final primaryColor = isDark ? DarkModeColors.textPrimary : LightModeColors.textPrimary;
  
  return TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.bold, color: primaryColor),
    displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.bold, color: primaryColor),
    displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.bold, color: primaryColor),
    
    // Sharp headings
    headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: primaryColor, letterSpacing: -0.5),
    headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: primaryColor, letterSpacing: -0.5),
    headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: primaryColor, letterSpacing: -0.5),
    
    titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: primaryColor),
    titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor),
    titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor),
    
    bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: primaryColor),
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: isDark ? DarkModeColors.textMuted : LightModeColors.textMuted),
  );
}
