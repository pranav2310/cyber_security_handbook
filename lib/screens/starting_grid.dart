import 'package:cyber_security/screens/search_screen.dart';
import 'package:cyber_security/widgets/starting_grid_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final Color orange = const Color(0xFFF37022);
final Color blue = const Color(0xFF051951);
final Color white = const Color(0xFFFFFFFF);

class GridArticle {
  final String title;
  final String mdfile;
  final IconData icon;

  GridArticle({
    required this.title,
    required this.mdfile,
    required this.icon,
  });
}

final List<GridArticle> gridArticles = [
  GridArticle(
    title: "Desktop/Laptop Security",
    mdfile: "assets/cyber_security_articles/desktop_laptop.md",
    icon: Icons.laptop,
  ),
  GridArticle(
    title: "Web Browsing",
    mdfile: "assets/cyber_security_articles/web_browsing.md",
    icon: Icons.web,
  ),
  GridArticle(
    title: "Interacting on Social Media",
    mdfile: "assets/cyber_security_articles/interacting_social_media.md",
    icon: Icons.groups,
  ),
  GridArticle(
    title: "Defense Against Malware",
    mdfile: "assets/cyber_security_articles/malware_defense.md",
    icon: Icons.shield,
  ),
  GridArticle(
    title: "Handling Removable Storage Media",
    mdfile: "assets/cyber_security_articles/removable_drive.md",
    icon: Icons.usb,
  ),
  GridArticle(
    title: "Portable Smart Devices",
    mdfile: "assets/cyber_security_articles/portable_smart_device.md",
    icon: Icons.wifi,
  ),
  GridArticle(
    title: "Communicating Over Email",
    mdfile: "assets/cyber_security_articles/email.md",
    icon: Icons.mail,
  ),
  GridArticle(
    title: "Networking at Home",
    mdfile: "assets/cyber_security_articles/home_network.md",
    icon: Icons.home_filled,
  ),
  GridArticle(
    title: "Managing Passwords",
    mdfile: "assets/cyber_security_articles/password.md",
    icon: Icons.password,
  ),
  GridArticle(
    title: "E-Commerce and Banking Over Internet",
    mdfile: "assets/cyber_security_articles/banking.md",
    icon: Icons.currency_rupee_sharp,
  ),
];

class StartingGrid extends StatelessWidget {
  const StartingGrid({super.key});

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (kIsWeb) {
      if (width > 1200) return 5;
      if (width > 900) return 4;
      if (width > 600) return 3;
      return 2;
    } else {
      if (width > 900) return 3;
      return 2;
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (kIsWeb) {
      if (width > 1200) return 5 / 3;
      if (width > 900) return 4 / 3;
      return 3 / 3;
    } else {
      return 3 / 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orange,
        title: Text(
          'Cyber Security Handbook',
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.1,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Search Articles',
            icon: Icon(Icons.search, color: white),
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
            padding: const EdgeInsets.all(24),
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
