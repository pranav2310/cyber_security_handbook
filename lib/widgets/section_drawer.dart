import 'package:flutter/material.dart';

class SectionDrawer extends StatelessWidget {
  final String mainTitle;
  final List<Map<String, dynamic>> sections;
  final Function(int) onSectionTap;
  final int? currentSectionIndex;

  const SectionDrawer({
    super.key,
    required this.mainTitle,
    required this.sections,
    required this.onSectionTap,
    this.currentSectionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mainTitle, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.home),
                  tooltip: 'Go Back to Home Page',
                ),
              ],
            ),
          ),
          ...List.generate(sections.length, (i) {
            final title = sections[i]['title'] as String? ?? '';
            return ListTile(
              title: Text(title),
              onTap: () {
                Navigator.pop(context);
                onSectionTap(i);
              },
            );
          }),
        ],
      ),
    );
  }
}
