import 'package:dio/dio.dart';
import '../models/stock.dart';
import '../../core/constants/api_constants.dart';

/// Yahoo Finance data source for fetching stock data
class YahooFinanceDataSource {
  final Dio _dio;

  YahooFinanceDataSource({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.yahooFinanceBaseUrl,
                connectTimeout: const Duration(
                  milliseconds: ApiConstants.connectionTimeout,
                ),
                receiveTimeout: const Duration(
                  milliseconds: ApiConstants.receiveTimeout,
                ),
              ),
            );

  /// Fetch stock quote from Yahoo Finance
  Future<Stock> fetchStockQuote(String stockId, String stockName) async {
    try {
      final response = await _dio.get(
        ApiConstants.getChartUrl(stockId),
        queryParameters: {
          'interval': '1d',
          'range': '1d',
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return Stock.fromYahooJson(response.data, stockId, stockName);
      } else {
        throw Exception('Failed to fetch stock quote: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout while fetching stock data');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout while fetching stock data');
      } else if (e.response != null) {
        throw Exception(
          'Failed to fetch stock quote: ${e.response?.statusCode}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch stock quote: $e');
    }
  }

  /// Fetch multiple stock quotes
  Future<List<Stock>> fetchMultipleStockQuotes(
    Map<String, String> stockMap,
  ) async {
    final futures = stockMap.entries.map((entry) {
      return fetchStockQuote(entry.key, entry.value);
    }).toList();

    try {
      return await Future.wait(futures);
    } catch (e) {
      throw Exception('Failed to fetch multiple stock quotes: $e');
    }
  }

  /// Fetch historical data (K-line data)
  Future<Map<String, dynamic>> fetchHistoricalData({
    required String stockId,
    String interval = '1d',
    String range = '1mo',
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.getChartUrl(stockId),
        queryParameters: {
          'interval': interval,
          'range': range,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to fetch historical data: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch historical data: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch historical data: $e');
    }
  }
}
