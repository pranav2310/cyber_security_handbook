import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const Color orange = Color(0xFFF37022);
const Color blue = Color(0xFF051951);
const Color white = Color(0xFFFFFFFF);

class Helpline {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  Helpline({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

final List<Helpline> helpline=[
  Helpline(
    title: 'National Cyber Crime Helpline Number', 
    subtitle: '1930', 
    icon: Icons.call, 
    onTap: () {
      launchUrl(Uri.parse('tel:1930'));
    }
  ),
  Helpline(
    title: 'Cyber Crime Portal', 
    subtitle: 'https://cybercrime.gov.in/', 
    icon: Icons.security, 
    onTap: () {
      final uri = Uri.tryParse("https://cybercrime.gov.in/");
      if (uri != null) {
        launchUrl(uri);
      }
    }
  ),
  Helpline(
    title: 'CERT-In (Indian Computer Emergency Response Team)', 
    subtitle: 'https://www.cert-in.org.in/', 
    icon: Icons.verified_user, 
    onTap: () {
      launchUrl(Uri.parse('https://www.cert-in.org.in/'));
    }
  ),
];

class HomeDrawer extends StatelessWidget{
  const HomeDrawer({super.key});

  Widget _drawerTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }){
    return ListTile(
      leading: Icon(icon, color: white),
      title: Text(title, style: TextStyle(color: white)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: white, fontWeight: FontWeight.bold)) : null,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            ...helpline.map((item) => _drawerTile(
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              onTap: () {
                item.onTap();
                Navigator.of(context).pop(); // Close the drawer after tapping
              },
            )),
          ],
        ),
      );
  }
}