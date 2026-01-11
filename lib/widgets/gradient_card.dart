import 'package:flutter/material.dart';

/// Карточка с градиентной каймой и мягкой тенью.
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
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;
  final bool simulateLight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Base colors for brand gradient
    final primary = cs.primary;
    final secondary = cs.secondary;

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

    final shadowOpacity = isDark ? 0.35 : 0.08; // Чуть глубже тени

    // Убеждаемся, что радиус не отрицательный
    final innerRadius = (radius - borderWidth).clamp(0.0, double.infinity);

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(innerRadius),
      child: Material(
        color: backgroundColor ?? cs.surface,
        child: onTap == null
            ? child
            : InkWell(
                onTap: onTap,
                child: child,
              ),
      ),
    );

    final card = DecoratedBox(
      decoration: BoxDecoration(
        gradient: borderGradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: shadowOpacity),
            blurRadius: 20, // Ещё мягче и шире тень
            offset: const Offset(0, 8),
          ),
        ],
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
