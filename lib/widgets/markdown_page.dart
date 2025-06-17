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
  String _markdownContent = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    loadMarkdown();
  }

  Future<void> loadMarkdown() async {
    try {
      final content = await rootBundle.loadString(widget.mdfile);
      setState(() {
        _markdownContent = content;
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GptMarkdown(
                    _markdownContent,
                  ),
              ),
    );
  }
}
