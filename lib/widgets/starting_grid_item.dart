import 'package:cyber_security/screens/article_screen.dart';
import 'package:flutter/foundation.dart';
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
    if (kIsWeb) {
      iconSize = screenWidth < 600 ? 56 : 72; // Smaller icon for web on narrow screens
    } else {
      iconSize = screenWidth < 400 ? 40 : 48; // Smaller icon for mobile on very narrow screens
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
