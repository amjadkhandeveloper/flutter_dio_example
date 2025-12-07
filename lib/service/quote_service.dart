import 'dart:io';

import 'package:dio_example/model/quote_model.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class QuoteService {
  late final Dio _dio;

  QuoteService() {
    _dio = Dio();
    // Configure Dio with proper settings
    _dio.options.baseUrl = 'https://api.quotable.io';
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // For development: bypass certificate validation
    // WARNING: Only use this in development, not production!
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
  }

  Future<List<QuoteModel>> getQuotes() async {
    try {
      final response = await _dio.get('/quotes');

      print('Response: ${response.data}');

      // Quotable.io API returns data in 'results' key
      final List data = response.data['results'];

      print('Data: $data');

      List<QuoteModel> quotes = data
          .map((e) => QuoteModel.fromJson(e))
          .toList();

      return quotes;
    } catch (e) {
      print('Error fetching quotes: $e');
      if (e is DioException) {
        print('Dio error: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      }
      return []; // Return empty list on error
    }
  }
}
