// starting_grid.dart
import 'package:cyber_security/widgets/starting_grid_item.dart';
import 'package:flutter/material.dart';

class StartingGrid extends StatelessWidget {
  const StartingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String,String> gridItems = {
      "Desktop/Laptop Security": "assets/cyber_security_articles/desktop_laptop.md",
      "Web Browsing": "assets/cyber_security_articles/web_browsing.md",
      "Interactind on Social Media": "assets/cyber_security_articles/interacting_social_media.md",
      "Defense Agains Malware": "assets/cyber_security_articles/malware_defense.md",
      "Handling Removable Storage Media": "assets/cyber_security_articles/removable_drive.md",
      "Portable Smart Devices": "assets/cyber_security_articles/portable_smart_device.md",
      "Communicating Over Email": "assets/cyber_security_articles/email.md",
      "Networking at Home": "assets/cyber_security_articles/home_network.md",
      "Managing Passwords": "assets/cyber_security_articles/password.md",
      "E-Commerce and Banking Over Internet": "assets/cyber_security_articles/web_browsing.md",
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Cybersecurity Topics')),
      body: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: gridItems.entries.map((item)=>StartingGridItem(mdfile: item.value, articleName: item.key)).toList()
      ),
    );
  }
}
