import 'dart:async';

import 'package:cyber_security/screens/article_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.gridItems});

  final Map<String, List<dynamic>> gridItems;

  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
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

  Future<void> _performSearch(String query) async {
    // Cancel previous timer if active
    _debounceTimer?.cancel();

    setState(() {
      _query = query;
      _isLoading = true;
      _results.clear();
    });

    // Skip short queries
    if (query.isEmpty || query.length < 3) {
      setState(() => _isLoading = false);
      return;
    }

    // Implement debounce (500ms delay)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final lowerQuery = query.toLowerCase();
      final List<_SearchResult> matches = [];

      for (final entry in widget.gridItems.entries) {
        final articleName = entry.key;
        final mdPath = entry.value[0] as String;

        String content;
        try {
          // Use cached content if available
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
        int startIdx = 1;
        String? currentSection;
        String? currentSubSection;

        for (int i = startIdx; i < lines.length; i++) {
          final line = lines[i];

          // Track section hierarchy
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
          onChanged: _performSearch,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_query.isEmpty) {
      return const Center(child: Text("Type to search articles"));
    }

    if (_query.length < 3) {
      return const Center(child: Text("Type at least 3 characters"));
    }

    if (_results.isEmpty) {
      return const Center(child: Text("No results found"));
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final result = _results[i];
        return ListTile(
          title: Text(
            result.articleName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.section != null) ...[
                Text(
                  "Section: ${result.section!}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
              if (result.subSection != null) ...[
                Text(
                  "Sub-section: ${result.subSection!}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
              const SizedBox(height: 4),
              GptMarkdown(
                result.snippet,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
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
        );
      },
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
