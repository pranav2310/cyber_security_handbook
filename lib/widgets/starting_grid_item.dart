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
    final theme = Theme.of(context);
    final Color bg = backgroundColor ?? theme.colorScheme.primary.withOpacity(0.08);
    final Color border = borderColor ?? theme.colorScheme.primary.withOpacity(0.18);
    final Color iconColor = theme.colorScheme.primary;
    final Color textColor = theme.colorScheme.onSurface;

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
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon.icon,
                  size: kIsWeb ? 72 : 48,
                  color: iconColor,
                  semanticLabel: articleName,
                ),
                const SizedBox(height: 18),
                Text(
                  articleName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
