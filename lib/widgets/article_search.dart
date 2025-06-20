import 'package:flutter/material.dart';

class ArticleSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context){
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.appBarTheme.backgroundColor, // matches your main app bar
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
    );
  }
  final List<Map<String, dynamic>> sections;
  final String intro;

  ArticleSearchDelegate({required this.sections, required this.intro});

  List<Map<String, String>> _searchResults(String query) {
    final results = <Map<String, String>>[];

    // Search in intro
    if (intro.toLowerCase().contains(query.toLowerCase())) {
      results.add({'section': 'Introduction', 'content': intro});
    }

    // Search in sections and subsections
    for (final section in sections) {
      final title = section['title'] as String? ?? '';
      final introText = section['intro'] as String? ?? '';
      if (title.toLowerCase().contains(query.toLowerCase())) {
        results.add({'section': title, 'content': introText});
      }
      final subSections = section['subsections'] as List<dynamic>? ?? [];
      for (final sub in subSections) {
        final subTitle = sub['title'] as String? ?? '';
        final subContent = sub['content'] as String? ?? '';
        if (subTitle.toLowerCase().contains(query.toLowerCase()) ||
            subContent.toLowerCase().contains(query.toLowerCase())) {
          results.add({'section': '$title > $subTitle', 'content': subContent});
        }
      }
    }
    return results;
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final results = _searchResults(query);
    if (results.isEmpty) {
      return Center(child: Text('No results found.'));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final result = results[i];
        return ListTile(
          title: Text(result['section'] ?? ''),
          subtitle: Text(
            result['content'] ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();
    final results = _searchResults(query);
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final result = results[i];
        return ListTile(
          title: Text(result['section'] ?? ''),
          subtitle: Text(
            result['content'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
