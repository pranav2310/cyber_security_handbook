import 'package:cyber_security/screens/search_screen.dart';
import 'package:cyber_security/widgets/home_drawer.dart';
import 'package:cyber_security/widgets/starting_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:cyber_security/data/gridItems.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color orange = Color(0xFFF37022);
const Color blue = Color(0xFF051951);
const Color white = Color(0xFFFFFFFF);


class StartingGrid extends ConsumerWidget {
  const StartingGrid({super.key});

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 5; // Extra wide screens
    if (width > 900) return 4;  // Large desktop screens
    if (width > 600) return 3;  // Tablet/smaller desktop screens
    return 2;                  // Mobile phones
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 5 / 4; // Wider items for more columns
    if (width > 900) return 4 / 3;  // Standard wider items
    return 3 / 3;                   // Square items for smaller screens
  }

  EdgeInsets _getGridPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return const EdgeInsets.all(32); // More padding for larger screens
    } else if (width > 600) {
      return const EdgeInsets.all(24); // Medium padding for tablets
    } else {
      return const EdgeInsets.all(16); // Less padding for mobile
    }
  }

  double _getAppBarTitleFontSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return 28; // Larger font for desktop
    } else if (width > 600) {
      return 24; // Standard font for tablets
    } else {
      return 20; // Smaller font for mobile
    }
  }

  double _getAppBarIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return 30; // Larger icon for desktop
    } else {
      return 24; // Standard icon for mobile/tablet
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridArticles = ref.watch(gridItemsProvider);
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        backgroundColor: orange,
        title: Text(
          'Cyber Security Handbook',
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: _getAppBarTitleFontSize(context),
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search Articles',
            icon: Icon(
              Icons.search, 
              color: white,
              size: _getAppBarIconSize(context),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => SearchScreen(
                    gridItems: {
                      for (var item in gridArticles)
                        item.title: [item.mdfile, Icon(item.icon, size: 30, color: blue)],
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            padding: _getGridPadding(context),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              childAspectRatio: _getChildAspectRatio(context),
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
            ),
            itemCount: gridArticles.length,
            itemBuilder: (context, i) {
              final article = gridArticles[i];
              return StartingGridItem(
                mdfile: article.mdfile,
                articleName: article.title,
                icon: Icon(article.icon, size: 36, color: blue),
                backgroundColor: Colors.white,
                borderColor: orange.withOpacity(0.25),
                elevation: 3,
                onTapFeedbackColor: orange.withOpacity(0.15),
              );
            },
          );
        },
      ),
    );
  }
}
