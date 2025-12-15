import 'package:flutter_test/flutter_test.dart';
import 'package:stock_app/data/models/stock.dart';

void main() {
  group('Stock Model Tests', () {
    test('Stock constructor should create valid stock', () {
      final stock = Stock(
        stockId: '2330',
        stockName: '台積電',
        currentPrice: 580.0,
        changePrice: 5.0,
        changePercent: 0.87,
        volume: 25000000,
        open: 575.0,
        high: 582.0,
        low: 574.0,
        close: 580.0,
        yesterdayClose: 575.0,
        updateTime: DateTime.now(),
      );

      expect(stock.stockId, '2330');
      expect(stock.stockName, '台積電');
      expect(stock.currentPrice, 580.0);
      expect(stock.changePrice, 5.0);
      expect(stock.changePercent, 0.87);
    });

    test('Stock.fromJson should parse JSON correctly', () {
      final json = {
        'stockId': '2330',
        'stockName': '台積電',
        'currentPrice': 580.0,
        'changePrice': 5.0,
        'changePercent': 0.87,
        'volume': 25000000,
        'open': 575.0,
        'high': 582.0,
        'low': 574.0,
        'close': 580.0,
        'yesterdayClose': 575.0,
        'updateTime': '2024-01-01T12:00:00.000Z',
      };

      final stock = Stock.fromJson(json);

      expect(stock.stockId, '2330');
      expect(stock.stockName, '台積電');
      expect(stock.currentPrice, 580.0);
    });

    test('Stock.toJson should convert to JSON correctly', () {
      final stock = Stock(
        stockId: '2330',
        stockName: '台積電',
        currentPrice: 580.0,
        changePrice: 5.0,
        changePercent: 0.87,
        volume: 25000000,
        open: 575.0,
        high: 582.0,
        low: 574.0,
        close: 580.0,
        yesterdayClose: 575.0,
        updateTime: DateTime.parse('2024-01-01T12:00:00.000Z'),
      );

      final json = stock.toJson();

      expect(json['stockId'], '2330');
      expect(json['stockName'], '台積電');
      expect(json['currentPrice'], 580.0);
      expect(json['volume'], 25000000);
    });

    test('Stock.copyWith should create copy with updated fields', () {
      final stock = Stock(
        stockId: '2330',
        stockName: '台積電',
        currentPrice: 580.0,
        changePrice: 5.0,
        changePercent: 0.87,
        volume: 25000000,
        open: 575.0,
        high: 582.0,
        low: 574.0,
        close: 580.0,
        yesterdayClose: 575.0,
        updateTime: DateTime.now(),
      );

      final updatedStock = stock.copyWith(
        currentPrice: 585.0,
        changePrice: 10.0,
      );

      expect(updatedStock.currentPrice, 585.0);
      expect(updatedStock.changePrice, 10.0);
      expect(updatedStock.stockId, '2330'); // Unchanged
      expect(updatedStock.stockName, '台積電'); // Unchanged
    });

    test('Stock.fromYahooJson should parse Yahoo Finance response', () {
      final yahooResponse = {
        'chart': {
          'result': [
            {
              'meta': {
                'regularMarketPrice': 580.0,
                'chartPreviousClose': 575.0,
                'previousClose': 575.0,
                'regularMarketOpen': 575.0,
                'regularMarketDayHigh': 582.0,
                'regularMarketDayLow': 574.0,
                'regularMarketVolume': 25000000,
              }
            }
          ]
        }
      };

      final stock = Stock.fromYahooJson(yahooResponse, '2330', '台積電');

      expect(stock.stockId, '2330');
      expect(stock.stockName, '台積電');
      expect(stock.currentPrice, 580.0);
      expect(stock.yesterdayClose, 575.0);
      expect(stock.open, 575.0);
      expect(stock.high, 582.0);
      expect(stock.low, 574.0);
      expect(stock.volume, 25000000);
      
      // Calculated values
      expect(stock.changePrice, 5.0); // 580 - 575
      expect(stock.changePercent, closeTo(0.87, 0.01)); // (5/575) * 100
    });

    test('Stock toString should return readable string', () {
      final stock = Stock(
        stockId: '2330',
        stockName: '台積電',
        currentPrice: 580.0,
        changePrice: 5.0,
        changePercent: 0.87,
        volume: 25000000,
        open: 575.0,
        high: 582.0,
        low: 574.0,
        close: 580.0,
        yesterdayClose: 575.0,
        updateTime: DateTime.now(),
      );

      final str = stock.toString();
      expect(str, contains('2330'));
      expect(str, contains('台積電'));
      expect(str, contains('580.0'));
    });
  });
}
