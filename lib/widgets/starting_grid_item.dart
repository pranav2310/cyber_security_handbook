import 'package:cyber_security/screens/article_screen.dart';
import 'package:flutter/material.dart';

class StartingGridItem extends StatelessWidget {
  const StartingGridItem({
    super.key,
    required this.mdfile,
    required this.articleName,
    required this.icon,
    this.backgroundColor,
    this.borderColor,
    this.elevation = 4,
    this.onTapFeedbackColor,
  });

  final String mdfile;
  final String articleName;
  final Icon icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;
  final Color? onTapFeedbackColor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final theme = Theme.of(context);
    final Color bg = backgroundColor ?? theme.colorScheme.primary.withOpacity(0.08);
    final Color border = borderColor ?? theme.colorScheme.primary.withOpacity(0.18);
    final Color iconColor = theme.colorScheme.primary;
    final Color textColor = theme.colorScheme.onSurface;

    final double calculatedTextScale = MediaQuery.of(context).textScaler.scale(1.0) > 1.0 ? 0.9 : 1.0;

    double iconSize;
    if (screenWidth < 360) {
      iconSize = 40; // Very small screens (e.g., small phones)
    } else if (screenWidth < 600) {
      iconSize = 48; // Standard phone screens
    } else if (screenWidth < 900) {
      iconSize = 56; // Small tablets / larger phones
    } else if (screenWidth < 1200) {
      iconSize = 64; // Larger tablets / small desktop
    } else {
      iconSize = 72; // Large desktop screens
    }

    double baseFontSize;
    if (screenWidth < 360) {
      baseFontSize = 14; // Smaller font for very small screens
    } else if (screenWidth < 600) {
      baseFontSize = 16; // Standard font for phone screens
    } else if (screenWidth < 900) {
      baseFontSize = 18; // Slightly larger for tablets/larger phones
    } else {
      baseFontSize = 20; // Larger font for desktop screens
    }

    return Card(
      color: bg,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: border, width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: onTapFeedbackColor ?? theme.colorScheme.primary.withOpacity(0.15),
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ArticleScreen(
                mdfile: mdfile,
                title: articleName,
                initialSearch: '',
              ),
            ),
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon.icon,
                  size: iconSize,
                  color: iconColor,
                  semanticLabel: articleName,
                ),
                const SizedBox(height: 18),
                Flexible(
                  child: Text(
                    articleName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: baseFontSize
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textScaler: TextScaler.linear(calculatedTextScale),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
