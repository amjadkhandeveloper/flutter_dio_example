import 'package:dio_example/model/quote_model.dart';
import 'package:dio_example/service/quote_service.dart';
import 'package:dio_example/view/quote_details.dart';
import 'package:dio_example/view/quote_view.dart';
import 'package:flutter/material.dart';

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  List<QuoteModel> _quotes = [];
  late Future<List<QuoteModel>> _quotesFuture;

  Future<List<QuoteModel>> fetchQuotes() async {
    final quotes = await QuoteService().getQuotes();
    setState(() {
      _quotes = quotes;
    });
    return quotes;
  }

  @override
  void initState() {
    super.initState();
    _quotesFuture = fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<List<QuoteModel>>(
        future: _quotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _quotesFuture = fetchQuotes();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            // Update _quotes with the fetched data
            if (_quotes != snapshot.data!) {
              _quotes = snapshot.data!;
            }
            return ListView.builder(
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuoteDetails(quote: _quotes[index]),
                      ),
                    );
                  },
                  child: QuoteView(quote: _quotes[index], index: index),
                );
              },
            );
          }
        },
      ),
    );
  }
}
