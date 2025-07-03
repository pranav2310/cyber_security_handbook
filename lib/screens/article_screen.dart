import 'package:cyber_security/widgets/article_search.dart';
import 'package:cyber_security/widgets/section_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({
    super.key,
    required this.mdfile,
    required this.title,
    required this.initialSearch,
  });

  final String mdfile;
  final String title;
  final String? initialSearch;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  Map<String, dynamic> _markdownContent = {};
  bool _isLoading = true;
  String? _errorMessage;
  double _fontSize = 16.0;

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int _currentSectionIndex = 0;

  bool _showScrollToTop = false;

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
      final sectionContent = contentAfterH1
          .substring(sectionStart, sectionEnd)
          .trim();

      final h3Matches = h3Pattern.allMatches(sectionContent).toList();
      List<Map<String, String>> subSections = [];
      String? sectionIntro;

      if (h3Matches.isNotEmpty) {
        sectionIntro = sectionContent.substring(0, h3Matches[0].start).trim();
        for (int j = 0; j < h3Matches.length; j++) {
          final subTitle =
              h3Matches[j].group(1)?.trim() ?? 'Untitled Subsection';
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

    return {'mainTitle': mainTitle, 'intro': intro, 'sections': sections};
  }

  void _onItemPositionsChanged(){
    final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        // Find first visible item
        final minIndex = positions.map((e) => e.index).reduce((a, b) => a < b ? a : b);
        final firstVisible = positions
            .where((pos) => pos.itemLeadingEdge >= 0)
            .map((pos) => pos.index)
            .fold<int>(0, (prev, curr) => curr < prev ? curr : prev);
        final hasIntro =
            _markdownContent['intro'] != null &&
            (_markdownContent['intro'] as String).isNotEmpty;
        setState(() {
          _showScrollToTop = minIndex > 0;
          _currentSectionIndex = hasIntro ? firstVisible - 1 : firstVisible;
          if (_currentSectionIndex < 0) _currentSectionIndex = 0;
        });
      }
  }

  @override
  void initState() {
    super.initState();
    loadMarkdown();

    // Listen to scroll position to update current section index
    _itemPositionsListener.itemPositions.addListener(_onItemPositionsChanged);
  }

  Future<void> loadMarkdown() async {
    try {
      final content = await rootBundle.loadString(widget.mdfile);
      final parsedContent = parseMarkdown(content);
      setState(() {
        _markdownContent = parsedContent;
        _isLoading = false;
      });
      if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((ctx) {
          _scrollToSearchTerm(widget.initialSearch!);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load content: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onItemPositionsChanged);
    super.dispose();
  }


  void _scrollToSection(int index) {
    final hasIntro =
        _markdownContent['intro'] != null &&
        (_markdownContent['intro'] as String).isNotEmpty;
    _itemScrollController.scrollTo(
      index: hasIntro ? index + 1 : index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToSearchTerm(String searchTerm) {
    final List<Map<String, dynamic>> sections =
        (_markdownContent['sections'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];
    final hasIntro =
        _markdownContent['intro'] != null &&
        (_markdownContent['intro'] as String).isNotEmpty;

    if (hasIntro) {
      final intro = _markdownContent['intro'] as String;
      if (intro.toLowerCase().contains(searchTerm.toLowerCase())) {
        _itemScrollController.scrollTo(
          index: 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        return;
      }
    }

    for (int sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
      final section = sections[sectionIndex];

      final title = section['title'] as String? ?? '';
      if (title.toLowerCase().contains(searchTerm.toLowerCase())) {
        _scrollToSection(sectionIndex);
        return;
      }

      final intro = section['intro'] as String? ?? '';
      if (intro.toLowerCase().contains(searchTerm.toLowerCase())) {
        _scrollToSection(sectionIndex);
        return;
      }

      final subSections = section['subsections'] as List<dynamic>? ?? [];
      for (final sub in subSections) {
        final subTitle = sub['title'] as String? ?? '';
        final subContent = sub['content'] as String? ?? '';
        if (subTitle.toLowerCase().contains(searchTerm.toLowerCase()) ||
            subContent.toLowerCase().contains(searchTerm.toLowerCase())) {
          _scrollToSection(sectionIndex);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sections =
        (_markdownContent['sections'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e as Map))
            .toList() ??
        [];

    final hasIntro =
        _markdownContent['intro'] != null &&
        (_markdownContent['intro'] as String).isNotEmpty;

    return Scaffold(
      floatingActionButton: _showScrollToTop
        ? FloatingActionButton(
        onPressed: () {
          _itemScrollController.scrollTo(
            index: 0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        tooltip: 'Go to Top',
        child: const Icon(Icons.arrow_upward),
      ):null,
      appBar: AppBar(
        title: Text(
          _markdownContent['mainTitle']?.toString() ?? widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ArticleSearchDelegate(
                  sections: sections,
                  intro: _markdownContent['intro'] ?? '',
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'inc') {
                setState(() {
                  _fontSize = (_fontSize + 2).clamp(12.0, 32.0);
                });
              } else {
                setState(() {
                  _fontSize = (_fontSize - 2).clamp(12.0, 32.0);
                });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'font',
                child: Row(
                  children: [
                    Icon(
                      Icons.text_fields,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Slider(
                        value: _fontSize, 
                        onChanged: (val){
                          setState((){_fontSize = val;});
                        },
                        min: 12,
                        max: 32,
                        divisions: 10,
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: SectionDrawer(
        mainTitle: _markdownContent['mainTitle']?.toString() ?? widget.title,
        sections: sections,
        currentSectionIndex: _currentSectionIndex,
        onSectionTap: (i) => _scrollToSection(i),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isLoading
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading content...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              )
            )
            : _errorMessage != null
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ScrollablePositionedList.builder(
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  itemCount: sections.length + (hasIntro ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (hasIntro && index == 0) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GptMarkdown(
                            _markdownContent['intro'],
                            style: TextStyle(fontSize: _fontSize),
                          ),
                        ),
                      );
                    }
                    final sectionIndex = hasIntro ? index - 1 : index;
                    final section = sections[sectionIndex];
                    final title = section['title'] as String? ?? '';
                    final intro = section['intro'] as String? ?? '';
                    final subSections =
                        section['subsections'] as List<dynamic>? ?? [];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: Text(
                                  title,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _fontSize + 4,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              ],
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
                                    Divider(height: 32, thickness: 1.2,),
                                    const SizedBox(height: 16),
                                    Text(
                                      subTitle,
                                      style: Theme.of(context).textTheme.titleMedium
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
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
