// starting_grid_item.dart
import 'package:cyber_security/widgets/markdown_page.dart';
import 'package:flutter/material.dart';

class StartingGridItem extends StatelessWidget {
  const StartingGridItem({
    super.key,
    required this.mdfile,
    required this.articleName,
  });

  final String mdfile;
  final String articleName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => MarkdownPage(
                mdfile: mdfile,
                title: articleName,
              ),
            ),
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              articleName,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
