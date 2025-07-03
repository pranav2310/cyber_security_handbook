import 'dart:async';
import 'package:cyber_security/screens/article_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.gridItems});
  final Map<String, List<dynamic>> gridItems;

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  List<_SearchResult> _results = [];
  bool _isLoading = false;
  Timer? _debounceTimer;
  final Map<String, String> _contentCache = {};

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _query = query;
      _isLoading = true;
      _results.clear();
    });

    if (query.isEmpty || query.length < 3) {
      setState(() => _isLoading = false);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final List<_SearchResult> matches = [];

    for (final entry in widget.gridItems.entries) {
      final articleName = entry.key;
      final mdPath = entry.value[0] as String;

      String content;
      try {
        if (_contentCache.containsKey(mdPath)) {
          content = _contentCache[mdPath]!;
        } else {
          content = await rootBundle.loadString(mdPath);
          _contentCache[mdPath] = content;
        }
      } catch (_) {
        continue;
      }

      final lines = content.split(RegExp(r'\n+'));
      String? currentSection;
      String? currentSubSection;

      for (int i = 1; i < lines.length; i++) {
        final line = lines[i];

        if (line.startsWith('## ')) {
          currentSection = line.replaceFirst('## ', '').trim();
          currentSubSection = null;
        } else if (line.startsWith('### ')) {
          currentSubSection = line.replaceFirst('### ', '').trim();
        }

        if (line.toLowerCase().contains(lowerQuery)) {
          String snippet = line.trim();
          if (i + 1 < lines.length) {
            snippet += "\n${lines[i + 1].trim()}";
          }
          matches.add(
            _SearchResult(
              articleName: articleName,
              mdPath: mdPath,
              snippet: snippet,
              section: currentSection ?? 'Introduction',
              subSection: currentSubSection,
              query: query,
            ),
          );
        }
      }
    }

    setState(() {
      _results = matches;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search in articles...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _onQueryChanged,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Searching...", style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    if (_query.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 56, color: Colors.grey),
            SizedBox(height: 16),
            Text("Type to search articles", style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    if (_query.length < 3) {
      return const Center(
        child: Text("Type at least 3 characters to search"),
      );
    }

    if (_results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied, size: 56, color: Colors.grey),
            SizedBox(height: 16),
            Text("No results found", style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final result = _results[i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                result.articleName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      if (result.section != null)
                        Chip(
                          label: Text(result.section!),
                          avatar: const Icon(Icons.folder_open, size: 18),
                          backgroundColor: Colors.blue.shade50,
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                      if (result.subSection != null)
                        Chip(
                          label: Text(result.subSection!),
                          avatar: const Icon(Icons.subdirectory_arrow_right, size: 18),
                          backgroundColor: Colors.orange.shade50,
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildHighlightedSnippet(result.snippet, result.query),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => ArticleScreen(
                      mdfile: result.mdPath,
                      title: result.articleName,
                      initialSearch: result.query,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHighlightedSnippet(String snippet, String query) {
    final lowerSnippet = snippet.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final start = lowerSnippet.indexOf(lowerQuery);
    if (start < 0) {
      return GptMarkdown(
        snippet,
        style: const TextStyle(fontSize: 14),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    }
    final end = start + query.length;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: snippet.substring(0, start)),
          TextSpan(
            text: snippet.substring(start, end),
            style: const TextStyle(
              backgroundColor: Color(0xFFFFF59D), // light yellow highlight
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: snippet.substring(end)),
        ],
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 14),
    );
  }
}

class _SearchResult {
  final String articleName;
  final String mdPath;
  final String snippet;
  final String query;
  final String? section;
  final String? subSection;

  _SearchResult({
    required this.articleName,
    required this.mdPath,
    required this.snippet,
    required this.query,
    this.section,
    this.subSection,
  });
}
