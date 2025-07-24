import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final gridItemsProvider = Provider((ref)=>gridArticles);