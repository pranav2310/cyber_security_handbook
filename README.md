# Cyber Security Handbook
 - IOCL internship Project 
 - This is a Progressive Web App made for the Cyber Security Week to provide a comprehensive handbook to the employees of IOCL.

 ## Features
 - **Progressive Web App:** Accessible on both mobile and desktop browsers without installation.
 - **Comprehensive Cyber Security Topics:** Covers device security, web browsing, social media safety, malware defense, password management, email communication, home networking, e-commerce security, and more.
 - **Intuitive Grid Interface:** Easy navigation through categorized topics with icons.
 - **Markdown-Based Articles:** Content is stored in markdown files for easy updates and readability.
 - **Search Functionality:** Quickly find relevant topics or keywords within the handbook.
 - **Responsive Design:** Optimized for various screen sizes and platforms.
 - **Offline Access:** Once loaded, articles can be accessed offline (typical for PWAs).
 - **Custom Theming:** Uses a professional color scheme and Google Fonts for readability and aesthetics.

 ## Getting Started:
 ### Clone the repositories:
 ```bash 
    git clone https://github.com/pranav2310/cyber_security_handbook.git 
    cd cyber_security_handbook
 ```
 ### Install dependencies:
 ```bash
 flutter pub get
 ```
 ### Run the app:
 - For mobile or desktop:
```bash 
 flutter run
```
 - For web:
 ```bash
 flutter run -d chrome
 ```
 ### Build for production web deployment:
 ```bash
 flutter build web
 ```

## Project Structure
```text
lib/
    data/
        gridItems.dart
    screens/
        article_screen.dart
        search_screen.dart
        starting_grid.dart
    widgets/
        article_search.dart
        home_drawer.dart
        section_drawer.dart
        starting_grid_item.dart
assets/
    cyber_security_articles/
        banking.md
        desktop_laptop.md
        email.md
        home_network.md
        interacting_social_media.md
        malware_defense.md
        password.md
        portable_smart_device.md
        removable_drive.md
        web_browsing.md
        lost_phone.md
```
## Technologies Used
- Flutter & Dart
- Google Fonts(Lato)
- Markdown rendering for article contet
- Progressive Web App capabilities

## Screenshots
<p align="center">
    <h3>Web App</h3>
    <img src="/assets/screenshots/StartingScreen.png" width="500"/>
    <img src="/assets/screenshots/StartingScreenDrawer.png" width="500"/>
    <img src="/assets/screenshots/HomeScreenSearch.png" width="500"/>
    <img src="/assets/screenshots/ArticleScreen.png" width="500"/>
    <img src="/assets/screenshots/ArticleScreenFontSizeinc.png" width="500"/>
    <img src="/assets/screenshots/ArticleScreenSearch.png" width="500"/>
</p>