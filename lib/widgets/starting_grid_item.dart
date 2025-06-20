// starting_grid_item.dart
import 'package:cyber_security/screens/article_screen.dart';
import 'package:flutter/material.dart';

class StartingGridItem extends StatelessWidget {
  const StartingGridItem({
    super.key,
    required this.mdfile,
    required this.articleName,
    required this.icon,
  });

  final String mdfile;
  final String articleName;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
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
                  size: 48,
                ),
                const SizedBox(height: 4,),
                Text(
                  articleName,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
