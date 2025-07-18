import 'package:cyber_security/screens/search_screen.dart';
import 'package:cyber_security/widgets/starting_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  GridArticle(
    title: "Mobile Phone Security",
    mdfile: "assets/cyber_security_articles/lost_phone.md",
    icon: Icons.smartphone,
  )
];

class StartingGrid extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: blue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: orange),
              child: Text(
                'Helpline Numbers and Resources',
                style: TextStyle(
                  color: white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.call, color: white),
              title: Text('National Cyber Crime Helpline Number', style: TextStyle(color: white)),
              subtitle: Text('1930', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
              onTap: (){
                launchUrl(Uri.parse('tel:1930'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.security, color: white),
              title: Text('Cyber Crime Portal', style: TextStyle(color: white)),
              subtitle: Text('https://cybercrime.gov.in/', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
              onTap: () {
                final uri = Uri.tryParse("https://cybercrime.gov.in/");
                if (uri != null) {
                  launchUrl(uri);
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user, color: white),
              title: Text('CERT-In (Indian Computer Emergency Response Team)', style: TextStyle(color: white)),
              subtitle: Text('https://www.cert-in.org.in/', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
              onTap: () {
                launchUrl(Uri.parse('https://www.cert-in.org.in/'));
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.email, color: white),
              title: Text('Contact Us', style: TextStyle(color: white)),
              subtitle: Text('info@cybersecurityhandbook.com', style: TextStyle(color: white, fontWeight: FontWeight.bold)),
              onTap: () {
                launchUrl(Uri.parse('mailto:info@cybersecurityhandbook.com?subject=Inquiry about Cyber Security Handbook'));
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
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
