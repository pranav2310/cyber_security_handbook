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
      backgroundColor: Theme.of(context).colorScheme.secondary ,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.pop(context); // Go back to home
                    },
                    icon: const Icon(Icons.home, color: Colors.white, size: 32),
                    tooltip: 'Go Back to Home Page',
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.menu_book_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        mainTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: sections.length,
              separatorBuilder: (context, i) => Divider(
                height: 1,
                thickness: 0.8,
                color: Theme.of(context).colorScheme.secondary,
              ),
              itemBuilder: (context, i) {
                final title = sections[i]['title'] as String? ?? '';
                return Material(
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.secondary,
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onSectionTap(i);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
