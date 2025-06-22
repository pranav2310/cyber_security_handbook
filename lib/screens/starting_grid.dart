import 'package:cyber_security/screens/search_screen.dart';
import 'package:cyber_security/widgets/starting_grid_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final Color orange = const Color(0xFFF37022);
final Color blue = const Color(0xFF051951);
final Color white = const Color(0xFFFFFFFF);

class StartingGrid extends StatelessWidget {
  const StartingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String,List<dynamic>> gridItems = {
      "Desktop/Laptop Security": [
        "assets/cyber_security_articles/desktop_laptop.md", 
        Icon(Icons.laptop, size: 30,)
      ],
      "Web Browsing": [
        "assets/cyber_security_articles/web_browsing.md", 
        Icon(Icons.web, size: 30,)
      ],
      "Interacting on Social Media": [
        "assets/cyber_security_articles/interacting_social_media.md", 
        Icon(Icons.groups, size: 30,)
      ],
      "Defense Against Malware": [
        "assets/cyber_security_articles/malware_defense.md", 
        Icon(Icons.shield, size: 30,)
      ],
      "Handling Removable Storage Media": [
        "assets/cyber_security_articles/removable_drive.md", 
        Icon(Icons.usb, size: 30,)
      ],
      "Portable Smart Devices": [
        "assets/cyber_security_articles/portable_smart_device.md", 
        Icon(Icons.wifi, size: 30,)
      ],
      "Communicating Over Email": [
        "assets/cyber_security_articles/email.md", 
        Icon(Icons.mail, size: 30,)
      ],
      "Networking at Home": [
        "assets/cyber_security_articles/home_network.md", 
        Icon(Icons.home_filled, size: 30,)
      ],
      "Managing Passwords": [
        "assets/cyber_security_articles/password.md", 
        Icon(Icons.password, size: 30,)
      ],
      "E-Commerce and Banking Over Internet": [
        "assets/cyber_security_articles/banking.md", 
        Icon(Icons.currency_rupee_sharp, size: 30,)
      ],
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CyberGuard Handbook',
          style: TextStyle(
            color: Color(0xFF051951),
            fontWeight: FontWeight.bold,
            fontSize: 24
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (ctx)=>SearchScreen(gridItems: gridItems))
            );
          }, icon: Icon(Icons.search))
        ],
      ),
      body: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb? 4 : 2,
          childAspectRatio: kIsWeb? 4/3 : 3 / 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        children: gridItems.entries.map((item)=>StartingGridItem(
          mdfile: item.value[0] as String, 
          articleName: item.key, 
          icon: item.value[1] as Icon
        )).toList()
      ),
    );
  }
}
