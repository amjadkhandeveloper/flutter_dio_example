class QuoteModel {
  final String id;
  final String quote;
  final String author;

  QuoteModel({required this.id, required this.quote, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['_id'],
      quote: json['content'],
      author: json['author'],
    );
  }
}
