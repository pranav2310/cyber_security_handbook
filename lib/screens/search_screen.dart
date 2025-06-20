import 'package:cyber_security/screens/article_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulWidget{
  const SearchScreen({
    super.key,
    required this.gridItems
  });

  final Map<String, List<dynamic>>gridItems;

  @override
  State<StatefulWidget> createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends State<SearchScreen>{
  String _query = '';
  List<_SearchResult> _results = [];
  bool _isLoading = false;

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _query = query;
      _results.clear();
    });
    final lowerQuery = query.toLowerCase();
    final List<_SearchResult> matches = [];

    for(final entry in widget.gridItems.entries){
      final articleName = entry.key;
      final mdPath = entry.value[0] as String;
      String content;
      try{
        content = await rootBundle.loadString(mdPath);
      }catch(_){
        continue;
      }
      final lines = content.split(RegExp(r'\n+'));
      for(final line in lines){
        if(line.toLowerCase().contains(lowerQuery)){
          matches.add(_SearchResult(
            articleName:  articleName,
            mdPath: mdPath,
            snippet:line.trim(),
            query:query,
          ));
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
            border: InputBorder.none
          ),
          onChanged: _performSearch,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, i){
              final result = _results[i];
              return ListTile(
                title: Text(result.articleName),
                subtitle: Text(
                  result.snippet,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (ctx)=>ArticleScreen(
                      mdfile: result.mdPath, 
                      title: result.articleName,
                      initialSearch: result.query
                    ))
                  );
                },
              );
            },
            )
    );
  }
}

class _SearchResult{
  final String articleName;
  final String mdPath;
  final String snippet;
  final String query;
  _SearchResult({
    required this.articleName,
    required this.mdPath,
    required this.snippet,
    required this.query
  });
}