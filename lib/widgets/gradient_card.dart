import 'package:flutter/material.dart';
import 'package:antibet/core/theme/app_shadows.dart';

/// Карточка с глубиной по правилам `.cursorrules` (п.14–32).
///
/// * Top Highlight Border — блик сверху.
/// * Gradient Surface — верх светлее низа.
/// * Shadow Levels — соответствует системе AppShadows.
///
/// [simulateLight] включает режим имитации света (светлая граница сверху-слева),
/// иначе используется фирменный градиент бренда.
class GradientCard extends StatelessWidget {
  const GradientCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.backgroundColor,
    this.radius = 12,
    this.borderWidth = 1.25,
    this.simulateLight = false,
    this.shadowLevel = ShadowLevel.small,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;
  final bool simulateLight;
  final ShadowLevel shadowLevel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Base colors for brand gradient
    final primary = cs.primary;
    final secondary = isDark ? cs.secondary : cs.tertiary;

    LinearGradient borderGradient;

    if (simulateLight) {
      // Имитация света: сверху-слева ярко (свет/блик), снизу-справа тень/прозрачность.
      borderGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          isDark
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.8), // Highlight
          isDark
              ? Colors.black.withValues(alpha: 0.1)
              : cs.outline.withValues(alpha: 0.15), // Shadow/Fade
        ],
        stops: const [0.0, 1.0],
      );
    } else {
      // Стандартный брендовый градиент
      borderGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary.withValues(alpha: isDark ? 0.50 : 0.45),
          secondary.withValues(alpha: isDark ? 0.45 : 0.40),
        ],
      );
    }

    // Gradient Surface для внутреннего контента (верх светлее низа)
    final surfaceColor = backgroundColor ?? cs.surface;
    final Color surfaceTop;
    final Color surfaceBottom;

    if (isDark) {
      surfaceTop = Color.lerp(surfaceColor, Colors.white, 0.02)!;
      surfaceBottom = Color.lerp(surfaceColor, Colors.black, 0.02)!;
    } else {
      surfaceTop = Color.lerp(surfaceColor, Colors.white, 0.10)!;
      surfaceBottom = Color.lerp(surfaceColor, Colors.black, 0.01)!;
    }

    final surfaceGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [surfaceTop, surfaceBottom],
    );

    // Выбор уровня тени согласно .cursorrules
    final shadows = switch (shadowLevel) {
      ShadowLevel.small => AppShadows.small(context),
      ShadowLevel.medium => AppShadows.medium(context),
      ShadowLevel.large => AppShadows.large(context),
    };

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(radius - borderWidth),
      child: Container(
        decoration: BoxDecoration(gradient: surfaceGradient),
        child: Material(
          color: Colors.transparent,
          child: onTap == null
              ? child
              : InkWell(
                  onTap: onTap,
                  child: child,
                ),
        ),
      ),
    );

    final card = DecoratedBox(
      decoration: BoxDecoration(
        gradient: borderGradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.9),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: content,
      ),
    );

    if (margin == null) return card;
    return Padding(padding: margin!, child: card);
  }
}

enum ShadowLevel { small, medium, large }
