import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '名言ストック',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuotePage(),
    );
  }
}

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  final TextEditingController _quoteController = TextEditingController();
  List<String> _quotes = [];

  @override
  void initState() {
    super.initState();
    _loadSavedQuotes();
  }

  void _loadSavedQuotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _quotes = prefs.getStringList('quotes') ?? [];
    });
  }

  void _saveQuote(String quote) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _quotes.add(quote);
      prefs.setStringList('quotes', _quotes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('名言ストック'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _quoteController,
            decoration: InputDecoration(
              hintText: '名言を入力してください',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _saveQuote(_quoteController.text);
              _quoteController.clear();
            },
            child: Text('追加'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _quotes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_quotes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
