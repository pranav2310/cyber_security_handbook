import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gpt_markdown/gpt_markdown.dart';

class MarkdownPage extends StatefulWidget {
  const MarkdownPage({
    super.key,
    required this.mdfile,
    required this.title,
  });

  final String mdfile;
  final String title;

  @override
  State<MarkdownPage> createState() => _MarkdownPageState();
}

class _MarkdownPageState extends State<MarkdownPage> {
  Map<String, dynamic> _markdownContent = {};
  bool _isLoading = true;
  String? _errorMessage;

  Map<String, dynamic> parseMarkdown(String markdown) {
    final h1Pattern = RegExp(r'^# (.+)$', multiLine: true);
    final h2Pattern = RegExp(r'^## (.+)$', multiLine: true);
    final h3Pattern = RegExp(r'^### (.+)$', multiLine: true);

    // Find H1
    final h1Match = h1Pattern.firstMatch(markdown);
    String mainTitle = h1Match?.group(1)?.trim() ?? 'Untitled';

    int contentStart = h1Match != null ? h1Match.end : 0;
    String contentAfterH1 = markdown.substring(contentStart).trim();

    // Find all H2s
    final h2Matches = h2Pattern.allMatches(contentAfterH1).toList();
    List<Map<String, dynamic>> sections = [];

    for (int i = 0; i < h2Matches.length; i++) {
      final sectionTitle = h2Matches[i].group(1)?.trim() ?? 'Untitled Section';
      final sectionStart = h2Matches[i].end;
      final sectionEnd = (i + 1 < h2Matches.length)
          ? h2Matches[i + 1].start
          : contentAfterH1.length;
      final sectionContent = contentAfterH1.substring(sectionStart, sectionEnd).trim();

      // Find all H3s within this section
      final h3Matches = h3Pattern.allMatches(sectionContent).toList();
      List<Map<String, String>> subSections = [];
      String? sectionIntro;

      if (h3Matches.isNotEmpty) {
        // Section intro is before the first H3
        sectionIntro = sectionContent.substring(0, h3Matches[0].start).trim();
        for (int j = 0; j < h3Matches.length; j++) {
          final subTitle = h3Matches[j].group(1)?.trim() ?? 'Untitled Subsection';
          final subStart = h3Matches[j].end;
          final subEnd = (j + 1 < h3Matches.length)
              ? h3Matches[j + 1].start
              : sectionContent.length;
          final subContent = sectionContent.substring(subStart, subEnd).trim();
          subSections.add({'title': subTitle, 'content': subContent});
        }
      } else {
        sectionIntro = sectionContent;
      }

      sections.add({
        'title': sectionTitle,
        'intro': sectionIntro,
        'subsections': subSections,
      });
    }

    // Get intro (before first H2)
    String intro = h2Matches.isNotEmpty
        ? contentAfterH1.substring(0, h2Matches[0].start).trim()
        : contentAfterH1.trim();

    return {
      'mainTitle': mainTitle,
      'intro': intro,
      'sections': sections,
    };
  }



  @override
  void initState() {
    super.initState();
    loadMarkdown();
  }

  Future<void> loadMarkdown() async {
    try {
      final content = await rootBundle.loadString(widget.mdfile);
      setState(() {
        _markdownContent = parseMarkdown(content);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load content: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final List<GlobalKey> sectionKeys = [];
    final sections = (_markdownContent['sections'] as List<dynamic>? ?? []);
    for (int i = 0; i < sections.length; i++) {
      sectionKeys.add(GlobalKey());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_markdownContent['mainTitle']?.toString() ?? widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text(_markdownContent['mainTitle'] ?? widget.title)),
            ... List.generate(sections.length, (i) {
              final title = sections[i]['title'] as String? ?? '';
              return ListTile(
                title: Text(title),
                onTap: (){
                  Navigator.pop(context);
                  _scrollController.animateTo(
                    3, // The pixel offset for the section
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              );
            }),
            ListTile(
              title: Text('Home'),
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
  controller: _scrollController,
  children: [
    if (_markdownContent['intro'] != null && (_markdownContent['intro'] as String).isNotEmpty)
      GptMarkdown(_markdownContent['intro']),
    ...List.generate(sections.length, (i) {
      final section = sections[i];
      final title = section['title'] as String? ?? '';
      final intro = section['intro'] as String? ?? '';
      final subSections = section['subsections'] as List<dynamic>? ?? [];
      return Container(
        key: sectionKeys[i],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (intro.isNotEmpty) ...[
              const SizedBox(height: 8),
              GptMarkdown(intro),
            ],
            if (subSections.isNotEmpty)
              ...subSections.map((sub) {
                final subTitle = sub['title'] as String? ?? '';
                final subContent = sub['content'] as String? ?? '';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      subTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    GptMarkdown(subContent),
                  ],
                );
              }),
          ],
        ),
      );
    }),
  ],
)


                ),
    );
  }
}
