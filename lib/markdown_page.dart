import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  double _fontSize = 16.0;

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  Map<String, dynamic> parseMarkdown(String markdown) {
    final h1Pattern = RegExp(r'^# (.+)$', multiLine: true);
    final h2Pattern = RegExp(r'^## (.+)$', multiLine: true);
    final h3Pattern = RegExp(r'^### (.+)$', multiLine: true);

    final h1Match = h1Pattern.firstMatch(markdown);
    String mainTitle = h1Match?.group(1)?.trim() ?? 'Untitled';

    int contentStart = h1Match != null ? h1Match.end : 0;
    String contentAfterH1 = markdown.substring(contentStart).trim();

    final h2Matches = h2Pattern.allMatches(contentAfterH1).toList();
    List<Map<String, dynamic>> sections = [];

    for (int i = 0; i < h2Matches.length; i++) {
      final sectionTitle = h2Matches[i].group(1)?.trim() ?? 'Untitled Section';
      final sectionStart = h2Matches[i].end;
      final sectionEnd = (i + 1 < h2Matches.length)
          ? h2Matches[i + 1].start
          : contentAfterH1.length;
      final sectionContent = contentAfterH1.substring(sectionStart, sectionEnd).trim();

      final h3Matches = h3Pattern.allMatches(sectionContent).toList();
      List<Map<String, String>> subSections = [];
      String? sectionIntro;

      if (h3Matches.isNotEmpty) {
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
      final parsedContent = parseMarkdown(content);
      setState(() {
        _markdownContent = parsedContent;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load content: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _scrollToSection(int index) {
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = (_markdownContent['sections'] as List<dynamic>? ?? []);
    final hasIntro = _markdownContent['intro'] != null && (_markdownContent['intro'] as String).isNotEmpty;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _itemScrollController.scrollTo(
            index: 0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        tooltip: 'Go to Top',
        child: const Icon(Icons.arrow_upward),
      ),
      appBar: AppBar(
        title: Text(
          _markdownContent['mainTitle']?.toString() ?? widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {/* Implement search */},
          ),
          PopupMenuButton<String>(
            onSelected: (value){
              if(value == 'inc'){
                setState(() {
                  _fontSize = (_fontSize + 2).clamp(12.0, 32.0);
                });
              }
              else{
                setState(() {
                  _fontSize = (_fontSize - 2).clamp(12.0, 32.0);
                });
              }
            },itemBuilder: (context)=>[
              const PopupMenuItem(
                value: 'inc',
                child: Row(
                  children: [
                    Icon(Icons.text_increase),
                    SizedBox(width: 8,),
                    Text('Increase Font Size')
                  ],
                ), 
              ),
              const PopupMenuItem(
                value: 'dec',
                child: Row(
                  children: [
                    Icon(Icons.text_decrease),
                    SizedBox(width: 8,),
                    Text('Decrease Font Size')
                  ]
                )
              ),
            ],
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_markdownContent['mainTitle']?.toString() ?? widget.title),
                  IconButton(onPressed: (){Navigator.popUntil(context, (route) => route.isFirst);}, icon: Icon(Icons.home), tooltip: 'Go Back to Home Page',)
                ],
              ),
            ),
            ...List.generate(sections.length, (i) {
              final title = sections[i]['title'] as String? ?? '';
              return ListTile(
                title: Text(title),
                onTap: () {
                  Navigator.pop(context);
                  _scrollToSection(hasIntro ? i + 1 : i);
                },
              );
            }),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ScrollablePositionedList.builder(
                    itemScrollController: _itemScrollController,
                    itemPositionsListener: _itemPositionsListener,
                    itemCount: sections.length + (hasIntro ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (hasIntro && index == 0) {
                        return GptMarkdown(
                          _markdownContent['intro'],
                          style: TextStyle(fontSize: _fontSize),
                        );
                      }
                      final sectionIndex = hasIntro ? index - 1 : index;
                      final section = sections[sectionIndex];
                      final title = section['title'] as String? ?? '';
                      final intro = section['intro'] as String? ?? '';
                      final subSections = section['subsections'] as List<dynamic>? ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _fontSize + 4,
                                ),
                          ),
                          if (intro.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            GptMarkdown(
                              intro,
                              style: TextStyle(fontSize: _fontSize),
                            ),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: _fontSize + 2,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  GptMarkdown(
                                    subContent,
                                    style: TextStyle(fontSize: _fontSize),
                                  ),
                                ],
                              );
                            }),
                        ],
                      );
                    },
                  ),
                ),
    );
  }
}
